import { User } from "./user";

export interface Book {
  id: string;
  name: string;
  owner: User;
}

export interface AccessibleBook extends Book {
  role: string;
  effectiveRoles: BookRoleType[];
}

export type BookRoleType = "reader" | "writer" | "admin" | "owner";
