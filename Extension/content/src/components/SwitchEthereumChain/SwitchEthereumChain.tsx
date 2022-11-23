import { RpcMapping } from "@lightdotso/chain";
import type { FC } from "react";

import { useShowDrawer } from "../../hooks/useShowDrawer";
import { getFavicon } from "../../services/getFavicon";
import { getTitle } from "../../services/getTitle";
import { sendToEthereum } from "../../services/sendToEthereum";
import { storeHostConfiguration } from "../../services/storeHostConfiguration";
import { ConfirmButton } from "../Base/ConfirmButton";

type SwitchEthereumChainParams = {
  id: number;
  method: string;
  params: any;
};

export const SwitchEthereumChain: FC<SwitchEthereumChainParams> = ({
  id,
  method,
  params,
}) => {
  const [closeDrawer] = useShowDrawer(state => {
    return [state.closeDrawer];
  });

  return (
    <ConfirmButton
      id={id}
      onConfirmText="Switch"
      onConfirmClick={() => {
        sendToEthereum(
          { ...params, rpcUrl: RpcMapping[params.chainId] },
          id,
          method,
        );
        storeHostConfiguration({
          name: getTitle(),
          favicon: getFavicon(),
          chainId: params.chainId,
        });
        closeDrawer();
      }}
    />
  );
};
