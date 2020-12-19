import { ApolloClient, InMemoryCache } from "@apollo/client";
import { useEffect, useRef, useState } from "react";
import { createStore } from "redux";
import {
  DataTable,
  DB,
  emptyTable,
  MutableDB,
  reducer,
  Subscription,
} from "redux-database";
import { Alert } from "./models/error";
import { AccessibleBook } from "./models/book";
import { difference } from "lodash";
import { RowKeyOf, RowType } from "redux-database/dist/db";
import { MutableTable } from "redux-database/dist/mutable_table";
import { InsertRecord } from "redux-database/dist/util";
import { Me } from "./models/currentUser";

interface State {
  settings: {
    currentUser?: Me;
  };
  data: {
    books: DataTable<AccessibleBook>;
    alerts: DataTable<Alert>;
  };
}

const initialState: State = {
  settings: {
    currentUser: null,
  },
  data: {
    books: emptyTable,
    alerts: emptyTable,
  },
};

const store = createStore(
  reducer(initialState),
  initialState,
  (window as any).__REDUX_DEVTOOLS_EXTENSION__?.() // eslint-disable-line @typescript-eslint/no-explicit-any
);

export const writeDB = new MutableDB(initialState, { store });

// Taken and adapted from https://github.com/nerdgeschoss/redux-database/tree/master#react-integration
// define a hook to force a component to rerender:
export function useForceUpdate(): () => void {
  const [, updateState] = useState(true);
  return () => {
    updateState(state => !state);
  };
}

// Taken and adapted from https://github.com/nerdgeschoss/redux-database/tree/master#react-integration
// define a hook to use your database:
export function useDatabase<T>(query: (db: DB<State>) => T): T {
  const forceUpdate = useForceUpdate();
  const subscriptionRef = useRef<Subscription<State, T>>();
  if (!subscriptionRef.current) {
    subscriptionRef.current = writeDB.observe(query);
    subscriptionRef.current.subscribe(() => forceUpdate());
  }
  subscriptionRef.current.query = query;
  useEffect(() => {
    return () => subscriptionRef.current?.cancel();
  }, []);
  return subscriptionRef.current.current;
}

export const apollo = new ApolloClient({
  uri: "/graphql",
  cache: new InMemoryCache(),
  connectToDevTools: true,
});

// keep until redux-database supports an upsert-and-delete-absent method.
export function deleteAbsentsFromDatabase<K extends RowKeyOf<State>>(
  table: MutableTable<RowType<State, K>>,
  values: Array<InsertRecord<RowType<State, K>>>
): void {
  const currentIds = table.all.map(row => row.id);
  const remainingIds = values.map(row => row.id);
  const idsToDelete = difference(currentIds, remainingIds);
  table.delete(idsToDelete);
}
