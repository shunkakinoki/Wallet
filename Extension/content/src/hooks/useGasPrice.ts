import useSWR from "swr";

import { laggy } from "../middlwares/laggy";

import { useGasFallback } from "./useGasFallback";
import { useTransactionGasConfig } from "./useTransactionGasConfig";

export const useGasPrice = () => {
  const config = useTransactionGasConfig(state => {
    return state.config;
  });
  const setGasFallback = useGasFallback(state => {
    return state.setGasFallback;
  });

  const fetcher = (chainId, legacySpeed) => {
    return fetch(`https://wallet.light.so/api/gas/${chainId}`, {
      method: "POST",
      body: JSON.stringify({
        isLegacy: true,
        legacySpeed: legacySpeed,
      }),
    })
      .then(res => {
        setGasFallback(false);
        return res.json();
      })
      .then(json => {
        if (!json.gasPrice) {
          throw new Error("gasPrice Empty !!!");
        }
        return json;
      })
      .catch(err => {
        setGasFallback(true);
        if (window.ethereum.storybook) {
          return { gasPrice: "0x69" };
        }
        window.ethereum.rpc
          .call({
            jsonrpc: "2.0",
            method: "eth_gasPrice",
            params: [],
            id: 1,
          })
          .then(response => {
            return { gasPrice: response.result };
          });
      });
  };

  const { data, error, isLoading, isValidating } = useSWR(
    ["/gas/price", window.ethereum.chainId, config.legacySpeed],
    ([key, chainId, speed]) => {
      return fetcher(chainId, speed);
    },
    {
      errorRetryCount: 3,
      refreshInterval: 1500,
      use: [laggy],
    },
  );

  return {
    data,
    gasPrice: data && data?.gasPrice ? parseInt(data?.gasPrice, 16) : null,
    error,
    isLoading,
    isValidating,
  };
};
