module.exports = {
  stories: ["../src/**/*.stories.@(js|jsx|ts|tsx)"],
  core: {
    builder: "webpack5",
  },
  features: {
    emotionAlias: false,
  },
};
