import type { FC } from "react";

import { useEffect, useState } from "react";

import { logContent } from "../../services/log";
import { sendMessageToNativeApp } from "../../services/sendMessageToNativeApp";
import { ConfirmButton } from "../Base/ConfirmButton";

import { SignTypedMessageDescriptionContainer } from "./SignTypedMessage.styles";

type SignTypedMessageParams = {
  id: number;
  method: string;
  params: any;
};

export const SignTypedMessage: FC<SignTypedMessageParams> = ({
  id,
  method,
  params,
}) => {
  return (
    <ConfirmButton
      id={id}
      onConfirmText="Sign"
      onConfirmClick={() => {
        sendMessageToNativeApp({ id, method, params });
      }}
    />
  );
};

export const SignTypedDescription: FC<
  Pick<SignTypedMessageParams, "params">
> = ({ params }) => {
  let [result, setResult] = useState(null);

  useEffect(() => {
    if (
      params?.from &&
      params?.raw &&
      (window.ethereum.chainId == "0x1" || window.ethereum.chainId == "0x5")
    ) {
      logContent("Starting fetch...");
      fetch(
        `https://wallet.light.so/api/blowfish/${
          window.ethereum.chainId == "0x1" || window.ethereum.chainId == "0x5"
            ? "ethereum"
            : "polygon"
        }/v0/${
          window.ethereum.chainId == "0x1" || window.ethereum.chainId == "0x89"
            ? "mainnet"
            : "goerli"
        }/scan/message`,
        {
          method: "POST",
          body: JSON.stringify({
            metadata: { origin: `https://${window.location.host}` },
            userAccount: params.from,
            message: {
              kind: "SIGN_TYPED_DATA",
              data: JSON.parse(params.raw),
            },
          }),
        },
      )
        .then(response => {
          return response.json();
        })
        .then(data => {
          logContent(`Scan message result: ${JSON.stringify(data)}`);
          return setResult(data);
        })
        .catch(err => {
          logContent(`Error scan: ${JSON.stringify(err)}`);
        });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  if (params.raw && params?.from) {
    return (
      <SignTypedMessageDescriptionContainer>
        {params?.raw && JSON.stringify(params?.raw)}
      </SignTypedMessageDescriptionContainer>
    );
  }

  return null;
};
