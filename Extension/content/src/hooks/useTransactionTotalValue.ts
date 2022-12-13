import create from "zustand";

interface TransactionTotalValueState {
  totalValue: number;
  setTotalValue: (by: number) => void;
}

export const useTransactionTotalValue = create<TransactionTotalValueState>(
  set => {
    return {
      totalValue: 0,
      setTotalValue: value => {
        return set(() => {
          return { totalValue: value };
        });
      },
    };
  },
);
