import { forwardEthereumMessage } from "./forwardEthereumMessage";
import { getHostConfiguration } from "./getHostConfiguration";
import { getLightConfiguration } from "./getLightConfiguration";
import { logBackground } from "./log";
import { sendNativeMessage } from "./sendNativeMessage";
import { storeHostConfiguration } from "./storeHostConfiguration";
import { storeLightConfiguration } from "./storeLightConfiguration";

logBackground("here from v3");

//@ts-expect-error
browser.runtime.onMessageExternal.addEventListener(
  (request, sender, sendResponse) => {
    if (request.subject === "message-to-wallet") {
      sendNativeMessage(request, sender, sendResponse);
    } else if (request.subject === "getHostConfiguration") {
      getHostConfiguration(request.host, sendResponse);
    } else if (request.subject === "getLightConfiguration") {
      getLightConfiguration(sendResponse);
    } else if (request.subject === "storeHostConfiguration") {
      storeHostConfiguration(request.host, request.payload, sendResponse);
    } else if (request.subject === "storeLightConfiguration") {
      storeLightConfiguration(request.payload, sendResponse);
    } else if (request.subject === "message-to-ethereum") {
      forwardEthereumMessage(request, sendResponse);
    }
    return true;
  },
);
