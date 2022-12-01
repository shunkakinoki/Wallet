const { build } = require("esbuild");
require("dotenv").config();

const options = {
  entryPoints: ["./src/inpage.ts"],
  outdir: "../../Application/Light Safari Extension/Resources",
  tsconfig: "tsconfig.json",
  bundle: true,
  minify: true,
};

build(options).catch(() => {
  return process.exit(1);
});
