import { EthereumProvider } from "./EthereumProvider";
import { logEthereum } from "./log";

// Work around for Can't find vairable: Buffer Error (https://stackoverflow.com/questions/48432524/cant-find-variable-buffer)
(window as any).global = window;
(window as any).global.Buffer = global.Buffer || require("buffer").Buffer;

window.ethereum = new EthereumProvider({
  isMetamask: true,
  chainId: 1,
  rpcUrl: "https://mainnet.infura.io/v3/013805fd6bd24b3c9a464eeb7c05c63b",
});
window.web3 = { currentProvider: window.ethereum };
window.dispatchEvent(new Event("ethereum#initialized"));
window.metamask = window.ethereum;

window.lightwallet = { overlayConfigurations: [] };
window.lightwallet.postMessage = (method, id, params) => {
  const message = { method: method, id: id, params: params };
  const payload = { direction: "from-page-script", message: message };
  logEthereum(`==> postMessage: ${JSON.stringify(payload)}`);

  window.postMessage(payload, "*");
};

window.addEventListener(
  "message",
  event => {
    if (
      event.source === window &&
      event.data &&
      event.data.direction == "from-content-script"
    ) {
      const response = event.data.response;
      const id = event.data.id;
      const method = event.data.method;

      logEthereum(`<== from-content-script: ${event.data.id}`);

      if (method == "signTransaction") {
        logEthereum("Sign Transaction! Skipping");
        return;
      }

      window.ethereum.processLightWalletResponse(response, id, method);
    }
  },
  false,
);
