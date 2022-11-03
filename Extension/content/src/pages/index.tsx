import type { NextPage } from "next";
import React from "react";

import { Page } from "../components/Page";

export const Home: NextPage = () => {
  return <Page id={1} type="ConnectWallet" method={""} params="" />;
};

export default Home;
