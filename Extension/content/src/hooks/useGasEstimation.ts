/* eslint-disable func-style */
import useSWR from "swr";

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
  const { data, error, isLoading, isValidating } = useSWR(
    ["/gas/estimation", params],
    ([key, params]) => {
      return fetcher(params);
    },
    {
      revalidateIfStale: false,
      revalidateOnFocus: false,
      revalidateOnReconnect: false,
    },
  );

  return {
    gasEstimation: data?.gasEstimation,
    error,
    isLoading,
    isValidating,
  };
};
