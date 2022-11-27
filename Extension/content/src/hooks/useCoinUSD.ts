import useSWR from "swr";

const fetcher = chainId => {
  return fetch(
    `https://min-api.cryptocompare.com/data/price?fsym=${
      chainId == "0x89" ? "MATIC" : "ETH"
    }&tsyms=USD`,
  ).then(res => {
    return res.json();
  });
};

export const useCoinUSD = () => {
  const { data, error, isLoading, isValidating } = useSWR(
    window.ethereum.chainId,
    fetcher,
  );

  return {
    data,
    error,
    isLoading,
    isValidating,
  };
};
