import create from "zustand";

interface TransactionGasState {
  config: {
    isLegacy: true;
    legacySpeed: "instant" | "fast" | "standard" | "low";
  };
  setConfig: (config) => void;
}

export const useTransactionGasConfig = create<TransactionGasState>(set => {
  return {
    config: {
      isLegacy: true,
      legacySpeed: "standard",
    },
    setConfig: config => {
      return set(state => {
        return {
          ...state,
          config,
        };
      });
    },
  };
});
