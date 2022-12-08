module.exports = {
  ignorePatterns: [
    "Application/Light Safari Extension/Resources/**/*.js",
    "Extension/provider/dist/**/*.js",
  ],
  extends: "@lightdotso",
  rules: {
    "@typescript-eslint/no-unused-vars": "off",
    "import/default": "off",
    "no-console": "off",
    "no-restricted-imports": "off",
    "prettier/prettier": "off",
  },
  globals: {
    browser: true,
  },
};
