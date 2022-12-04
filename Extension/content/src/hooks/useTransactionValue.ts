import create from "zustand";

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
      return set(state => {
        return { value: 0 };
      });
    },
  };
});
