import type { NextRequest } from "next/server";

export const config = {
  api: {
    bodyParser: false,
  },
  runtime: "experimental-edge",
};

export default async function handler(req: NextRequest) {
  console.log(req.nextUrl.pathname);
  const r = await fetch(
    `https://api.coherent.sh/${req.nextUrl.pathname.replace(
      "/api/coherent/",
      "",
    )}`,
    {
      //@ts-expect-error
      headers: {
        Accept: "application/json",
        "Content-type": "application/json",
        "X-API-KEY": process.env.COHERENT_API_KEY,
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
