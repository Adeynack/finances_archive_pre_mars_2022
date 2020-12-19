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
import { User } from "./user";

export interface CurrentUser extends User {
  bookRoles: {
    book: Book;
    role: BookRoleType;
    effectiveRoles: BookRoleType[];
  }[];
}

function processCurrentUserInformation(currentUser: CurrentUser): void {
  if (!currentUser) {
    writeDB.set("currentUser", null);
    writeDB.table("books").truncate();
    return;
  }

  writeDB.set("currentUser", currentUser);

  const accessibleBooks: AccessibleBook[] = currentUser.bookRoles.map(b => ({
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
  const currentUser: CurrentUser | null = result.data.login.me;
  if (currentUser) {
    processCurrentUserInformation(currentUser);
  } else {
    throw Error("Login failed");
  }
}

export async function logout(): Promise<void> {
  await apollo.mutate({ mutation: LOGOUT_MUTATION });
  writeDB.set("currentUser", null);
  writeDB.table("books").truncate();
}

export async function refreshCurrentUser(): Promise<CurrentUser | null> {
  const result = await apollo.query({ query: ME_QUERY });
  const currentUser: CurrentUser | null = result.data.me;
  if (currentUser) {
    processCurrentUserInformation(currentUser);
  }
  return currentUser;
}

export function useCurrentUser(
  { fetch }: { fetch: boolean } = { fetch: false }
): { currentUser: CurrentUser | undefined; fetchingCurrentUser: boolean } {
  const [fetchingCurrentUser, setFetchingCurrentUser] = useState(fetch);
  const currentUser = useDatabase(db => db.get("currentUser"));
  useEffect(() => {
    const fetchMe = async (): Promise<void> => {
      if (fetch) {
        await refreshCurrentUser();
      }
      setFetchingCurrentUser(false);
    };
    fetchMe();
  }, []);
  return { currentUser, fetchingCurrentUser };
}
