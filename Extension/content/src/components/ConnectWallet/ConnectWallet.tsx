import type { FC } from "react";

import { useEffect, useState } from "react";

import { useTransactionError } from "../../hooks/useTransactionError";
import { AlertIcon } from "../../icons/AlertIcon";

import { logContent } from "../../services/log";
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
  const [result, setResult] = useState(null);

  const [setError] = useTransactionError(state => {
    return [state.setError];
  });

  useEffect(() => {
    logContent("Starting fetch...");
    fetch(`https://wallet.light.so/api/blowfish/v0/domains`, {
      method: "POST",
      body: JSON.stringify({
        domains: [
          params.isPhishing
            ? "https://alertnfts.org"
            : window.location.host.startsWith("localhost")
            ? "https://light.so"
            : `https://${window.location.host}`,
        ],
      }),
    })
      .then(response => {
        return response.json();
      })
      .then(data => {
        logContent(`Scan domain result: ${JSON.stringify(data)}`);
        if (data && data[0]?.risk_score > 0.3) {
          setError(true);
        }
        return setResult(data);
      })
      .catch(err => {
        logContent(`Error scan: ${JSON.stringify(err)}`);
      });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

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
          {`Warning! Detected malisious site at https://${window.location.host}`}
        </SignTransactionErrorContainer>
      </SignTransactionContainer>
    );
  }

  return null;
};
