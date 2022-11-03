import { logContent } from "./log";

export const sendToEthereum = (response, id, method) => {
  logContent(
    `==> sendToEthereum: ${JSON.stringify({
      response: response,
      id: id,
      method: method,
    })}`,
  );

  window.postMessage(
    {
      direction: "from-content-script",
      response: response,
      id: id,
      method: method,
    },
    "*",
  );
};
