import React from "react";
import "./App.css";
import { AlertList } from "./components/AlertList";
import { BookList } from "./components/BookList";
import { Login } from "./components/Login";
import { useCurrentUser } from "./models/currentUser";

function App(): JSX.Element {
  const { fetchingCurrentUser } = useCurrentUser({ fetch: true });
  return (
    <div className="App">
      <header className="App-header">
        {fetchingCurrentUser && <h2>Loading...</h2>}
        {!fetchingCurrentUser && (
          <>
            <Login />
            <BookList />
            <AlertList />
          </>
        )}
      </header>
    </div>
  );
}

export default App;
