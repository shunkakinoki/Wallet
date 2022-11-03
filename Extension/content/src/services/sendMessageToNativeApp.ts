import { getFavicon } from "./getFavicon";
import { getTitle } from "./getTitle";
import { logContent } from "./log";

import { sendToEthereum } from "./sendToEthereum";

import { storeHostConfiguration } from "./storeHostConfiguration";
import { storeLightConfiguration } from "./storeLightConfiguration";

export const sendMessageToNativeApp = message => {
  const payload = {
    subject: "message-to-wallet",
    message: message,
    host: window.location.host,
  };
  logContent(`==> sendMessageToNativeApp: ${JSON.stringify(payload)}`);

  browser.runtime.sendMessage(payload).then(response => {
    logContent(`<== sendMessageToNativeApp: ${JSON.stringify(response)}`);

    if (message.method === "requestAccounts") {
      const addresses = (response as unknown as string)
        .replace("[", "")
        .replace("]", "")
        .replaceAll('"', "")
        .split(",");

      if (
        addresses.every(address => {
          return address.startsWith("0x");
        })
      ) {
        storeHostConfiguration({
          name: getTitle(),
          favicon: getFavicon(),
          chainId: window.ethereum.chainId,
        });
        storeLightConfiguration({ accounts: addresses });
      }
    }

    sendToEthereum(response, message.id, message.method);
  });
};
