import { mountStoreDevtool } from "simple-zustand-devtools";
import { create } from "zustand";
import { persist } from "zustand/middleware";

interface InitialState {
  isInitial: boolean;
  setIsInitial: (newState: boolean) => void;
}

export const useIsInitial = create(
  persist<InitialState>(
    set => {
      return {
        isInitial: true,
        setIsInitial: newState => {
          return set(() => {
            return { isInitial: newState };
          });
        },
      };
    },
    {
      name: "@lightwallet/initial",
    },
  ),
);

if (process.env.NODE_ENV === "development") {
  mountStoreDevtool("useIsInitial", useIsInitial);
}
