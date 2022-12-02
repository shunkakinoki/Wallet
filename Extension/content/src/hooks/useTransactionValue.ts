import create from "zustand";

interface TransactionValueState {
  value: number;
  setValue: (state: number) => void;
}

export const useTransactionValue = create<TransactionValueState>(set => {
  return {
    value: 0,
    setValue: state => {
      return set(() => {
        return { value: state };
      });
    },
  };
});
