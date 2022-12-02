import { ChainNames } from "@lightdotso/chain";
import type { FC } from "react";
import { useMemo, useEffect, useState, useCallback } from "react";

import { useBlowfishTx } from "../../hooks/useBlowfishTx";

import { useCoinPrice } from "../../hooks/useCoinPrice";
import { useConfirmLoading } from "../../hooks/useConfirmLoading";
import { useGasEstimation } from "../../hooks/useGasEstimation";
import { useGasFallback } from "../../hooks/useGasFallback";
import { useGasPrice } from "../../hooks/useGasPrice";
import { useTransactionError } from "../../hooks/useTransactionError";
import { useTransactionGasConfig } from "../../hooks/useTransactionGasConfig";
import { BlowfishIcon } from "../../icons/BlowfishIcon";
import { WarningIcon } from "../../icons/WarningIcon";
import { sendMessageToNativeApp } from "../../services/sendMessageToNativeApp";
import { shortenName } from "../../utils/shortenName";
import { ConfirmButton } from "../Base/ConfirmButton";

import { Skeleton } from "../Base/Skeleton";

import {
  InfoButton,
  ChevronIcon,
  LoadingSpinner,
  SignTransactionDescriptionContainer,
  SignTransactionSkeletonContainer,
  SignTransactionGasContainer,
  SignTransactionGasSelect,
  SignTransactionGasSelectAccordionContainer,
  SignTransactionGasEstimateContainer,
  SignTransactionGasEstimateFeeContainer,
  SignTransactionGasEstimatePriceContainer,
  SignTransactionGasEstimateFeeSecondsContainer,
  SignTransactionGasSimulationContainer,
  SignTransactionGasSimulationBlowfishContainer,
  SignTransactionGasSelectApproveContainer,
  SignTransactionGasSelectTransferContainer,
  SignTransactionGasSelectTransferErrorContainer,
  SignTransactionGasSelectTransferNameContainer,
  SignTransactionGasSelectTransferImageContainer,
  SignTransactionGasSelectTransferFallbackImageContainer,
  SignTransactionGasSelectTransferBalanceContainer,
  SignTransactionGasSelectTransferBalanceContainerSpan,
  SignTransactionGasSelectTransferBalanceExpansionContainer,
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
  const { gasPrice } = useGasPrice();
  const [error] = useTransactionError(state => {
    return [state.error];
  });
  const [isConfirmLoading] = useConfirmLoading(state => {
    return [state.isConfirmLoading];
  });

  return (
    <ConfirmButton
      id={id}
      method={method}
      disabled={error}
      loading={isConfirmLoading}
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
                data: params?.data ?? "0x",
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
  const [config, setConfig] = useTransactionGasConfig(state => {
    return [state.config, state.setConfig];
  });

  const [isGasFallback] = useGasFallback(state => {
    return [state.isGasFallback];
  });

  const { coinPrice, isValidating: isCoinPriceValidating } = useCoinPrice();
  const {
    gasPrice,
    isValidating: isGasPriceValidating,
    isLoading: isGasPriceLoading,
  } = useGasPrice();
  const { gasEstimation } = useGasEstimation(params);
  const { result, isLoading: isBlowfishLoading } = useBlowfishTx(params);

  const [setConfirmLoading] = useConfirmLoading(state => {
    return [state.setConfirmLoading];
  });

  const gasEstimationFee = useMemo(() => {
    return (parseInt(gasEstimation) * parseInt(gasPrice)) / 1e18;
  }, [gasEstimation, gasPrice]);

  const gasEstimationDollar = useMemo(() => {
    return coinPrice * gasEstimationFee;
  }, [coinPrice, gasEstimationFee]);

  const [isExpanded, setIsExpand] = useState<boolean>();

  const handleExpandToggle = useCallback(() => {
    setIsExpand(!isExpanded);
  }, [isExpanded]);

  useEffect(() => {
    if (
      !gasEstimationFee ||
      !gasPrice ||
      isBlowfishLoading ||
      isBlowfishLoading
    ) {
      setConfirmLoading(true);
    } else {
      setConfirmLoading(false);
    }
  }, [
    gasEstimationFee,
    gasPrice,
    isBlowfishLoading,
    isCoinPriceValidating,
    setConfirmLoading,
  ]);

  if (params?.from && params?.to) {
    if (result?.simulationResults && result?.simulationResults?.error) {
      return (
        <SignTransactionGasSimulationContainer
          style={{
            color: "#FF453A",
          }}
        >
          <SignTransactionGasSelectTransferErrorContainer>
            {result?.warnings.map(warning => {
              return (
                <div key={warning?.kind}>
                  <>{warning?.message}</>
                  <br />
                </div>
              );
            })}
            {result?.simulationResults?.error?.humanReadableError}
          </SignTransactionGasSelectTransferErrorContainer>
        </SignTransactionGasSimulationContainer>
      );
    }
    return (
      <SignTransactionDescriptionContainer>
        {isBlowfishLoading ? (
          <SignTransactionSkeletonContainer>
            <Skeleton width="100%" height="50px" />
          </SignTransactionSkeletonContainer>
        ) : (
          <>
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
                      <div key={change?.humanReadableDiff}>
                        <SignTransactionGasSelectTransferContainer>
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
                                change?.rawInfo?.kind ===
                                "NATIVE_ASSET_TRANSFER"
                                  ? `https://defillama.com/chain-icons/rsz_${
                                      ChainNames[window.ethereum.chainId]
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
                              .join(" ")}{" "}
                            {isExpanded && change?.rawInfo?.data?.value && (
                              <SignTransactionGasSelectTransferBalanceContainerSpan>
                                ($
                                {(
                                  (Math.abs(
                                    Number(
                                      change?.rawInfo?.data?.amount?.before,
                                    ) -
                                      Number(
                                        change?.rawInfo?.data?.amount?.after,
                                      ),
                                  ) /
                                    10 **
                                      Number(change?.rawInfo?.data?.decimals)) *
                                  Number(change?.rawInfo?.data?.value)
                                ).toFixed(2)}
                                )
                              </SignTransactionGasSelectTransferBalanceContainerSpan>
                            )}{" "}
                            <br />
                          </SignTransactionGasSelectTransferBalanceContainer>
                        </SignTransactionGasSelectTransferContainer>
                        {isExpanded &&
                          (change?.rawInfo?.kind === "NATIVE_ASSET_TRANSFER" ||
                            change?.rawInfo?.kind === "ERC20_TRANSFER") && (
                            <>
                              <SignTransactionGasSelectTransferNameContainer>
                                <div />
                              </SignTransactionGasSelectTransferNameContainer>
                              <SignTransactionGasSelectTransferBalanceExpansionContainer>
                                {"Before: "}
                                <strong>
                                  {(
                                    Number(
                                      change?.rawInfo?.data?.amount?.before,
                                    ) /
                                    10 **
                                      Number(change?.rawInfo?.data?.decimals)
                                  ).toFixed(2)}{" "}
                                  {change?.rawInfo?.data?.symbol}
                                </strong>
                                <br />
                                {"After: "}
                                <strong>
                                  {(
                                    Number(
                                      change?.rawInfo?.data?.amount?.after,
                                    ) /
                                    10 **
                                      Number(change?.rawInfo?.data?.decimals)
                                  ).toFixed(2)}{" "}
                                  {change?.rawInfo?.data?.symbol}
                                </strong>
                              </SignTransactionGasSelectTransferBalanceExpansionContainer>
                            </>
                          )}
                      </div>
                    );
                  }
                })}
              {isExpanded && (
                <SignTransactionGasSimulationBlowfishContainer>
                  <BlowfishIcon />
                </SignTransactionGasSimulationBlowfishContainer>
              )}
            </SignTransactionGasSimulationContainer>
          </>
        )}
        <SignTransactionGasContainer>
          <SignTransactionGasEstimateContainer>
            <SignTransactionGasEstimatePriceContainer>
              {gasEstimationDollar ? (
                gasEstimationDollar < 0.01 ? (
                  "< $0.01"
                ) : gasEstimationDollar > 10e3 ? (
                  `$${gasEstimationDollar.toLocaleString()}`
                ) : (
                  `$${gasEstimationDollar.toFixed(2)}`
                )
              ) : (
                <Skeleton width="20%" />
              )}
              &nbsp;
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
              </SignTransactionGasEstimateFeeSecondsContainer>{" "}
              {isCoinPriceValidating && <LoadingSpinner />}
            </SignTransactionGasEstimatePriceContainer>
            <SignTransactionGasEstimateFeeContainer>
              <span>Estimated Fee:</span>&nbsp;
              {gasPrice && gasEstimationFee && (
                <>
                  {gasEstimationFee < 0.000001
                    ? "< 0.000001"
                    : gasEstimationFee.toFixed(6)}{" "}
                  {window.ethereum.chainId === "0x89" ? "MATIC" : "ETH"}
                </>
              )}
              {isGasPriceLoading && <Skeleton width="20px" height="12px" />}
              {isGasPriceValidating && <LoadingSpinner />}
            </SignTransactionGasEstimateFeeContainer>
          </SignTransactionGasEstimateContainer>
          <SignTransactionGasSelect
            value={config.legacySpeed}
            onChange={e => {
              setConfig({ legacySpeed: e.target.value });
            }}
          >
            <option value="standard">🚗 Standard</option>
            {!isGasFallback && (
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
