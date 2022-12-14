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

  return NextResponse.json(data);
}
