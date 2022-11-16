import create from "zustand";

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
