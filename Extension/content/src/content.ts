import { injectComponent } from "./App";
import { Page } from "./components/Page";

import { getFavicon } from "./services/getFavicon";
import { getHostConfiguration } from "./services/getHostConfiguration";
import { getLightConfiguration } from "./services/getLightConfiguration";
import { getTitle } from "./services/getTitle";
import { injectApp } from "./services/injectApp";
import { injectEthereum } from "./services/injectEthereum";
import { injectWagmi } from "./services/injectWagmi";
import { logContent } from "./services/log";
import { replaceMetamask } from "./services/replaceMetamask";
import { sendMessageToNativeApp } from "./services/sendMessageToNativeApp";
import { sendToEthereum } from "./services/sendToEthereum";
import { storeHostConfiguration } from "./services/storeHostConfiguration";
import { allowedDomainCheck } from "./utils/allowedDomainCheck";

import { genId } from "./utils/genId";

let address: string;
let accounts;
let config;

let initialLoad = false;

browser.runtime.onMessage.addListener((message, _sender, sendResponse) => {
  logContent(
    `browserRuntimeOnMessage: ${JSON.stringify(
      message,
    )}, _sender: ${JSON.stringify(_sender)}`,
  );

  if (message.direction == "from-popup-script") {
    switch (message.method) {
      case "open_windowApp":
        (window as Window).location = "lightdotso://";
        break;
      case "write_windowChainId":
        sendToEthereum(message.params, genId(), "changeChainId");
        storeHostConfiguration({
          name: getTitle(),
          favicon: getFavicon(),
          chainId: message.params.chainId,
        });
        break;
      case "write_windowAccount":
        sendMessageToNativeApp({
          id: genId(),
          method: "changeAccount",
          params: message.params,
        });
        address = message.params.wallet;
        break;
      case "delete_windowHost":
        sendMessageToNativeApp({
          id: genId(),
          method: "deleteHostConfiguration",
          params: message.params,
        });
        break;
      case "delete_windowAccount":
        sendMessageToNativeApp({
          id: genId(),
          method: "deleteAllHostConfiguration",
        });
        break;
      case "get_windowAddress":
        sendResponse(address);
        break;
      case "get_windowAccounts":
        sendResponse(accounts);
        break;
      case "get_windowConfig":
        sendResponse(config);
        break;
      case "get_windowChainId":
        sendResponse(window.ethereum.chainId);
        break;
      case "get_windowHost": {
        sendResponse(window.location.hostname.toString());
        break;
      }
    }
  }
});

document.addEventListener("readystatechange", () => {
  logContent(`document.readyState: ${document.readyState}`);

  if (!initialLoad) {
    logContent(`initialLoad: ${initialLoad}`);
    initialLoad = true;

    if (document.readyState === "complete") {
      window.location.reload();
    }

    injectEthereum();
    injectWagmi("");
  }

  if (document.readyState !== "loading" || initialLoad) {
    logContent(`allowedDomainCheck: ${allowedDomainCheck()}`);
    injectApp();

    getHostConfiguration()
      .then(item => {
        if (item?.address) {
          address = item.address;
        }
        if (item?.chainId) {
          sendToEthereum(address, genId(), "requestAccounts");
          injectWagmi(address);
          return item.chainId;
        } else {
          logContent(
            `getHostConfiguration: ${address} for ${
              window.location.host
            } empty at: ${JSON.stringify(item)}`,
          );
          sendToEthereum("", genId(), "requestAccounts");
          injectWagmi("");
          return null;
        }
      })
      .then(chainId => {
        if (chainId) {
          sendToEthereum({ chainId: chainId }, genId(), "switchEthereumChain");
        }
      })
      .then(() => {
        getLightConfiguration().then(item => {
          logContent(
            `getLightConfiguration: ${address}: ${JSON.stringify(item)}`,
          );
          if (item.accounts) {
            config = item;
            accounts = item.accounts;
          }
        });
      });
  }
});

window.addEventListener("message", event => {
  if (event.source == window && event.data) {
    if (event.data.direction == "from-page-script") {
      switch (event.data.message.method) {
        case "requestAccounts":
          getHostConfiguration()
            .then(item => {
              if (item?.address) {
                address = item.address;
              }
              if (item?.chainId) {
                sendToEthereum(
                  address,
                  event.data.message.id,
                  "requestAccounts",
                );
                injectWagmi(address);
                return item.chainId;
              } else {
                logContent(
                  `getHostConfiguration: ${address} for ${
                    window.location.host
                  } empty at: ${JSON.stringify(item)}`,
                );
                injectWagmi("");
                injectComponent(
                  Page({
                    type: "ConnectWallet",
                    id: event.data.message.id,
                    method: event.data.message.method,
                    params: event.data.message.params,
                  }),
                );
                return null;
              }
            })
            .then(chainId => {
              if (chainId) {
                sendToEthereum(
                  { chainId: chainId },
                  genId(),
                  "switchEthereumChain",
                );
              }
            });

          break;
        case "signPersonalMessage":
          injectComponent(
            Page({
              type: "PersonalSign",
              id: event.data.message.id,
              method: event.data.message.method,
              params: event.data.message.params,
            }),
          );
          break;
        case "signTypedMessage":
          injectComponent(
            Page({
              type: "SignTypedMessage",
              id: event.data.message.id,
              method: event.data.message.method,
              params: event.data.message.params,
            }),
          );
          break;
        case "switchEthereumChain":
          injectComponent(
            Page({
              type: "SwitchEthereumChain",
              id: event.data.message.id,
              method: event.data.message.method,
              params: event.data.message.params,
            }),
          );
          break;
        case "signTransaction":
          injectComponent(
            Page({
              type: "SignTransaction",
              id: event.data.message.id,
              method: event.data.message.method,
              params: event.data.message.params,
            }),
          );
          break;
      }
    }
  }
});

setInterval(() => {
  replaceMetamask();
}, 300);
