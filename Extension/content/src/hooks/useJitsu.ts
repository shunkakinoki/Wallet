import type { JitsuClient, EventPayload, UserProps } from "@jitsu/sdk-js";
import { useCallback } from "react";

import { useJitsuClient } from "./useJitsuClient";

export const useJitsu = (): JitsuClient & {
  trackPageView: () => Promise<void>;
} => {
  const client = useJitsuClient();

  const id = useCallback(
    (userData: UserProps, doNotSendEvent?: boolean): Promise<void> => {
      return client?.id(userData, doNotSendEvent);
    },
    [client],
  );

  const trackPageView = useCallback((): Promise<void> => {
    return client?.track("pageview");
  }, [client]);

  const track = useCallback(
    (typeName: string, payload?: EventPayload): Promise<void> => {
      return client?.track(typeName, payload);
    },
    [client],
  );

  const rawTrack = useCallback(
    (payload: any): Promise<void> => {
      return client?.rawTrack(payload);
    },
    [client],
  );

  const interceptAnalytics = useCallback(
    (analytics: any): void => {
      return client?.interceptAnalytics(analytics);
    },
    [client],
  );

  const set = useCallback(
    (
      properties: Record<string, any>,
      opts?: { eventType?: string; persist?: boolean },
    ): void => {
      return client?.set(properties, opts);
    },
    [client],
  );

  const unset = useCallback(
    (
      propertyName: string,
      opts?: { eventType?: string; persist?: boolean },
    ): void => {
      return client?.unset(propertyName, opts);
    },
    [client],
  );

  return {
    ...client,
    id,
    track,
    trackPageView,
    rawTrack,
    interceptAnalytics,
    set,
    unset,
  };
};
