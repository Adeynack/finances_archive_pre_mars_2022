import React from "react";
import { useDatabase } from "../store";

export function BookList(): JSX.Element {
  const books = useDatabase(db => db.table("books").all);
  return (
    <div>
      <ul>
        <table>
          <thead>
            <tr>
              <th style={{ verticalAlign: "top" }}>Name</th>
              <th style={{ verticalAlign: "top" }}>Owner</th>
              <th style={{ verticalAlign: "top" }}>Role</th>
              <th style={{ verticalAlign: "top" }}>Effective Roles</th>
            </tr>
          </thead>
          <tbody>
            {books.map(book => (
              <tr key={book.id}>
                <td style={{ verticalAlign: "top" }}>
                  <em>{book.name}</em>
                </td>
                <td style={{ verticalAlign: "top" }}>
                  {book.owner.displayName}
                </td>
                <td style={{ verticalAlign: "top" }}>{book.role}</td>
                <td style={{ verticalAlign: "top" }}>
                  <ul>
                    {book.effectiveRoles.map(r => (
                      <li key={r}>{r}</li>
                    ))}
                  </ul>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </ul>
    </div>
  );
}
