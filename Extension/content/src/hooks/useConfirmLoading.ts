import create from "zustand";

interface TransactionErrorState {
  isConfirmLoading: boolean;
  setConfirmLoading: (state: boolean) => void;
}

export const useConfirmLoading = create<TransactionErrorState>(set => {
  return {
    isConfirmLoading: true,
    setConfirmLoading: state => {
      return set(() => {
        return { isConfirmLoading: state };
      });
    },
  };
});
