import { logContent } from "../services/log";

export const injectApp = () => {
  logContent(`injectApp: starting...`);

  try {
    class LightUI extends HTMLElement {}
    window.customElements.define("light-ui", LightUI);
    const app = document.createElement("light-ui");
    app.setAttribute("id", "light-wallet-ui");

    const body = document.querySelector("body");
    body.append(app);

    logContent(`injectApp: complete`);
  } catch (error) {
    console.error("Light: Provider injection failed.", error);
  }
};
