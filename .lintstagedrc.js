module.exports = {
  "*.{js,ts,tsx}": ["yarn run eslint:cmd --fix"],
  "*.{md,json,yml}": ["yarn run prettier:cmd --write"],
  "*.swift": ["yarn run swift-format:cmd"],
  "package.json": ["yarn run prettier:cmd --write"],
};
