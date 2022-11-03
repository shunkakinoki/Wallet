/** @type {import('next').NextConfig} */
module.exports = {
  reactStrictMode: true,
  assetPrefix: !process.env.VERCEL ? "/popup" : "/",
};
