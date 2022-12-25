import type { NextRequest } from "next/server";

export const config = {
  api: {
    bodyParser: false,
  },
  runtime: "experimental-edge",
};

export default async function handler(req: NextRequest) {
  // eslint-disable-next-line no-console
  console.log(req.nextUrl.pathname);
  const r = await fetch(
    `https://api.blowfish.xyz/${req.nextUrl.pathname.replace(
      "/api/blowfish/",
      "",
    )}`,
    {
      //@ts-expect-error
      headers: {
        Accept: "application/json",
        "Content-type": "application/json",
        // eslint-disable-next-line no-undef
        "X-API-KEY": process.env.BLOWFISH_API_KEY,
      },
      body: req.body,
      method: "POST",
    },
  );
  return new Response(r.body, {
    status: r.status,
    headers: {
      "Content-type": r.headers.get("Content-type") || "",
    },
  });
}
