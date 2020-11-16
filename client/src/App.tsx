import React from "react";
import "./App.css";
import { Login } from "./components/Login";
import { useDatabase, writeDB } from "./store";

function App(): JSX.Element {
  const buttonEnabled = useDatabase((db) => db.get("counterButtonEnabled"));
  const counter = useDatabase(
    (db) => db.table("counters").find("buttonClicks")?.value ?? 0
  );

  function incrementCounter(): void {
    writeDB
      .table("counters")
      .upsert({ id: "buttonClicks", value: counter + 1 });
  }

  function toggleButtonEnabled(): void {
    writeDB.set("counterButtonEnabled", !buttonEnabled);
  }

  return (
    <div className="App">
      <header className="App-header">
        <Login />
        <p>
          You clicked {counter} time{counter > 1 ? "s" : ""} on this button:{" "}
          <button disabled={!buttonEnabled} onClick={incrementCounter}>
            The Button
          </button>
          .
        </p>
        <button onClick={toggleButtonEnabled}>
          {buttonEnabled
            ? "Disable increment button"
            : "Enable increment button"}
        </button>
      </header>
    </div>
  );
}

export default App;
