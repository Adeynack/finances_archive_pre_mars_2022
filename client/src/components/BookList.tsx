import React from "react";
import { useDatabase } from "../store";

export function BookList(): JSX.Element {
  const books = useDatabase(db => db.table("books").all);
  return (
    <div>
      <ul>
        {books.map(book => (
          <li key={book.id}>
            <strong>{book.name}</strong>, owned by {book.owner.displayName},
            with role "{book.role}" (implying {book.effectiveRoles.join(", ")})
          </li>
        ))}
      </ul>
    </div>
  );
}
