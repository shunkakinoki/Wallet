import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";

export const config = {
  runtime: "experimental-edge",
};

export default async function handler(req: NextRequest) {
  return fetch("https://wallet.light.so/dapp.json")
    .then(response => {
      return response.json();
    })
    .then(data => {
      return NextResponse.json(data);
    })
    .catch(err => {
      print(err);
    });
}
