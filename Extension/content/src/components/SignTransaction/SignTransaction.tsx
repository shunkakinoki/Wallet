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
  SignTransactionGasSelect,
  SignTransactionGasEstimateContainer,
  SignTransactionGasEstimateFeeContainer,
  SignTransactionGasEstimateFeeSecondsContainer,
  SignTransactionGasSimulationContainer,
  SignTransactionGasSelectTransferContainer,
  SignTransactionGasSelectTransferNameContainer,
  SignTransactionGasSelectTransferImageContainer,
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
  const [isFallback, setIsFallback] = useState(false);
  const [gasEstimationDollar, setGasEstimationDollar] = useState("");
  const [gasEstimationFee, setGasEstimationFee] = useState(0.01);

  const [config, setConfig] = useTransactionGasConfig(state => {
    return [state.config, state.setConfig];
  });
  const [gasPrice, setGasPrice] = useTransactionGasPrice(state => {
    return [state.gasPrice, state.setGasPrice];
  });

  const fetchGasPrice = () => {
    fetch(`https://wallet.light.so/api/gas/${window.ethereum.chainId}`, {
      method: "POST",
      body: JSON.stringify({
        isLegacy: true,
        legacySpeed: config.legacySpeed,
      }),
      headers: new Headers({
        "Content-Type": "application/json",
        Accept: "application/json",
      }),
    })
      .then(response => {
        return response.json();
      })
      .then(data => {
        logContent(`GasPrice result: ${JSON.stringify(data)}`);
        if (!data?.gasPrice) {
          throw "No gasPrice";
        }
        setGasPrice(data.gasPrice);
      })
      .catch(err => {
        logContent(`Error gas: ${JSON.stringify(err)}`);
        if (window.ethereum.storybook) {
          setGasPrice("0x69");
          return;
        }
        setIsFallback(true);
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
  };

  useEffect(() => {
    logContent(config);

    if (config) {
      fetchGasPrice();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [config]);

  useEffect(() => {
    const interval = setInterval(() => {
      if (config) {
        fetchGasPrice();
      }
    }, 3000);
    return () => {
      return clearInterval(interval);
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [config]);

  useEffect(() => {
    if (
      params?.from &&
      params?.to &&
      params?.value &&
      params?.data &&
      (window.ethereum.chainId == "0x1" ||
        window.ethereum.chainId == "0x5" ||
        window.ethereum.chainId == "0x89")
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

  useEffect(() => {
    setGasEstimationFee(
      (parseInt(gasPrice, 16) * (21_000 + 68 * (params?.data?.length / 2))) /
        10e18,
    );
  }, [gasPrice, params?.data]);

  useEffect(() => {
    fetch(
      `https://min-api.cryptocompare.com/data/price?fsym=${
        window.ethereum.chainId == "0x89" ? "MATIC" : "ETH"
      }&tsyms=USD`,
      {
        method: "GET",
      },
    )
      .then(response => {
        return response.json();
      })
      .then(data => {
        logContent(`Gas dollar result: ${JSON.stringify(data)}`);
        setGasEstimationDollar(
          (Number(data.USD) * gasEstimationFee).toFixed(2).toString(),
        );
      })
      .catch(err => {
        logContent(`Error scan: ${JSON.stringify(err)}`);
      });
  }, [gasEstimationFee]);

  if (params?.from && params?.to && params?.value && params?.data) {
    return (
      <SignTransactionDescriptionContainer>
        <SignTransactionGasSimulationContainer>
          {result?.simulationResults &&
            !result?.simulationResults?.error &&
            result?.simulationResults?.expectedStateChanges.map(change => {
              if (
                change?.rawInfo?.kind === "ERC20_APPROVAL" ||
                change?.rawInfo?.kind === "ERC721_APPROVAL" ||
                change?.rawInfo?.kind === "ERC721_APPROVAL_FOR_ALL" ||
                change?.rawInfo?.kind === "ERC1155_APPROVAL" ||
                change?.rawInfo?.kind === "ERC1155_APPROVAL_FOR_ALL"
              ) {
                return (
                  <div
                    key={change?.humanReadableDiff}
                    style={{
                      color:
                        Number(change?.rawInfo?.data?.amount?.after) >
                        Number(change?.rawInfo?.data?.amount?.before)
                          ? "#FF453A"
                          : "#30D158",
                    }}
                  >
                    {change?.humanReadableDiff}
                  </div>
                );
              }

              if (
                change?.rawInfo?.kind === "NATIVE_ASSET_TRANSFER" ||
                change?.rawInfo?.kind === "ERC20_TRANSFER" ||
                change?.rawInfo?.kind === "ERC721_TRANSFER" ||
                change?.rawInfo?.kind === "ERC1155_TRANSFER"
              ) {
                return (
                  <SignTransactionGasSelectTransferContainer
                    key={change?.humanReadableDiff}
                  >
                    <SignTransactionGasSelectTransferNameContainer>
                      <SignTransactionGasSelectTransferImage
                        name={
                          change?.rawInfo?.data?.name ??
                          change?.humanReadableDiff
                            ?.split(" ")
                            .slice(1)
                            .join(" ")
                        }
                        src={"https://img.cryptocorgis.co/corgi/13014975"}
                      />
                      {change?.rawInfo?.data?.name ??
                        change?.humanReadableDiff
                          ?.split(" ")
                          .slice(1)
                          .join(" ")}
                    </SignTransactionGasSelectTransferNameContainer>
                    <div
                      style={{
                        color:
                          Number(change?.rawInfo?.data?.amount?.after) <
                          Number(change?.rawInfo?.data?.amount?.before)
                            ? "#FF453A"
                            : "#30D158",
                      }}
                    >
                      {Number(change?.rawInfo?.data?.amount?.after) <
                      Number(change?.rawInfo?.data?.amount?.before)
                        ? "-"
                        : "+"}{" "}
                      {change?.humanReadableDiff?.split(" ").slice(1).join(" ")}
                    </div>
                  </SignTransactionGasSelectTransferContainer>
                );
              }
            })}
        </SignTransactionGasSimulationContainer>
        <SignTransactionGasContainer>
          <SignTransactionGasEstimateContainer>
            ${gasEstimationDollar ?? 0}{" "}
            <SignTransactionGasEstimateFeeSecondsContainer>
              ~
              {window.ethereum.chainId === "0x1"
                ? config.legacySpeed === "instant"
                  ? 12
                  : config.legacySpeed === "fast"
                  ? 30
                  : config.legacySpeed === "standard"
                  ? 45
                  : 60
                : window.ethereum.chainId === "0x89"
                ? config.legacySpeed === "instant"
                  ? 2
                  : config.legacySpeed === "fast"
                  ? 10
                  : config.legacySpeed === "standard"
                  ? 15
                  : 20
                : config.legacySpeed === "instant"
                ? 3
                : config.legacySpeed === "fast"
                ? 5
                : config.legacySpeed === "standard"
                ? 8
                : 20}{" "}
              sec.
            </SignTransactionGasEstimateFeeSecondsContainer>
            <br />
            <SignTransactionGasEstimateFeeContainer>
              Estimated Fee: {gasEstimationFee.toFixed(9)}{" "}
              {window.ethereum.chainId === "0x89" ? "MATIC" : "ETH"}
            </SignTransactionGasEstimateFeeContainer>
          </SignTransactionGasEstimateContainer>
          <SignTransactionGasSelect
            value={config.legacySpeed}
            onChange={e => {
              setConfig({ legacySpeed: e.target.value });
            }}
          >
            <option value="standard">🚗 Standard</option>
            {!isFallback && (
              <>
                <option value="instant">🚨 Instant</option>
                <option value="fast">🏄‍♂️ Fast</option>
                <option value="low">🐢 Slow</option>
              </>
            )}
          </SignTransactionGasSelect>
        </SignTransactionGasContainer>
      </SignTransactionDescriptionContainer>
    );
  }

  return null;
};

export const shortenName = (name: string) => {
  return name.match(/\b\w/g)?.join("").toUpperCase().substring(0, 3);
};

export const SignTransactionGasSelectTransferImage = ({
  name,
  src,
}: {
  name: string;
  src: string;
}) => {
  const [isFallback, setIsFallback] = useState(false);

  if (isFallback) {
    return (
      <span className="flex justify-center items-center w-5 h-5 text-xs font-semibold leading-none text-gray-400 bg-gray-200 rounded-full border dark:border-0 border-gray-400">
        {shortenName(name)}
      </span>
    );
  }

  return (
    // eslint-disable-next-line jsx-a11y/alt-text, @next/next/no-img-element
    <SignTransactionGasSelectTransferImageContainer
      src={src}
      onError={() => {
        return setIsFallback(true);
      }}
    />
  );
};
