module.exports = {
  stories: ["../src/**/*.stories.@(js|jsx|ts|tsx)"],
  addons: ["@storybook/addon-essentials"],
  core: {
    builder: "webpack5",
  },
  features: {
    emotionAlias: false,
  },
};
