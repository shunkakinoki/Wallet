import type { NextApiRequest, NextApiResponse } from "next";
import { Telegraf } from "telegraf";

//@ts-expect-error
const bot = new Telegraf(process.env.TELEGRAM_BOT_TOKEN);
const LIGHT_ERROR_REPORT_CHAT_ID = "@light_error_report";
const LIGHT_WALLET_REPORT_CHAT_ID = "@light_wallet_report";

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse,
) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader(
    "Access-Control-Allow-Headers",
    "Origin, X-Requested-With, Content-Type, Accept",
  );
  res.setHeader("Access-Control-Allow-Credentials", "true");
  res.setHeader(
    "Access-Control-Allow-Methods",
    "GET, POST, PUT, PATCH, OPTIONS, DELETE",
  );

  if (req.method === "OPTIONS") {
    return res.status(200).json({
      body: "OK",
    });
  }

  if (req.method !== "POST") {
    res.status(405).send({ message: "Only POST requests allowed" });
    return;
  }

  console.log(req.body);
  console.log(
    req.body.host,
    req.body.issue,
    req.body.contact,
    req.body.handle,
    req.body.error,
  );

  await bot.telegram.sendMessage(
    req.body?.error ? LIGHT_ERROR_REPORT_CHAT_ID : LIGHT_WALLET_REPORT_CHAT_ID,
    req.body?.error
      ? `*HOST*: ${req.body.host}\n*error*:\n${req.body.error}\n`.replaceAll(
          ".",
          "\\.",
        )
      : `*HOST*: ${req.body.host}\n*CONTACT*: ${req.body.contact}\n*HANDLE*: ${req.body.handle}\n*ISSUE*:\n${req.body.issue}\n`.replaceAll(
          ".",
          "\\.",
        ),
    { parse_mode: "MarkdownV2" },
  );

  res.status(200);
  return res.send({ success: true });
}
