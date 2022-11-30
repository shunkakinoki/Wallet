import { GasPriceOracle } from "gas-price-oracle";
import type { NextApiRequest, NextApiResponse } from "next";

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse,
) {
  if (req.method === "OPTIONS") {
    return res.status(200).json({
      body: "OK",
    });
  }

  if (req.method !== "POST") {
    res.status(405).send({ message: "Only POST requests allowed" });
    return;
  }

  const { chainId: chainIdHex } = req.query;
  const chainId = parseInt(
    typeof chainIdHex === "string" ? chainIdHex : "0x1",
    16,
  );

  if (chainId) {
    const oracle = new GasPriceOracle({ chainId: chainId });

    const result = await oracle.getTxGasParams({ ...req.body, isLegacy: true });

    res.status(200);
    return res.send(result);
  }

  res.status(400);
  return res.send({ status: "error" });
}
