import { logBackground } from "./log";

export const getHostConfiguration = (host, sendResponse) => {
  logBackground(`==> getHostConfiguration: ${JSON.stringify({ host })}`);

  browser.runtime.sendNativeMessage(
    "io.magic.light",
    {
      method: "getHostConfiguration",
      params: {
        host: host,
      },
    },
    response => {
      logBackground(`<== getHostConfiguration: ${JSON.stringify(response)}`);
      sendResponse(JSON.parse(response));
    },
  );
};
