import { useEffect } from "react";
import useSWR from "swr";

import { beautifyNumber } from "../utils/beautifyNumber";
import { blowfishSupportedCheck } from "../utils/blowfishSupportedCheck";

import { useTransactionError } from "./useTransactionError";
import { useTransactionValue } from "./useTransactionValue";

const fetcher = params => {
  if (!params.data) {
    if (window.ethereum.isStorybook) {
      return {
        action: "NONE",
        simulationResults: {
          error: null,
          expectedStateChanges: [
            {
              humanReadableDiff: "Send 3.181 ETH",
              rawInfo: {
                data: {
                  amount: {
                    after: "998426264937289938488",
                    before: "1001607264937289938488",
                  },
                  contract: {
                    address: "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee",
                    kind: "ACCOUNT",
                  },
                  decimals: 18,
                  name: "Ether",
                  symbol: "ETH",
                },
                kind: "NATIVE_ASSET_TRANSFER",
              },
            },
          ],
        },
        warnings: [],
      };
    }

    return window.ethereum.rpc
      .call({
        jsonrpc: "2.0",
        method: "eth_getBalance",
        params: [params.from, "latest"],
        id: 1,
      })
      .then(response => {
        const balance = parseInt(response.result, 16);
        const value = parseInt(params.value, 16);
        return {
          action: "NONE",
          simulationResults: {
            error: null,
            expectedStateChanges: [
              {
                humanReadableDiff: `Send ${beautifyNumber(value / 1e18)} ETH`,
                rawInfo: {
                  data: {
                    amount: {
                      after: balance - value,
                      before: balance,
                    },
                    contract: {
                      address: "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee",
                      kind: "ACCOUNT",
                    },
                    decimals: 18,
                    name: "Ether",
                    symbol: "ETH",
                  },
                  kind: "NATIVE_ASSET_TRANSFER",
                },
              },
            ],
          },
          warnings: [],
        };
      })
      .catch(err => {});
  }

  return fetch(
    `https://wallet.light.so/api/blowfish/${
      window.ethereum.chainId == "0x1" || window.ethereum.chainId == "0x5"
        ? "ethereum"
        : "polygon"
    }/v0/${
      window.ethereum.chainId == "0x1" || window.ethereum.chainId == "0x89"
        ? "mainnet"
        : "goerli"
    }/scan/transaction`,
    {
      method: "POST",
      body: JSON.stringify({
        metadata: {
          origin: `https://${
            window.location.host.startsWith("localhost")
              ? "https://wallet.light.so"
              : window.location.host
          }`,
        },
        userAccount: params.from,
        txObject: {
          from: params.from,
          to: params.to,
          data: params?.data ?? "0x",
          value: params?.value ?? "0x0",
        },
      }),
    },
  ).then(response => {
    return response.json();
  });
};

export const useBlowfishTx = params => {
  const setError = useTransactionError(state => {
    return state.setError;
  });
  const addValue = useTransactionValue(state => {
    return state.addValue;
  });

  const {
    data: result,
    error,
    isLoading,
    isValidating,
    mutate,
  } = useSWR(
    blowfishSupportedCheck() ? ["/blowfish/transaction", params] : null,
    ([key, params]) => {
      return fetcher(params);
    },
    {
      revalidateIfStale: false,
      revalidateOnFocus: false,
      revalidateOnReconnect: false,
    },
  );

  useEffect(() => {
    if (typeof result?.warnings !== "undefined" && result?.warnings.length) {
      return setError(true);
    }
    return setError(false);
  }, [result?.warnings, setError]);

  useEffect(() => {
    if (result?.simulationResults && !result?.simulationResults?.error) {
      result?.simulationResults?.expectedStateChanges.map(change => {
        if (
          change?.rawInfo?.kind === "NATIVE_ASSET_TRANSFER" ||
          change?.rawInfo?.kind === "ERC20_TRANSFER"
        ) {
          fetch(
            `https://min-api.cryptocompare.com/data/price?fsym=${change?.rawInfo.data?.symbol}&tsyms=USD`,
            {
              method: "GET",
            },
          )
            .then(response => {
              return response.json();
            })
            .then(data => {
              change.rawInfo.data.value = data.USD;
              if (
                Number(change?.rawInfo?.data?.amount?.after) <
                Number(change?.rawInfo?.data?.amount?.before)
              ) {
                const addedValue =
                  (Math.abs(
                    Number(change?.rawInfo?.data?.amount?.before) -
                      Number(change?.rawInfo?.data?.amount?.after),
                  ) /
                    10 ** Number(change?.rawInfo?.data?.decimals)) *
                  Number(change?.rawInfo?.data?.value);
                addValue(addedValue);
              }
            });
        }
      });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [result?.simulationResults]);

  return {
    result,
    error,
    mutate,
    isLoading,
    isValidating,
  };
};
