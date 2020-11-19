import React from "react";
import { dismissAlert } from "../models/error";
import { useDatabase } from "../store";
import { Button } from "./Button";

export function AlertList(): JSX.Element {
  const alerts = useDatabase(db => db.table("alerts").all);
  return (
    <div>
      Error count: {alerts.length}
      <ul>
        {alerts.map(alert => (
          <li key={alert.id}>
            <Button title="X" onClick={() => dismissAlert(alert)} />
            test {alert.title}: {alert.message}
          </li>
        ))}
      </ul>
    </div>
  );
}
