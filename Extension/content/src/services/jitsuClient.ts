import { jitsuClient } from "@jitsu/sdk-js";

export const client = jitsuClient({
  tracking_host: "https://t.jitsu.com",
  key: process.env.JITSU_JS_KEY,
  ip_policy: "strict",
  privacy_policy: "strict",
  cookie_policy: "strict",
});
