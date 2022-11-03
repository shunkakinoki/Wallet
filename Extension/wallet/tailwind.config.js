const konstaConfig = require("konsta/config");

/** @type {import('tailwindcss').Config} */
module.exports = konstaConfig({
  content: ["./src/**/*.{js,ts,jsx,tsx}"],
  darkMode: "media",
  theme: {
    extend: {},
  },
  plugins: [],
});
