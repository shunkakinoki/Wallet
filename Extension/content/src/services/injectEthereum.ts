import { logContent } from "../services/log";

export const injectEthereum = () => {
  logContent(`injectEthereum: starting...`);

  try {
    const container = document.head || document.documentElement;
    const scriptTag = document.createElement("script");
    scriptTag.setAttribute("async", "false");
    var request = new XMLHttpRequest();
    request.open("GET", browser.runtime.getURL("inpage.js"), false);
    request.send();
    scriptTag.textContent = request.responseText;
    container.insertBefore(scriptTag, container.children[0]);
    container.removeChild(scriptTag);

    logContent(`injectEthereum: complete`);
  } catch (error) {
    console.error("Light: Ethereum injection failed.", error);
  }
};
