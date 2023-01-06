const { build } = require("esbuild");
require("dotenv").config();

const options = {
  entryPoints: ["./src/content.ts"],
  outdir: "../../Application/LightSafariExtension/Resources",
  tsconfig: "tsconfig.build.json",
  bundle: true,
  minify: true,
  define: {
    "process.env.JITSU_JS_KEY": JSON.stringify(process.env.JITSU_JS_KEY ?? ""),
    "process.env.NODE_ENV": JSON.stringify(process.env.NODE_ENV),
  },
};

build(options).catch(() => {
  return process.exit(1);
});
