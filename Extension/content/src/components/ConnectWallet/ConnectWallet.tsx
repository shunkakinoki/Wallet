import type { FC } from "react";

import { useBlowfishDomain } from "../../hooks/useBlowfishDomain";

import { useTransactionError } from "../../hooks/useTransactionError";
import { AlertIcon } from "../../icons/AlertIcon";

import { sendMessageToNativeApp } from "../../services/sendMessageToNativeApp";
import { ConfirmButton } from "../Base/ConfirmButton";

import {
  SignTransactionContainer,
  SignTransactionErrorContainer,
} from "./ConnectWallet.styles";

type ConnectWalletParams = {
  id: number;
  method: string;
  params: any;
};

export const ConnectWallet: FC<ConnectWalletParams> = ({
  id,
  method,
  params,
}) => {
  const [error] = useTransactionError(state => {
    return [state.error];
  });

  return (
    <ConfirmButton
      id={id}
      method="connectWallet"
      disabled={error}
      onConfirmText="Connect"
      onConfirmClick={() => {
        sendMessageToNativeApp({ id, method, params });
      }}
    />
  );
};

export const ConnectWalletDescription: FC<
  Pick<ConnectWalletParams, "params">
> = ({ params }) => {
  const { result } = useBlowfishDomain(params);

  if (result && result[0]?.risk_score > 0.3) {
    return (
      <SignTransactionContainer
        style={{
          color: "#FF453A",
        }}
      >
        <SignTransactionErrorContainer>
          <AlertIcon />
          <br />
          {`Warning! Detected malicious site at https://${window.location.host}`}
        </SignTransactionErrorContainer>
      </SignTransactionContainer>
    );
  }

  return null;
};
