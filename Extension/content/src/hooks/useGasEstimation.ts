/* eslint-disable func-style */
import useSWR from "swr";

import { logContent } from "../services/log";

const fetcher = params => {
  if (window.ethereum.isStorybook) {
    return "0x69";
  }
  return window.ethereum.rpc
    .call({
      jsonrpc: "2.0",
      method: "eth_estimateGas",
      params: [
        {
          from: params.from,
          to: params.to,
          data: params.data,
          value: params?.value ?? "0x0",
        },
      ],
      id: "1",
    })
    .then(response => {
      return response.result;
    });
};

export const useGasEstimation = params => {
  const { data, error, isLoading, isValidating } = useSWR(
    ["/gas/estimation", params.to, params.data],
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
    gasEstimation: data,
    error,
    isLoading,
    isValidating,
  };
};
