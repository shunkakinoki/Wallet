import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";

export const config = {
  api: {
    bodyParser: false,
  },
  runtime: "experimental-edge",
};

export default async function handler(req: NextRequest) {
  return NextResponse.rewrite(
    `https://api.covalenthq.com/${req.nextUrl.pathname.replace(
      "/api/covalent/",
      "",
    )}?key=${process.env.COVALENT_API_KEY}`,
  );
}
