import { writeDB } from "../store";

export interface Alert {
  id: string;
  title: string;
  message: string;
}

export function handleError(error: Error): void {
  const alert = {
    title: error.name,
    message: error.message,
  };
  writeDB.table("alerts").insert(alert);
  console?.error(error); // eslint-disable-line no-console
}

export async function dismissAlert(alert: { id: string }): Promise<void> {
  writeDB.table("alerts").delete(alert);
}
