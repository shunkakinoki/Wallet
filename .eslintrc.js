module.exports = {
  ignorePatterns: ["Application/Light Safari Extension/Resources/**/*.js"],
  extends: "@lightdotso",
  rules: {
    "import/default": "off",
    "no-console": "off",
    "no-restricted-imports": "off",
  },
  globals: {
    browser: true,
  },
};
