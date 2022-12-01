const { build } = require("esbuild");
require("dotenv").config();

const define = {};

for (const k in process.env) {
  define[`process.env.${k}`] = JSON.stringify(process.env[k]);
}

const options = {
  entryPoints: ["./src/content.ts"],
  outdir: "../../Application/Light Safari Extension/Resources",
  tsconfig: "tsconfig.build.json",
  define,
};

build(options).catch(() => {
  return process.exit(1);
});
