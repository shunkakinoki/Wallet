import { App } from "konsta/react";

import "../styles/index.css";
import type { AppProps } from "next/app";

const MyApp = ({ Component, pageProps }: AppProps) => {
  return (
    <App theme="ios">
      <Component {...pageProps} />{" "}
    </App>
  );
};

export default MyApp;
