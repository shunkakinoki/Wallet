import { mountStoreDevtool } from "simple-zustand-devtools";
import { create } from "zustand";

interface TransactionValueState {
  value: number;
  addValue: (by: number) => void;
  resetValue: () => void;
}

export const useTransactionValue = create<TransactionValueState>(set => {
  return {
    value: 0,
    addValue: by => {
      return set(state => {
        return { value: state.value + by };
      });
    },
    resetValue: () => {
      return set(() => {
        return { value: 0 };
      });
    },
  };
});

if (process.env.NODE_ENV === "development") {
  mountStoreDevtool("useTransactionValue", useTransactionValue);
}
