import React from "react";
import { guid } from "redux-database";
import styled from "styled-components";

interface Props {
  id?: string;
  label?: string;
  value?: string;
  onChange?: (value?: string) => void;
}

export function TextInput({ id, label, value, onChange }: Props): JSX.Element {
  const fieldId = id ?? guid();
  return (
    <Container>
      <Label htmlFor={fieldId}>{label}</Label>
      <Input
        value={value ?? ""}
        onChange={event => {
          onChange?.(event.currentTarget.value);
        }}
      />
    </Container>
  );
}

const Container = styled.div`
  position: relative;
  flex: 1;
`;

const Label = styled.label``;

const Input = styled.input``;
