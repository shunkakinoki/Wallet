import { logBackground } from "./log";

export const getLightConfiguration = sendResponse => {
  logBackground(`==> getLightConfiguration`);

  browser.runtime.sendNativeMessage(
    "io.magic.light",
    {
      method: "getLightConfiguration",
      params: {},
    },
    response => {
      logBackground(`<== getLightConfiguration: ${JSON.stringify(response)}`);
      sendResponse(JSON.parse(response));
    },
  );
};
