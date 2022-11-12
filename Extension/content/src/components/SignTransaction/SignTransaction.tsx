import type { FC } from "react";

import { useEffect, useState } from "react";

import { useTransactionGasConfig } from "../../hooks/useTransactionGasConfig";

import { useTransactionGasPrice } from "../../hooks/useTransactionGasPrice";

import { logContent } from "../../services/log";
import { sendMessageToNativeApp } from "../../services/sendMessageToNativeApp";
import { ConfirmButton } from "../Base/ConfirmButton";

import {
  SignTransactionDescriptionContainer,
  SignTransactionGasContainer,
  SignTransactionGasSelectContainer,
  SignTransactionGasSelect,
  SignTransactionGasSelectSVGContainer,
  SignTransactionGasSelectSVG,
} from "./SignTransaction.styles";

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
  const [gasPrice] = useTransactionGasPrice(state => {
    return [state.gasPrice];
  });

  return (
    <ConfirmButton
      id={id}
      onConfirmText="Approve"
      onConfirmClick={() => {
        let nonceVar: any;

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
                gasPrice: gasPrice,
                nonce: nonceVar,
              },
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

  const [config, setConfig] = useTransactionGasConfig(state => {
    return [state.config, state.setConfig];
  });
  const [gasPrice, setGasPrice] = useTransactionGasPrice(state => {
    return [state.gasPrice, state.setGasPrice];
  });

  useEffect(() => {
    console.log(config);
    if (config) {
      fetch(
        `https://wallet-dyrsoiex2-lightdotso.vercel.app/api/gas/${window.ethereum.chainId}`,
        {
          method: "POST",
          body: JSON.stringify(config),
        },
      )
        .then(response => {
          return response.json();
        })
        .then(data => {
          logContent(`GasPrice result: ${JSON.stringify(data)}`);
          if (data && data?.gasPrice) {
            setGasPrice(JSON.parse(data)?.gasPrice);
          } else {
            throw "No gasPrice";
          }
        })
        .catch(err => {
          logContent(`Error gas: ${JSON.stringify(err)}`);
          if (window.ethereum.storybook) {
            setGasPrice("0x69");
            return;
          }
          window.ethereum.rpc
            .call({
              jsonrpc: "2.0",
              method: "eth_gasPrice",
              params: [],
              id: 1,
            })
            .then(response => {
              setGasPrice(response.result);
            });
        });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
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
    return (
      <SignTransactionDescriptionContainer>
        <SignTransactionGasContainer>
          <div>{gasPrice}</div>
          <SignTransactionGasSelectContainer>
            <SignTransactionGasSelect
              value={config.legacySpeed}
              onChange={e => {
                setConfig({ legacySpeed: e.target.value });
              }}
            >
              <option value="instant">🚨 Instant</option>
              <option value="fast">🏄‍♂️ Fast</option>
              <option value="standard">🚗 Standard</option>
              <option value="low">🐢 Slow</option>
            </SignTransactionGasSelect>
            <SignTransactionGasSelectSVGContainer>
              <SignTransactionGasSelectSVG
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                strokeWidth="2"
                stroke="currentColor"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  d="M8.25 15L12 18.75 15.75 15m-7.5-6L12 5.25 15.75 9"
                />
              </SignTransactionGasSelectSVG>
            </SignTransactionGasSelectSVGContainer>
          </SignTransactionGasSelectContainer>
        </SignTransactionGasContainer>
      </SignTransactionDescriptionContainer>
    );
  }

  return null;
};

export const shortenName = (name: string) => {};
