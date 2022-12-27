import { RpcMapping, ChainNames } from "@lightwallet/chains";
import type { FC } from "react";
import { useState } from "react";

import { ArrowRightIcon } from "../../icons/ArrowRightIcon";
import { getFavicon } from "../../services/getFavicon";
import { getTitle } from "../../services/getTitle";
import { sendToEthereum } from "../../services/sendToEthereum";
import { storeHostConfiguration } from "../../services/storeHostConfiguration";
import { shortenName } from "../../utils/shortenName";
import { ConfirmButton } from "../Base/ConfirmButton";

import {
  ChainIconImage,
  ChainIconSpan,
  SwitchEthereumChainContainer,
} from "./SwitchEthereumChain.styles";

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
  return (
    <ConfirmButton
      id={id}
      method={method}
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
      }}
    />
  );
};

export const SwitchEthereumChainDescription: FC<
  Pick<SwitchEthereumChainParams, "params">
> = ({ params }) => {
  return (
    <SwitchEthereumChainContainer>
      <ChainIcon chainId={window.ethereum.chainId} />
      &nbsp;
      <ArrowRightIcon />
      &nbsp;
      <ChainIcon chainId={params.chainId} />
    </SwitchEthereumChainContainer>
  );
};

type ChainIconParams = {
  chainId: string;
};

export const ChainIcon: FC<ChainIconParams> = ({ chainId }) => {
  const [isFallback, setIsFallback] = useState(false);

  return (
    <div>
      {isFallback ? (
        <ChainIconSpan>
          {shortenName(ChainNames[chainId] ?? "Undefined")}
        </ChainIconSpan>
      ) : (
        // eslint-disable-next-line jsx-a11y/alt-text, @next/next/no-img-element
        <ChainIconImage
          src={`https://icons.llamao.fi/icons/chains/rsz_${ChainNames[
            chainId
          ].toLowerCase()}.jpg`}
          onError={() => {
            return setIsFallback(true);
          }}
        />
      )}
    </div>
  );
};
