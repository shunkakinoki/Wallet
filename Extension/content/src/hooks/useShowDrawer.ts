import { mountStoreDevtool } from "simple-zustand-devtools";
import { create } from "zustand";

interface ShowDrawerState {
  id: number;
  openDrawer: (id: number) => void;
  closeDrawer: () => void;
}

export const useShowDrawer = create<ShowDrawerState>(set => {
  return {
    id: 0,
    openDrawer: id => {
      return set(() => {
        return { id: id };
      });
    },
    closeDrawer: () => {
      return set(() => {
        return { id: null };
      });
    },
  };
});

if (process.env.NODE_ENV === "development") {
  mountStoreDevtool("useShowDrawer", useShowDrawer);
}
