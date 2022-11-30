/* eslint-disable func-style */
import { useEffect, useRef, useCallback } from "react";
import useSWR from "swr";

import { useGasPrice } from "./useGasPrice";

const fetcher = params => {
  return window.ethereum.rpc
    .call({
      jsonrpc: "2.0",
      method: "eth_estimateGas",
      params: [params],
      id: 1,
    })
    .then(response => {
      return { gasEstimation: response.result };
    })
    .catch(err => {
      return {
        gasEstimation: "0x5208",
      };
    });
};

function laggy(useSWRNext) {
  return (key, fetcher, config) => {
    const laggyDataRef = useRef();

    const swr = useSWRNext(key, fetcher, config);

    useEffect(() => {
      if (swr.data !== undefined) {
        laggyDataRef.current = swr.data;
      }
    }, [swr.data]);

    const resetLaggy = useCallback(() => {
      laggyDataRef.current = undefined;
    }, []);

    const dataOrLaggyData =
      swr.data === undefined ? laggyDataRef.current : swr.data;

    const isLagging =
      swr.data === undefined && laggyDataRef.current !== undefined;

    return Object.assign({}, swr, {
      data: dataOrLaggyData,
      isLagging,
      resetLaggy,
    });
  };
}

export const useGasEstimation = params => {
  const { gasPrice } = useGasPrice();
  const { data, error, isLoading, isValidating } = useSWR(
    { ...params, gasPrice },
    fetcher,
    { use: [laggy] },
  );

  return {
    gasEstimation:
      data && data?.gasEstimation && gasPrice
        ? (parseInt(data?.gasEstimation, 16) * gasPrice) / 10e9
        : null,
    error,
    isLoading,
    isValidating,
  };
};
