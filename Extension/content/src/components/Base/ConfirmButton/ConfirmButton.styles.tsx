import { keyframes } from "@emotion/react";
import styled from "@emotion/styled";

export const ConfirmButtonContainer = styled.div`
  display: flex;
  align-items: center;
  margin-right: 12px;
`;

type ConfirmButtonProps = {
  option: "cancel" | "approve" | "loading";
};

const skeletonKeyframes = keyframes`
  0% {
    background-position: -200px 0;
  }
  100% {
    background-position: calc(200px + 100%) 0;
  }
`;

export const Button = styled.button`
  cursor: pointer;
  pointer-events: ${(props: ConfirmButtonProps) => {
    return props.option === "loading" ? "none" : "auto";
  }};

  animation: ${(props: ConfirmButtonProps) => {
    return (
      props.option === "loading" &&
      `${skeletonKeyframes} 1300ms ease-in-out infinite`
    );
  }};

  padding: 9px 0px;
  width: 100%;
  font-size: 21px;
  font-weight: 400;

  background-color: ${(props: ConfirmButtonProps) => {
    return props.option === "approve"
      ? "#241f1f"
      : props.option === "cancel"
      ? "#dbd6d6"
      : "#cbc6c6";
  }};
  color: ${(props: ConfirmButtonProps) => {
    return props.option === "approve"
      ? "white"
      : props.option === "cancel"
      ? "#a29999"
      : "#a2a1a1";
  }};
  border-width: 0px;
  border-radius: 30px;

  transition: background-color 200ms ease, transform 150ms ease;

  &:hover {
    background-color: ${(props: ConfirmButtonProps) => {
      return props.option === "approve"
        ? "#4b4a4a"
        : props.option === "cancel"
        ? "#cbc6c6"
        : "#cbc6c6";
    }};
  }
`;
