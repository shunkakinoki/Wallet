import create from "zustand";

interface TransactionErrorState {
  error: boolean;
  setError: () => void;
}

export const useTransactionError = create<TransactionErrorState>(set => {
  return {
    error: false,
    setError: () => {
      return set(() => {
        return { error: true };
      });
    },
  };
});
