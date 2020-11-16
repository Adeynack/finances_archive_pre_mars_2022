import React, { useState } from "react";
import { useForm } from "react-use-form-library";
import { Button } from "./Button";
import { TextInput } from "./TextInput";

export function Login(): JSX.Element {
  const [status, setStatus] = useState("idle");

  const { model, fields, onSubmit, valid, reset: resetForm } = useForm({
    model: {
      email: "",
      password: "",
    },
    handleSubmit: async () => {
      setStatus(
        `submitting email "${model.email}" with password "${model.password}"`
      );
    },
    validations: {
      email: ["required", "email"],
      password: "required",
    },
  });

  const reset = (): void => {
    resetForm();
    setStatus("resetted");
  };

  return (
    <>
      <h1>Login</h1>
      <div>Status: {status}</div>
      <div>Valid: {valid ? "true" : "false"}</div>
      <form>
        <TextInput label="E-Mail" {...fields.email} />
        <TextInput label="Password" {...fields.password} />
      </form>
      <Button title="Login" disabled={!valid} onClick={onSubmit} />
      <Button title="Reset" onClick={reset} />
    </>
  );
}
