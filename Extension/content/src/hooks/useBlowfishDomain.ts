import { useEffect } from "react";
import useSWR from "swr";

import { blowfishSupportedCheck } from "../utils/blowfishSupportedCheck";

import { useTransactionError } from "./useTransactionError";

const fetcher = params => {
  return fetch(`https://wallet.light.so/api/blowfish/v0/domains`, {
    method: "POST",
    body: JSON.stringify({
      domains: [
        params.isPhishing
          ? "https://alertnfts.org"
          : window.location.host.startsWith("localhost")
          ? "https://light.so"
          : `https://${window.location.host}`,
      ],
    }),
  }).then(response => {
    return response.json();
  });
};

export const useBlowfishDomain = params => {
  const setError = useTransactionError(state => {
    return state.setError;
  });

  const {
    data: result,
    error,
    isLoading,
    isValidating,
  } = useSWR(
    blowfishSupportedCheck() ? ["/blowfish/domain", params] : null,
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
    if (result && result[0]?.risk_score > 0.3) {
      return setError(true);
    }
    return setError(false);
  }, [result, setError]);

  return {
    result,
    error,
    isLoading,
    isValidating,
  };
};
