import { logBackground } from "./log";

export const storeLightConfiguration = (payload, sendResponse) => {
  logBackground(`==> storeLightConfiguration: ${JSON.stringify({ payload })}`);

  browser.storage.local.set({ ["light"]: payload });
  sendResponse(payload);
};
