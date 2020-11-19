import React from "react";
import "./App.css";
import { AlertList } from "./components/AlertList";
import { BookList } from "./components/BookList";
import { Login } from "./components/Login";

function App(): JSX.Element {
  return (
    <div className="App">
      <header className="App-header">
        <Login />
        <BookList />
        <AlertList />
      </header>
    </div>
  );
}

export default App;
