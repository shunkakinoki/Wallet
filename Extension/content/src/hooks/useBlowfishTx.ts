import { useEffect } from "react";
import useSWR from "swr";

import { blowfishSupportedCheck } from "../utils/blowfishSupportedCheck";

import { useTransactionError } from "./useTransactionError";

const fetcher = params => {
  return fetch(
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
        metadata: {
          origin: `https://${
            window.location.host.startsWith("localhost")
              ? "https://wallet.light.so"
              : window.location.host
          }`,
        },
        userAccount: params.from,
        txObject: {
          from: params.from,
          to: params.to,
          data: params?.data ?? "0x",
          value: params?.value ?? "0x0",
        },
      }),
    },
  ).then(response => {
    return response.json();
  });
};

export const useBlowfishTx = params => {
  const setError = useTransactionError(state => {
    return state.setError;
  });

  const {
    data: result,
    error,
    isLoading,
    isValidating,
  } = useSWR(
    blowfishSupportedCheck() ? ["/blowfish/transaction", params] : null,
    ([key, params]) => {
      return fetcher(params);
    },
    {
      revalidateIfStale: false,
      revalidateOnFocus: false,
      revalidateOnReconnect: false,
    },
  );

  useEffect(() => {
    if (typeof result?.warnings !== "undefined" && result?.warnings.length) {
      return setError(true);
    }
    return setError(false);
  }, [result?.warnings, setError]);

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
            change.rawInfo.data.value = data.USD;
          });
      }
    });
  }
  return {
    result,
    error,
    isLoading,
    isValidating,
  };
};
