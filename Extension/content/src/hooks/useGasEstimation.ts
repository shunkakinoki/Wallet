/* eslint-disable func-style */
import useSWR from "swr";

import { laggy } from "../middlwares/laggy";

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

export const useGasEstimation = params => {
  const { gasPrice } = useGasPrice();
  const { data, error, isLoading, isValidating } = useSWR(
    ["/gas/estimation", { ...params, gasPrice }],
    ([key, params]) => {
      return fetcher(params);
    },
    {
      use: [laggy],
      revalidateIfStale: false,
      revalidateOnFocus: false,
      revalidateOnReconnect: false,
    },
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
