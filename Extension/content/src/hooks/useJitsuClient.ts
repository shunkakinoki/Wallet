import type { JitsuClient } from "@jitsu/sdk-js";
import { useMemo } from "react";

import { client } from "../services/jitsuClient";

export const useJitsuClient = () => {
  return useMemo<JitsuClient>(() => {
    return client;
  }, []);
};
