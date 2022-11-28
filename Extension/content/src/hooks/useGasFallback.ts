import create from "zustand";

interface GasFallbackState {
  isGasFallback: boolean;
  setGasFallback: (state: boolean) => void;
}

export const useGasFallback = create<GasFallbackState>(set => {
  return {
    isGasFallback: false,
    setGasFallback: state => {
      return set(() => {
        return { isGasFallback: state };
      });
    },
  };
});
