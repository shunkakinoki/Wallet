import create from "zustand";

interface TransactionGasState {
  gasPrice: string;
  setGasPrice: (gasPrice) => void;
}

export const useTransactionGasPrice = create<TransactionGasState>(set => {
  return {
    gasPrice: "",
    setGasPrice: gasPrice => {
      return set(() => {
        return { gasPrice: gasPrice };
      });
    },
  };
});
