import { logBackground } from "./log";

export const forwardEthereumMessage = (request, sendResponse) => {
  logBackground(`==> forwardEthereumMessage: ${JSON.stringify(request)}`);

  sendResponse(request);
};
