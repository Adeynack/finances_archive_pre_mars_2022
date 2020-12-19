import { useEffect, useState } from "react";
import {
  LOGIN_MUTATION,
  LOGOUT_MUTATION,
  ME_QUERY,
} from "../queries/sessionQueries";
import {
  apollo,
  writeDB,
  deleteAbsentsFromDatabase,
  useDatabase,
} from "../store";
import { AccessibleBook, Book, BookRoleType } from "./book";

export interface CurrentUser {
  id: string;
  email: string;
  displayName: string;
}

export interface Me extends CurrentUser {
  bookRoles: {
    book: Book;
    role: BookRoleType;
    effectiveRoles: BookRoleType[];
  }[];
}

function processMeInformation(me: Me): void {
  if (!me) {
    writeDB.set("currentUser", null);
    writeDB.table("books").truncate();
    return;
  }

  const currentUser: CurrentUser = me;
  writeDB.set("currentUser", currentUser);

  const accessibleBooks: AccessibleBook[] = me.bookRoles.map(b => ({
    ...b.book,
    role: b.role.toLowerCase() as BookRoleType,
    effectiveRoles: b.effectiveRoles.map(r => r.toLowerCase() as BookRoleType),
  }));
  deleteAbsentsFromDatabase(writeDB.table("books"), accessibleBooks);
  writeDB.table("books").upsert(accessibleBooks);
}

export async function login(email: string, password: string): Promise<void> {
  const result = await apollo.mutate({
    mutation: LOGIN_MUTATION,
    variables: { email, password },
  });
  const me: Me | null = result.data.login.me;
  if (me) {
    processMeInformation(me);
  } else {
    throw Error("Login failed");
  }
}

export async function logout(): Promise<void> {
  await apollo.mutate({ mutation: LOGOUT_MUTATION });
  writeDB.set("currentUser", null);
  writeDB.table("books").truncate();
}

export async function refreshMe(): Promise<Me | null> {
  const result = await apollo.query({ query: ME_QUERY });
  const me: Me | null = result.data.me;
  if (me) {
    processMeInformation(me);
  }
  return me;
}

export function useCurrentUser(
  { fetch }: { fetch: boolean } = { fetch: false }
): { currentUser: Me | undefined; fetchingCurrentUser: boolean } {
  const [fetchingCurrentUser, setFetchingCurrentUser] = useState(fetch);
  const currentUser = useDatabase(db => db.get("currentUser"));
  useEffect(() => {
    const fetchMe = async (): Promise<void> => {
      if (fetch) {
        await refreshMe(); // .then(() => {
        setFetchingCurrentUser(false);
        // });
      }
    };
    fetchMe();
  }, []);
  return { currentUser, fetchingCurrentUser };
}
