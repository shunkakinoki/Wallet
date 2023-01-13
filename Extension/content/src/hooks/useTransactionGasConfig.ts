import { mountStoreDevtool } from "simple-zustand-devtools";
import { create } from "zustand";

interface TransactionGasState {
  config: {
    legacySpeed: "instant" | "fast" | "standard" | "low";
  };
  setConfig: (config) => void;
}

export const useTransactionGasConfig = create<TransactionGasState>(set => {
  return {
    config: {
      legacySpeed: "standard",
    },
    setConfig: config => {
      return set(() => {
        return { config: config };
      });
    },
  };
});

if (process.env.NODE_ENV === "development") {
  mountStoreDevtool("useTransactionGasConfig", useTransactionGasConfig);
}
