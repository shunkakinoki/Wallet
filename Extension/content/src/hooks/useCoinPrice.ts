import useSWR from "swr";

import { laggy } from "../middlwares/laggy";

const fetcher = chainId => {
  return fetch(
    `https://api.coingecko.com/api/v3/simple/price?ids=${
      window.ethereum.chainId === "0x89" ? "matic-network" : "ethereum"
    }&vs_currencies=usd`,
  )
    .then(res => {
      return res.json();
    })
    .then(json => {
      if (!json) {
        throw new Error("USD Empty !!!");
      }
      return json[
        window.ethereum.chainId === "0x89" ? "matic-network" : "ethereum"
      ].usd;
    });
};

export const useCoinPrice = () => {
  const { data, error, isLoading, isValidating } = useSWR(
    ["/coin/price", window.ethereum.chainId],
    ([key, chainId]) => {
      return fetcher(chainId);
    },
    {
      use: [laggy],
      refreshInterval: 30000,
    },
  );

  return {
    coinPrice: data ? Number(data) : null,
    error,
    isLoading,
    isValidating,
  };
};
