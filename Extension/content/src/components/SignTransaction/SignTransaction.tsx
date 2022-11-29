import { ChainNames } from "@lightdotso/chain";
import type { FC } from "react";
import { useEffect, useState, useCallback } from "react";

import { useBlowfishTx } from "../../hooks/useBlowfishTx";

import { useCoinUSD } from "../../hooks/useCoinUSD";
import { useGasFallback } from "../../hooks/useGasFallback";
import { useGasPrice } from "../../hooks/useGasPrice";
import { useTransactionError } from "../../hooks/useTransactionError";
import { useTransactionGasConfig } from "../../hooks/useTransactionGasConfig";

import { useTransactionGasPrice } from "../../hooks/useTransactionGasPrice";

import { BlowfishIcon } from "../../icons/BlowfishIcon";
import { WarningIcon } from "../../icons/WarningIcon";
import { logContent } from "../../services/log";
import { sendMessageToNativeApp } from "../../services/sendMessageToNativeApp";
import { shortenName } from "../../utils/shortenName";
import { ConfirmButton } from "../Base/ConfirmButton";

import {
  InfoButton,
  ChevronIcon,
  LoadingSpinner,
  SignTransactionDescriptionContainer,
  SignTransactionGasContainer,
  SignTransactionGasSelect,
  SignTransactionGasSelectAccordionContainer,
  SignTransactionGasEstimateContainer,
  SignTransactionGasEstimateFeeContainer,
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
  const [gasPrice] = useTransactionGasPrice(state => {
    return [state.gasPrice];
  });
  const [error] = useTransactionError(state => {
    return [state.error];
  });

  return (
    <ConfirmButton
      id={id}
      disabled={error}
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
  const [gasEstimationDollar, setGasEstimationDollar] = useState("");
  const [gasEstimationFee, setGasEstimationFee] = useState(0.01);

  const [config, setConfig] = useTransactionGasConfig(state => {
    return [state.config, state.setConfig];
  });

  const [setError] = useTransactionError(state => {
    return [state.setError];
  });

  const [isGasFallback] = useGasFallback(state => {
    return [state.isGasFallback];
  });

  const { coinUSD } = useCoinUSD();
  const { gasPrice, isValidating: isGasPriceValidating } = useGasPrice();
  const { result } = useBlowfishTx(params);

  useEffect(() => {
    if (gasPrice) {
      setGasEstimationFee(
        (gasPrice * (21_000 + 68 * (params?.data?.length / 2))) / 10e18,
      );
    }
  }, [gasPrice, params?.data]);

  useEffect(() => {
    if (coinUSD) {
      setGasEstimationDollar(
        (coinUSD * gasEstimationFee).toFixed(2).toString(),
      );
    }
  }, [coinUSD, gasEstimationFee]);

  const [isExpanded, setIsExpand] = useState<boolean>();

  const handleExpandToggle = useCallback(() => {
    setIsExpand(!isExpanded);
  }, [isExpanded]);

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
                <>
                  <div key={warning?.kind}>{warning?.message}</div>
                  <br />
                </>
              );
            })}
            {result?.simulationResults?.error?.humanReadableError}
          </SignTransactionGasSelectTransferErrorContainer>
        </SignTransactionGasSimulationContainer>
      );
    }
    return (
      <SignTransactionDescriptionContainer>
        {(window.ethereum.chainId === "0x1" ||
          window.ethereum.chainId === "0x5" ||
          window.ethereum.chainId === "0x89") && (
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
        )}
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
                                Number(change?.rawInfo?.data?.amount?.before) -
                                  Number(change?.rawInfo?.data?.amount?.after),
                              ) /
                                10 ** Number(change?.rawInfo?.data?.decimals)) *
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
                                Number(change?.rawInfo?.data?.amount?.before) /
                                10 ** Number(change?.rawInfo?.data?.decimals)
                              ).toFixed(2)}{" "}
                              {change?.rawInfo?.data?.symbol}
                            </strong>
                            <br />
                            {"After: "}
                            <strong>
                              {(
                                Number(change?.rawInfo?.data?.amount?.after) /
                                10 ** Number(change?.rawInfo?.data?.decimals)
                              ).toFixed(2)}{" "}
                              {change?.rawInfo?.data?.symbol}
                            </strong>
                          </SignTransactionGasSelectTransferBalanceExpansionContainer>
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
              Estimated Fee:{" "}
              {gasEstimationFee < 0.000001
                ? "< 0.000001"
                : gasEstimationFee.toFixed(6)}{" "}
              {gasEstimationFee && window.ethereum.chainId === "0x89"
                ? "MATIC"
                : "ETH"}
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
