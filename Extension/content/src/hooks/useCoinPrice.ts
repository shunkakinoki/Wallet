import useSWR from "swr";

import { laggy } from "../middlwares/laggy";

const fetcher = chainId => {
  return fetch(
    `https://min-api.cryptocompare.com/data/price?fsym=${
      chainId == "0x89" ? "MATIC" : "ETH"
    }&tsyms=USD`,
  ).then(res => {
    return res.json();
  });
};

export const useCoinPrice = () => {
  const { data, error, isLoading, isValidating } = useSWR(
    window.ethereum.chainId,
    fetcher,
    {
      use: [laggy],
      refreshInterval: 300,
    },
  );

  return {
    coinPrice: data && data?.USD ? Number(data?.USD) : null,
    error,
    isLoading,
    isValidating,
  };
};
