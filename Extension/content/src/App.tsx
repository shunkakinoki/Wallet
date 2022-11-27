import createCache from "@emotion/cache";
import { CacheProvider } from "@emotion/react";
import React from "react";
import type { ReactNode } from "react";
import { createRoot } from "react-dom/client";
import { SWRConfig } from "swr";

import { logContent } from "./services/log";

export const injectComponent = (children: ReactNode) => {
  logContent(`injectComponent: starting...`);

  const container = document.getElementById("light-wallet-ui");
  document.body.appendChild(container);

  let shadowRoot = container.shadowRoot;
  if (!shadowRoot) {
    shadowRoot = container.attachShadow({ mode: "open" });
  }

  const myCache = createCache({
    container: shadowRoot,
    key: "light-ui",
  });
  const rootElement = document.createElement("main");
  rootElement.setAttribute("id", "light-wallet-root");
  shadowRoot.appendChild(rootElement);
  const root = createRoot(rootElement!);

  root.render(
    <CacheProvider value={myCache}>
      <SWRConfig
        value={{
          onError: (err, key, config) => {
            logContent(`${key}: ${err}`);
          },
        }}
      >
        {children}
      </SWRConfig>
    </CacheProvider>,
  );

  logContent(`injectComponent: complete`);
};
