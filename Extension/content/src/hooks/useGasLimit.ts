import useSWR from "swr";

import { logContent } from "../services/log";
import { intToHex } from "../utils/intToHex";

// Gas Estimation is taken from Metamask's tx-gas-utils https://github.com/MetaMask/metamask-extension/blob/2434c435b449bab8236dfdffb0a7734d291b5d1c/app/scripts/controllers/transactions/tx-gas-utils.js
const fetcher = params => {
  if (window.ethereum.isStorybook) {
    return "0x69";
  }
  return window.ethereum.rpc
    .call({
      jsonrpc: "2.0",
      method: "eth_getBlockByNumber",
      params: ["latest", true],
      id: "1",
    })
    .then(res => {
      logContent(`==> blockGasLimit: ${res.result.gasLimit}`);
      const blockGasLimit = res.result.gasLimit
        ? parseInt(res.result.gasLimit, 16)
        : 90_000;
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
          logContent(`==> estimateGas: ${response.result}`);

          if (!response.result) {
            const saferGasLimit = blockGasLimit * 0.95;
            return intToHex(saferGasLimit);
          }
          const estimatedGasLimit = parseInt(response.result, 16);
          const bufferedGasLimit = estimatedGasLimit * 1.5;
          const upperGasLimit = blockGasLimit * 0.9;

          logContent(
            `==> gasLimits: ${JSON.stringify({
              estimatedGasLimit,
              bufferedGasLimit,
              upperGasLimit,
            })}`,
          );

          if (estimatedGasLimit > upperGasLimit) {
            return intToHex(estimatedGasLimit);
          }
          if (bufferedGasLimit > upperGasLimit) {
            return intToHex(bufferedGasLimit);
          }

          if (!params.data) {
            return "0x5208";
          }

          return intToHex(upperGasLimit);
        })
        .catch(err => {
          logContent(`==> gasEstimationError: ${err}`);
          return "0x5208";
        });
    });
};

export const useGasLimit = params => {
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
    gasLimit: !error ? data : "0x15f90",
    error,
    isLoading,
    isValidating,
  };
};
