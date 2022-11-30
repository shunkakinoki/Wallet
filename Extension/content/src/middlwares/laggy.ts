import { useEffect, useRef, useCallback } from "react";

export const laggy = useSWRNext => {
  return (key, fetcher, config) => {
    const laggyDataRef = useRef();

    const swr = useSWRNext(key, fetcher, config);

    useEffect(() => {
      if (swr.data !== undefined) {
        laggyDataRef.current = swr.data;
      }
    }, [swr.data]);

    const resetLaggy = useCallback(() => {
      laggyDataRef.current = undefined;
    }, []);

    const dataOrLaggyData =
      swr.data === undefined ? laggyDataRef.current : swr.data;

    const isLagging =
      swr.data === undefined && laggyDataRef.current !== undefined;

    return Object.assign({}, swr, {
      data: dataOrLaggyData,
      isLagging,
      resetLaggy,
    });
  };
};
