import styled from "@emotion/styled";

export const SignTransactionDescriptionContainer = styled.div`
  padding: 10px 18px 23px 12px;
  word-break: break-all;
  font-size: 18px;
  font-weight: 700;
  line-height: 1.6rem;
  color: #544949;
`;

export const SignTransactionGasContainer = styled.div`
  display: flex;
  justify-content: space-between;
  align-items: center;
`;

export const SignTransactionGasSelectContainer = styled.div`
  position: relative;
  display: flex;
  justify-content: space-between;
  align-items: center;
`;

export const SignTransactionGasSelectSVGContainer = styled.div`
  display: flex;
  position: absolute;
  top: 0;
  bottom: 0;
  right: 0;
  padding-left: 0.75rem;
  align-items: center;
  pointer-events: none;
`;

export const SignTransactionGasSelect = styled.select`
  background-color: #e0e0e0;
  color: gray;
  height: 2rem;
  padding-left: 1rem;
  padding-right: 1rem;
  padding-top: 0.25rem;
  padding-bottom: 0.25rem;
  font-size: 1.25rem;
  margin-left: 1rem;
  margin-right: 0.65rem;
  border-style: none;

  option {
    direction: rtl;
    color: black;
    display: flex;
    white-space: pre;
  }
`;
