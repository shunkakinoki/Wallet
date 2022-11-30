import useSWR from "swr";

import { laggy } from "../middlwares/laggy";

const fetcher = chainId => {
  return fetch(
    `https://min-api.cryptocompare.com/data/price?fsym=${
      chainId == "0x89" ? "MATIC" : "ETH"
    }&tsyms=USD`,
  )
    .then(res => {
      return res.json();
    })
    .then(json => {
      if (!json.USD) {
        throw new Error("USD Empty !!!");
      }
      return json;
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
      refreshInterval: 1500,
    },
  );

  return {
    coinPrice: data && data?.USD ? Number(data?.USD) : null,
    error,
    isLoading,
    isValidating,
  };
};
