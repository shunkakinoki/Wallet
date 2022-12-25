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
      // eslint-disable-next-line turbo/no-undeclared-env-vars, no-undef
    )}?key=${process.env.COVALENT_API_KEY}`,
  );
}
