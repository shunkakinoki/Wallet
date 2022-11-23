/* eslint-disable @next/next/no-img-element */
/* eslint-disable jsx-a11y/alt-text */
import type { FC } from "react";
import { useEffect } from "react";

import { useTransition } from "react-transition-state";

import { useShowDrawer } from "../../hooks/useShowDrawer";
import { useTransactionError } from "../../hooks/useTransactionError";
import { ChainIcon } from "../../icons/ChainIcon";
import { CloseIcon } from "../../icons/CloseIcon";
import { InfoIcon } from "../../icons/InfoIcon";
import { LightIcon } from "../../icons/LightIcon";
import { LinkIcon } from "../../icons/LinkIcon";
import { WalletIcon } from "../../icons/WalletIcon";
import { logContent } from "../../services/log";
import { sendToEthereum } from "../../services/sendToEthereum";
import { splitAddress } from "../../utils/splitAddress";
import { ConnectWallet } from "../ConnectWallet";
import { ConnectWalletDescription } from "../ConnectWallet/ConnectWallet";
import { Drawer } from "../Drawer";
import { PersonalSign } from "../PersonalSign";
import { PersonalSignDescription } from "../PersonalSign/PersonalSign";
import { SignTransaction } from "../SignTransaction";
import { SignTransactionDescription } from "../SignTransaction/SignTransaction";
import { SignTypedMessage } from "../SignTypedMessage";
import { SignTypedDescription } from "../SignTypedMessage/SignTypedMessage";
import { SwitchEthereumChain } from "../SwitchEthereumChain";

const chains = {
  "0x1": "Ethereum",
  "0x5": "Goerli",
  "0xa": "Optimism",
  "0x89": "Polygon",
  "0xa4b1": "Arbitrum",
};

import {
  PageContainer,
  PageHeaderContainer,
  PageHeaderLogoContainer,
  CloseButton,
  PageBannerContainer,
  PageBannerDataContainer,
  LinkButton,
  LinkContainer,
  PageDescriptionContainer,
  PageTypeContainer,
  InfoButton,
  PageDescriptionInfoContainer,
} from "./Page.styles";

type PageProps = {
  id: number;
  type: PageType;
  method: string;
  params: any;
};

type PageType =
  | "ConnectWallet"
  | "SwitchEthereumChain"
  | "PersonalSign"
  | "SignTransaction"
  | "SignTypedMessage";

export const Page: FC<PageProps> = ({ id, type, method, params }) => {
  return (
    <Drawer key={id} id={id}>
      <PageContainer>
        <PageHeader id={id} />
        <PageBanner type={type} />
        <PageDescription type={type} params={params} />
        <PageTypeContainer>
          {type === "ConnectWallet" && (
            <ConnectWallet id={id} method={method} params={params} />
          )}
          {type === "SwitchEthereumChain" && (
            <SwitchEthereumChain id={id} method={method} params={params} />
          )}
          {type === "PersonalSign" && (
            <PersonalSign id={id} method={method} params={params} />
          )}
          {type === "SignTransaction" && (
            <SignTransaction id={id} method={method} params={params} />
          )}
          {type === "SignTypedMessage" && (
            <SignTypedMessage id={id} method={method} params={params} />
          )}
          <PageLogger id={id} type={type} method={method} params={params} />
        </PageTypeContainer>
      </PageContainer>
    </Drawer>
  );
};

export const PageLogger: FC<PageProps> = ({ id, type, method, params }) => {
  useEffect(() => {
    logContent(
      `injecting page: ${JSON.stringify({ id, type, method, params })}`,
    );
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  return null;
};
export type PageHeaderProps = {
  id: number;
};

export const PageHeader: FC<PageHeaderProps> = ({ id }) => {
  const closeDrawer = useShowDrawer(state => {
    return state.closeDrawer;
  });

  return (
    <PageHeaderContainer>
      <PageHeaderLogoContainer>
        <LightIcon />
        Light Wallet
      </PageHeaderLogoContainer>
      <CloseButton
        onClick={() => {
          closeDrawer();
          sendToEthereum(null, id, "cancel");
        }}
      >
        <CloseIcon />
      </CloseButton>
    </PageHeaderContainer>
  );
};

export type PageBannerProps = {
  type: PageType;
};

export const PageBanner: FC<PageBannerProps> = ({ type }) => {
  const [{ isMounted }, toggle] = useTransition({
    mountOnEnter: true,
    unmountOnExit: true,
    preEnter: true,
  });

  useEffect(() => {
    toggle(true);
  }, [toggle]);

  return (
    <>
      <PageBannerContainer>
        {isMounted && <strong>{window.location.hostname}</strong>}
        &nbsp;wants you to{" "}
        {type === "ConnectWallet" && (
          <>
            connect to your <strong>wallet</strong>
          </>
        )}
        {type === "SwitchEthereumChain" && (
          <>
            switch <strong>network</strong>
          </>
        )}
        {type === "PersonalSign" && (
          <>
            <strong>sign a message</strong>
          </>
        )}
        {type === "SignTransaction" && (
          <>
            approve a <strong>transaction</strong>
          </>
        )}
        {type === "SignTypedMessage" && (
          <>
            <strong>sign a typed message</strong>
          </>
        )}
        <PageBannerDataContainer>
          <LinkContainer>
            <LinkButton>
              <LinkIcon />
            </LinkButton>
            &nbsp;
            {isMounted && window.location.host}
          </LinkContainer>
          <LinkContainer>
            <LinkButton>
              <ChainIcon />
            </LinkButton>
            &nbsp;
            {isMounted && window.ethereum && chains[window.ethereum.chainId]}
          </LinkContainer>
          {window.ethereum.address && (
            <LinkContainer>
              <LinkButton>
                <WalletIcon />
              </LinkButton>
              &nbsp;
              {isMounted &&
                window.ethereum &&
                splitAddress(window.ethereum.address)}
            </LinkContainer>
          )}
        </PageBannerDataContainer>
      </PageBannerContainer>
    </>
  );
};

export type PageDescriptionProps = {
  type: PageType;
  params: any;
};

export const PageDescription: FC<PageDescriptionProps> = ({ type, params }) => {
  const [error, setError] = useTransactionError(state => {
    return [state.error, state.setError];
  });

  useEffect(() => {
    setError(false);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  return (
    <>
      <PageDescriptionContainer error={error}>
        {type === "ConnectWallet" && (
          <ConnectWalletDescription params={params} />
        )}
        {type === "PersonalSign" && <PersonalSignDescription params={params} />}
        {type === "SignTransaction" && (
          <SignTransactionDescription params={params} />
        )}
        {type === "SignTypedMessage" && (
          <SignTypedDescription params={params} />
        )}
        {!error && (
          <PageDescriptionInfoContainer>
            <InfoButton>
              <InfoIcon />
            </InfoButton>
            {type === "ConnectWallet" &&
              "When you click connect, you will allow this dapp to view your public wallet address, token balances & previous transactions."}
            {type === "PersonalSign" &&
              "When you click sign, you will passing a message back to the dapp that it can use to authenticate your wallet."}
            {type === "SwitchEthereumChain" &&
              "When you click Switch, you will be switching the network that the wallet is connected to."}
            {type === "SignTransaction" &&
              "When you click approve, you will allow this dapp to send a transaction with your wallet."}
            {type === "SignTypedMessage" &&
              "When you click sign, you will allow this dapp to send a transaction with your wallet."}
          </PageDescriptionInfoContainer>
        )}
      </PageDescriptionContainer>
    </>
  );
};
