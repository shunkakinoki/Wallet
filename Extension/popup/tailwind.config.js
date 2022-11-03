const konstaConfig = require("konsta/config");

/** @type {import('tailwindcss').Config} */
module.exports = konstaConfig({
  content: ["./src/**/*.{js,ts,jsx,tsx}"],
  darkMode: "media",
  theme: {
    extend: {
      colors: {
        "ios-light-surface-1": "#efeff4",
      },
    },
  },
  plugins: [require("@tailwindcss/line-clamp")],
});
