import { mountStoreDevtool } from "simple-zustand-devtools";
import { create } from "zustand";

interface TransactionErrorState {
  error: boolean;
  setError: (state: boolean) => void;
}

export const useTransactionError = create<TransactionErrorState>(set => {
  return {
    error: false,
    setError: state => {
      return set(() => {
        return { error: state };
      });
    },
  };
});

if (process.env.NODE_ENV === "development") {
  mountStoreDevtool("useTransactionError", useTransactionError);
}
