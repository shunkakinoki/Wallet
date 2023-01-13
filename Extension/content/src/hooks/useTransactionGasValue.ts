import { mountStoreDevtool } from "simple-zustand-devtools";
import { create } from "zustand";

interface TransactionGasValueState {
  gasValue: number;
  setGasValue: (by: number) => void;
}

export const useTransactionGasValue = create<TransactionGasValueState>(set => {
  return {
    gasValue: 0,
    setGasValue: value => {
      return set(() => {
        return { gasValue: value };
      });
    },
  };
});

if (process.env.NODE_ENV === "development") {
  mountStoreDevtool("useTransactionGasValue", useTransactionGasValue);
}
