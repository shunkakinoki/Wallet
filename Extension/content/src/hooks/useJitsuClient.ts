import type { JitsuClient } from "@jitsu/sdk-js";
import { jitsuClient } from "@jitsu/sdk-js";
import { useMemo } from "react";

export const useJitsuClient = () => {
  return useMemo<JitsuClient>(() => {
    return jitsuClient({
      tracking_host: "https://t.jitsu.com",
      key: process.env.JITSU_JS_KEY,
      ip_policy: "strict",
      privacy_policy: "strict",
      cookie_policy: "strict",
    });
  }, []);
};
