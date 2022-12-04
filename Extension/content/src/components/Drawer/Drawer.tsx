import type { FC, ReactNode } from "react";
import { useEffect } from "react";

import { useShowDrawer } from "../../hooks/useShowDrawer";
import { useTransactionValue } from "../../hooks/useTransactionValue";
import { sendToEthereum } from "../../services/sendToEthereum";

import { DrawerBackground, DrawerContent } from "./Drawer.styles";

export type DrawerProps = {
  children: ReactNode;
  id: number;
};

export const Drawer: FC<DrawerProps> = ({ id, children }) => {
  const [drawerId, closeDrawer, openDrawer] = useShowDrawer(state => {
    return [state.id, state.closeDrawer, state.openDrawer];
  });
  const resetValue = useTransactionValue(state => {
    return state.resetValue;
  });

  useEffect(() => {
    openDrawer(id);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => {
    const handleKeydown = e => {
      if (e.key === "Escape") {
        closeDrawer();
        resetValue();
        sendToEthereum(null, id, "cancel");
      }
    };

    if (drawerId) {
      document.addEventListener("keydown", handleKeydown);
    }

    return () => {
      document.removeEventListener("keydown", handleKeydown);
    };
  }, [closeDrawer, id, drawerId, resetValue]);

  if (!drawerId || id !== drawerId) {
    return null;
  }

  return (
    <DrawerBackground>
      <DrawerContent show>{children}</DrawerContent>
    </DrawerBackground>
  );
};
