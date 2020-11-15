import React from "react";
import { render, screen } from "@testing-library/react";
import App from "./App";

test("clicks counter is 0 at first", () => {
  render(<App />);
  const label = screen.getByText(/You clicked 0 time on this button/i);
  expect(label).toBeInTheDocument();
});

test("clicking on The Button™️ increments the counter", () => {
  render(<App />);
  const theButton = screen.getByText("The Button");
  theButton.click();

  const label = screen.getByText(/You clicked 1 time on this button/i);
  expect(label).toBeInTheDocument();
});
