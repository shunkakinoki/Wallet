import { useEffect } from "react";
import useSWR from "swr";

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
  ).then(response => {
    return response.json();
  });
};

export const useBlowfishMessage = params => {
  const setError = useTransactionError(state => {
    return state.setError;
  });

  const {
    data: result,
    error,
    isLoading,
    isValidating,
  } = useSWR(params, fetcher, {
    revalidateIfStale: false,
    revalidateOnFocus: false,
    revalidateOnReconnect: false,
  });

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
