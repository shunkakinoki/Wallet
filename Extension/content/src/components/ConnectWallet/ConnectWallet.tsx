import type { FC } from "react";

import { sendMessageToNativeApp } from "../../services/sendMessageToNativeApp";
import { ConfirmButton } from "../Base/ConfirmButton";

type ConnectWalletParams = {
  id: number;
  method: string;
  params: any;
};

export const ConnectWallet: FC<ConnectWalletParams> = ({
  id,
  method,
  params,
}) => {
  return (
    <ConfirmButton
      id={id}
      onConfirmText="Connect"
      onConfirmClick={() => {
        sendMessageToNativeApp({ id, method, params });
      }}
    />
  );
};
