import type { FC } from "react";

import { useEffect, useState } from "react";

import { useTransactionGasPrice } from "../../hooks/useTransactionGasPrice";

import { logContent } from "../../services/log";
import { sendMessageToNativeApp } from "../../services/sendMessageToNativeApp";
import { ConfirmButton } from "../Base/ConfirmButton";

import { SignTransactionDescriptionContainer } from "./SignTransaction.styles";

type SignTransactionParams = {
  id: number;
  method: string;
  params: any;
};

export const SignTransaction: FC<SignTransactionParams> = ({
  id,
  method,
  params,
}) => {
  return (
    <ConfirmButton
      id={id}
      onConfirmText="Approve"
      onConfirmClick={() => {
        let gasPriceVar: any;
        let nonceVar: any;
        window.ethereum.rpc
          .call({
            jsonrpc: "2.0",
            method: "eth_gasPrice",
            params: [],
            id: 1,
          })
          .then(response => {
            gasPriceVar = response.result;
          })
          .then(() => {
            window.ethereum.rpc
              .call({
                jsonrpc: "2.0",
                method: "eth_getTransactionCount",
                params: [params.from, "pending"],
                id: 1,
              })
              .then(response => {
                nonceVar = response.result;
              })
              .then(() => {
                sendMessageToNativeApp({
                  id: id,
                  method: method,
                  params: {
                    ...params,
                    value: params?.value ?? "0x0",
                    chainId: window.ethereum.chainId,
                    gasPrice: gasPriceVar,
                    nonce: nonceVar,
                  },
                });
              });
          });
      }}
    />
  );
};

export const SignTransactionDescription: FC<
  Pick<SignTransactionParams, "params">
> = ({ params }) => {
  const [result, setResult] = useState(null);

  const [config] = useTransactionGasPrice(state => {
    return [state.config];
  });

  useEffect(() => {
    console.log(config);
    if (config) {
      fetch(`https://wallet-8hn88eklk-lightdotso.vercel.app/api/gas/0x1`, {
        method: "GET",
      })
        .then(response => {
          return response.json();
        })
        .then(data => {
          logContent(`Gas message result: ${JSON.stringify(data)}`);
          return setResult(data);
        })
        .catch(err => {
          logContent(`Error gas: ${JSON.stringify(err)}`);
        });
    }
  }, [config]);

  useEffect(() => {
    if (
      params?.from &&
      params?.to &&
      params?.value &&
      params?.data &&
      (window.ethereum.chainId == "0x1" || window.ethereum.chainId == "0x5")
    ) {
      logContent("Starting fetch...");
      fetch(
        `https://wallet.light.so/api/blowfish/ethereum/v0/${
          window.ethereum.chainId == "0x1" ? "mainnet" : "goerli"
        }/scan/transaction`,
        {
          method: "POST",
          body: JSON.stringify({
            metadata: { origin: `https://${window.location.host}` },
            userAccount: params.from,
            txObject: {
              from: params.from,
              to: params.to,
              data: params.data,
              value: params?.value ?? "0x0",
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

  if (params?.from && params?.to && params?.value && params?.data) {
    return <SignTransactionDescriptionContainer />;
  }

  return null;
};
