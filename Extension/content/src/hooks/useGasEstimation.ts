import useSWR from "swr";

// Gas Estimation is taken from Metamask's tx-gas-utils https://github.com/MetaMask/metamask-extension/blob/2434c435b449bab8236dfdffb0a7734d291b5d1c/app/scripts/controllers/transactions/tx-gas-utils.js
const fetcher = params => {
  if (!params.data) {
    return "0x5208";
  }
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
      const blockGasLimit = res.result.gasLimit
        ? parseInt(res.result.gasLimit, 16)
        : 90_000;
      window.ethereum.rpc
        .call({
          jsonrpc: "2.0",
          method: "eth_estimateGas",
          params: [
            {
              to: params.to,
            },
          ],
          id: "1",
        })
        .then(response => {
          if (!response.result) {
            const saferGasLimit = blockGasLimit * 0.95;
            return saferGasLimit.toString(16);
          }
          const estimatedGasLimit = parseInt(response.result, 16);
          const bufferedGasLimit = parseInt(response.result, 16) * 1.5;
          const upperGasLimitBn = blockGasLimit * 0.9;
          if (estimatedGasLimit > upperGasLimitBn) {
            return estimatedGasLimit.toString(16);
          }
          if (bufferedGasLimit > upperGasLimitBn) {
            return bufferedGasLimit.toString(16);
          }
          return upperGasLimitBn.toString(16);
        });
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
    gasEstimation: !error ? data : "0x15f90",
    error,
    isLoading,
    isValidating,
  };
};
