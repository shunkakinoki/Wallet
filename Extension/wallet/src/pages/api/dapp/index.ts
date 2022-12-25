import type { NextRequest } from "next/server";
import { NextResponse } from "next/server";

export const config = {
  api: {
    bodyParser: false,
  },
  runtime: "experimental-edge",
};

export default async function handler(req: NextRequest) {
  const response = await fetch("https://wallet.light.so/dapp.json");
  const data = await response.json();

  return NextResponse.json({
    dapps: [
      ...data.dapps,
      {
        name: "Connext",
        icon: "https://bridge.connext.network/favicon.png",
        site: "https://bridge.connext.network",
        type: "trending",
      },
      {
        name: "Multichain",
        icon: "https://app.multichain.org/favicon.ico",
        site: "https://app.multichain.org",
        type: "trending",
      },
      {
        name: "mint.fun",
        icon: "https://mint.fun/icon180.png",
        site: "https://mint.fun",
        type: "trending",
      },
      {
        name: "Free NFT",
        icon: "https://i.ibb.co/St9wCG3/Frame-478.png",
        site: "https://freenft.xyz",
        type: "trending",
      },
    ],
  });
}
