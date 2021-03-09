import React from "react";
import styled from "styled-components";

type VoidFunction = () => void;
type AsyncFunction = () => Promise<unknown>;

interface Props {
  title?: string;
  onClick?: VoidFunction | AsyncFunction;
  disabled?: boolean;
}

export function Button({ title, onClick, disabled }: Props): JSX.Element {
  return (
    <ButtonComponent disabled={disabled} onClick={() => onClick?.()}>
      {title}
    </ButtonComponent>
  );
}

const ButtonComponent = styled.button``;
