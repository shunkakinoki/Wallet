import styled from "@emotion/styled";

export const ConfirmButtonContainer = styled.div`
  display: flex;
  align-items: center;
  margin-right: 12px;
`;

type ConfirmButtonProps = {
  option: "cancel" | "approve";
};

export const Button = styled.button`
  cursor: pointer;
  pointer-events: auto;

  padding: 9px 0px;
  width: 100%;
  font-size: 21px;
  font-weight: 400;

  background-color: ${(props: ConfirmButtonProps) => {
    return props.option === "approve" ? "#241f1f" : "#dbd6d6";
  }};
  color: ${(props: ConfirmButtonProps) => {
    return props.option === "approve" ? "white" : "#a29999";
  }};
  border-width: 0px;
  border-radius: 30px;

  transition: background-color 200ms ease, transform 150ms ease;

  &:hover {
    background-color: ${(props: ConfirmButtonProps) => {
      return props.option === "approve" ? "#4b4a4a" : "#cbc6c6";
    }};
  }
`;
