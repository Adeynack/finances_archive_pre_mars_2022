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

export interface NamedCounter {
  id: string;
  value: number;
}

interface State {
  settings: {
    counterButtonEnabled: boolean;
  };
  data: {
    counters: DataTable<NamedCounter>;
  };
}

const initialState: State = {
  settings: {
    counterButtonEnabled: true,
  },
  data: {
    counters: emptyTable,
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
    updateState((state) => !state);
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
