import { App } from "konsta/react";

import "../styles/index.css";
import type { AppProps } from "next/app";
import Head from "next/head";

import { ErrorBoundary } from "../components/ErrorBoundary";

const MyApp = ({ Component, pageProps }: AppProps) => {
  return (
    <App theme="ios">
      <Head>
        <meta
          name="viewport"
          content="width=device-width, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no, viewport-fit=cover"
        />
      </Head>
      <ErrorBoundary>
        <Component {...pageProps} />
      </ErrorBoundary>
    </App>
  );
};

export default MyApp;
