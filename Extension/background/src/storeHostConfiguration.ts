import { logBackground } from "./log";

export const storeHostConfiguration = (host, payload, sendResponse) => {
  logBackground(
    `==> storeHostConfiguration: ${JSON.stringify({ host, payload })}`,
  );

  browser.runtime.sendNativeMessage(
    "io.magic.light",
    {
      method: "storeHostConfiguration",
      params: {
        host: host,
        chainId: payload.chainId,
        favicon: payload.favicon,
      },
    },
    response => {
      logBackground(`<== sendNativeMessage: ${JSON.stringify(response)}`);

      sendResponse(response);
    },
  );
};
