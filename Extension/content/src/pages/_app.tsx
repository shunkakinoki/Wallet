import type { AppProps } from "next/app";

const MyApp = ({ Component, pageProps }: AppProps) => {
  return (
    <div id="light-wallet-root">
      <Component {...pageProps} />
    </div>
  );
};
export default MyApp;
