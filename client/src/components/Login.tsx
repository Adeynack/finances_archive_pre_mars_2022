import React, { useState } from "react";
import { useForm } from "react-use-form-library";
import { login, logout } from "../models/currentUser";
import { handleError } from "../models/error";
import { useDatabase } from "../store";
import { Button } from "./Button";
import { TextInput } from "./TextInput";

export function Login(): JSX.Element {
  const [status, setStatus] = useState("Waiting for credentials");
  const currentUser = useDatabase(db => db.get("currentUser"));

  const { model, fields, onSubmit, valid } = useForm({
    model: {
      email: "joe@foobar.com",
      password: "joe",
    },
    handleSubmit: async () => {
      try {
        setStatus("Sending credentials to server");
        await login(model.email, model.password);
        setStatus("Logged in!");
      } catch (error) {
        handleError(error);
        setStatus("Failed");
      }
    },
    validations: {
      email: ["required", "email"],
      password: "required",
    },
  });

  return (
    <>
      <h1>Login</h1>
      {currentUser && <h2>Logged in as {currentUser.displayName}</h2>}
      <div>Status: {status}</div>
      <form>
        <TextInput label="E-Mail" {...fields.email} />
        <TextInput label="Password" {...fields.password} />
      </form>
      {!currentUser && (
        <Button title="Login" disabled={!valid} onClick={onSubmit} />
      )}
      {currentUser && (
        <Button
          title="Logout"
          disabled={!currentUser}
          onClick={() => logout()}
        />
      )}
    </>
  );
}
