import { App } from "konsta/react";
// eslint-disable-next-line import/no-unresolved
import "swiper/css";
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
