import { logBackground } from "./log";

export const sendNativeMessage = (request, sender, sendResponse) => {
  logBackground(`==> sendNativeMessage: ${JSON.stringify(request)}`);

  browser.runtime.sendNativeMessage(
    "io.magic.light",
    request.message,
    response => {
      logBackground(`<== sendNativeMessage: ${JSON.stringify(response)}`);

      sendResponse(response);
    },
  );
};
