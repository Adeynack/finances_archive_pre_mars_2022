import { User } from "./user";

export interface Book {
  id: string;
  name: string;
  owner: User;
}
