import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";

export const config = {
  api: {
    bodyParser: false,
  },
  runtime: "experimental-edge",
};

export default async function handler(req: NextRequest) {
  console.log(req.nextUrl.pathname);
  return NextResponse.rewrite(
    `https://logos.covalenthq.com/tokens/${req.nextUrl.pathname.replace(
      "/api/token/",
      "",
    )}?key=${process.env.COVALENT_API_KEY}`,
  );
}
