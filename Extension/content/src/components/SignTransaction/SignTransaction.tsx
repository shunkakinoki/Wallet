import type { FC } from "react";
import { useEffect, useState, useCallback } from "react";

import { useTransactionGasConfig } from "../../hooks/useTransactionGasConfig";

import { useTransactionGasPrice } from "../../hooks/useTransactionGasPrice";

import { BlowfishIcon } from "../../icons/BlowfishIcon";
import { WarningIcon } from "../../icons/WarningIcon";
import { logContent } from "../../services/log";
import { sendMessageToNativeApp } from "../../services/sendMessageToNativeApp";
import { ConfirmButton } from "../Base/ConfirmButton";

import {
  InfoButton,
  ChevronIcon,
  SignTransactionDescriptionContainer,
  SignTransactionGasContainer,
  SignTransactionGasSelect,
  SignTransactionGasSelectAccordionContainer,
  SignTransactionGasEstimateContainer,
  SignTransactionGasEstimateFeeContainer,
  SignTransactionGasEstimateFeeSecondsContainer,
  SignTransactionGasSimulationContainer,
  SignTransactionGasSimulationTotalAmountContainer,
  SignTransactionGasSimulationBlowfishContainer,
  SignTransactionGasSelectApproveContainer,
  SignTransactionGasSelectTransferContainer,
  SignTransactionGasSelectTransferNameContainer,
  SignTransactionGasSelectTransferImageContainer,
  SignTransactionGasSelectTransferFallbackImageContainer,
  SignTransactionGasSelectTransferBalanceContainer,
} from "./SignTransaction.styles";

type SignTransactionParams = {
  id: number;
  method: string;
  params: any;
};

const chains = {
  "0x1": "ethereum",
  "0x5": "goerli",
  "0xa": "optimism",
  "0x89": "polygon",
  "0xa4b1": "arbitrum",
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
    logContent(`Config: ${JSON.stringify(config)}`);

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
    if (result?.simulationResults && !result?.simulationResults?.error) {
      result?.simulationResults?.expectedStateChanges.map(change => {
        if (
          change?.rawInfo?.kind === "NATIVE_ASSET_TRANSFER" ||
          change?.rawInfo?.kind === "ERC20_TRANSFER"
        ) {
          fetch(
            `https://min-api.cryptocompare.com/data/price?fsym=${change?.rawInfo.data?.symbol}&tsyms=USD`,
            {
              method: "GET",
            },
          )
            .then(response => {
              return response.json();
            })
            .then(data => {
              logContent(
                `${
                  change?.rawInfo.data?.symbol
                } dollar result: ${JSON.stringify(data)}`,
              );
              change.rawInfo.data.value = data.USD;
            });
        }
      });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [result?.simulationResults]);

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

  const [isExpanded, setIsExpand] = useState<boolean>();

  const handleExpandToggle = useCallback(() => {
    setIsExpand(!isExpanded);
  }, [isExpanded]);

  if (params?.from && params?.to && params?.value && params?.data) {
    return (
      <SignTransactionDescriptionContainer>
        <SignTransactionGasSelectAccordionContainer
          onClick={handleExpandToggle}
        >
          {result?.simulationResults?.expectedStateChanges[0]?.rawInfo?.kind?.includes(
            "APPROVAL",
          ) && "Approval Request"}
          {result?.simulationResults?.expectedStateChanges[0]?.rawInfo?.kind?.includes(
            "TRANSFER",
          ) && "Balance Changes"}
          {result?.simulationResults && (
            <ChevronIcon direction={isExpanded ? "top" : "bottom"} />
          )}
        </SignTransactionGasSelectAccordionContainer>
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
                  <SignTransactionGasSelectApproveContainer
                    key={change?.humanReadableDiff}
                    style={{
                      color:
                        Number(change?.rawInfo?.data?.amount?.after) >
                        Number(change?.rawInfo?.data?.amount?.before)
                          ? "#FF453A"
                          : "#30D158",
                    }}
                  >
                    <InfoButton>
                      <WarningIcon />
                    </InfoButton>
                    <div>{change?.humanReadableDiff}</div>
                  </SignTransactionGasSelectApproveContainer>
                );
              }

              if (
                change?.rawInfo?.kind === "NATIVE_ASSET_TRANSFER" ||
                change?.rawInfo?.kind === "ERC20_TRANSFER" ||
                change?.rawInfo?.kind === "ERC721_TRANSFER" ||
                change?.rawInfo?.kind === "ERC1155_TRANSFER"
              ) {
                return (
                  <>
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
                          src={
                            change?.rawInfo?.kind === "NATIVE_ASSET_TRANSFER"
                              ? `https://defillama.com/chain-icons/rsz_${
                                  chains[window.ethereum.chainId]
                                }.jpg`
                              : change?.rawInfo?.kind === "ERC721_TRANSFER"
                              ? change?.rawInfo?.data?.metadata?.rawImageUrl
                              : `https://logos.covalenthq.com/tokens/${parseInt(
                                  window.ethereum.chainId,
                                  16,
                                ).toString()}/${
                                  change?.rawInfo?.data?.contract?.address
                                }.png`
                          }
                        />
                        {change?.rawInfo?.data?.name ??
                          change?.humanReadableDiff
                            ?.split(" ")
                            .slice(1)
                            .join(" ")}
                      </SignTransactionGasSelectTransferNameContainer>
                      <SignTransactionGasSelectTransferBalanceContainer
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
                        {change?.humanReadableDiff
                          ?.split(" ")
                          .slice(1)
                          .join(" ")}
                        <br />
                      </SignTransactionGasSelectTransferBalanceContainer>
                    </SignTransactionGasSelectTransferContainer>
                    {isExpanded && (
                      <>
                        <SignTransactionGasSelectTransferNameContainer>
                          <div />
                        </SignTransactionGasSelectTransferNameContainer>
                        <SignTransactionGasSelectTransferBalanceContainer>
                          {"Before: "}
                          {(
                            Number(change?.rawInfo?.data?.amount?.before) /
                            10 ** Number(change?.rawInfo?.data?.decimals)
                          ).toFixed(4)}{" "}
                          {"After: "}
                          {(
                            Number(change?.rawInfo?.data?.amount?.after) /
                            10 ** Number(change?.rawInfo?.data?.decimals)
                          ).toFixed(4)}{" "}
                          {"$"}
                          {(
                            ((Number(change?.rawInfo?.data?.amount?.before) -
                              Number(change?.rawInfo?.data?.amount?.after)) /
                              10 ** Number(change?.rawInfo?.data?.decimals)) *
                            Number(change?.rawInfo?.data?.value)
                          ).toFixed(4)}{" "}
                        </SignTransactionGasSelectTransferBalanceContainer>
                      </>
                    )}
                  </>
                );
              }
            })}
          {isExpanded && (
            <SignTransactionGasSimulationBlowfishContainer>
              <BlowfishIcon />
            </SignTransactionGasSimulationBlowfishContainer>
          )}
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
      <SignTransactionGasSelectTransferFallbackImageContainer>
        {shortenName(name)}
      </SignTransactionGasSelectTransferFallbackImageContainer>
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
