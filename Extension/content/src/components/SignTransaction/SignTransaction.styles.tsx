import styled from "@emotion/styled";

export const SignTransactionDescriptionContainer = styled.div`
  padding: 10px 4px 14px 4px;
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

export const SignTransactionGasEstimateContainer = styled.div`
  font-size: 18px;
  font-weight: 600;
  line-height: 1.6rem;
`;

export const SignTransactionGasEstimateFeeContainer = styled.div`
  font-size: 12px;
  font-weight: 500;
  line-height: 1rem;

  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 1;
  overflow: hidden;
`;

export const SignTransactionGasEstimateFeeSecondsContainer = styled.span`
  color: gray;
`;

export const SignTransactionGasSelectContainer = styled.div`
  position: relative;
  display: flex;
  justify-content: space-between;
  align-items: center;
  z-index: 2147483647;

  -webkit-appearance: listbox !important;
`;

export const SignTransactionGasSimulationContainer = styled.div`
  padding-top: 0.25rem;
  padding-bottom: 1.25rem;
  font-size: 18px;
  font-weight: 600;
  line-height: 1.6rem;

  word-break: keep-all;
`;

export const SignTransactionGasSimulationBlowfishContainer = styled.div`
  padding-top: 0.7rem;
`;

export const SignTransactionGasSelectAccordionContainer = styled.div`
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: 1rem;
  font-weight: 400;
  line-height: 1.25;
  cursor: pointer;

  padding-bottom: 1.25rem;
  padding-right: 0.3rem;
`;

export const SignTransactionGasSelectApproveContainer = styled.div`
  display: flex;
  align-items: center;
`;

export const SignTransactionGasSelectTransferContainer = styled.div`
  position: relative;
  display: flex;
  justify-content: space-between;
  align-items: center;

  padding-bottom: 0.3rem;
`;

export const SignTransactionGasSelectTransferNameContainer = styled.div`
  display: flex;
  align-items: center;
`;

export const SignTransactionGasSelectTransferImageContainer = styled.img`
  width: 1.75rem;
  height: 1.75rem;
  border-radius: 9999px;
  object-fit: fill;

  margin-right: 0.6rem;
`;

export const SignTransactionGasSelectTransferFallbackImageContainer = styled.span`
  display: flex;
  color: gray;

  justify-content: center;
  align-items: center;
  min-width: 1.15rem;
  min-height: 1.15rem;
  padding: 0.3rem;

  width: 1.15rem;
  height: 1.15rem;

  overflow: hidden;

  border: 1px solid gray;
  border-radius: 9999px;

  margin-right: 0.6rem;
`;

export const SignTransactionGasSelectTransferBalanceContainer = styled.div`
  font-size: 18px;
  font-weight: 600;
  line-height: 1.6rem;

  text-align: right;
`;

export const SignTransactionGasSelectTransferBalanceExpansionContainer = styled.div`
  font-size: 15px;
  font-weight: 400;
  line-height: 1.2rem;

  text-align: right;

  padding-bottom: 0.2rem;
`;

export const SignTransactionGasSelectTransferBalanceContainerSpan = styled.span`
  font-size: 12px;
  font-weight: 400;
  line-height: 1.2rem;

  padding-bottom: 0.75rem;
`;

export const SignTransactionGasSelect = styled.select`
  background-color: #e0e0e0;
  color: gray;
  height: 2rem;
  padding-top: 0.25rem;
  padding-bottom: 0.25rem;
  font-size: 1.25rem;
  margin-left: 1rem;
  border-style: none;
  text-align-last: right;

  option {
    direction: rtl;
    color: black;
    display: flex;
    white-space: pre;
  }
`;

export const InfoButton = styled.span`
  flex-shrink: 1;
`;

type DirectionType = "top" | "right" | "bottom" | "left";

interface ChevronProps {
  direction: DirectionType;
}

export const ChevronIcon = styled.div<ChevronProps>`
  border-style: solid;
  border-width: 0.125rem 0.125rem 0 0;
  height: 0.4rem;
  width: 0.4rem;
  transition: all 0.25s ease-in-out;

  transform: ${p => {
    return p.direction === "top" && "rotate(-45deg)";
  }};
  transform: ${p => {
    return p.direction === "right" && "rotate(45deg)";
  }};
  transform: ${p => {
    return p.direction === "bottom" && "rotate(135deg)";
  }};
  transform: ${p => {
    return p.direction === "left" && "rotate(-135deg)";
  }};
`;
