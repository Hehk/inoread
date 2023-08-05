/** @type {import('tailwindcss').Config} */
export default {
  content: {
    files: ["./bin/**/*.ml"],
  },
  theme: {
    extend: {
      fontFamily: {
        serif: ["var(--font-serif)", "serif"],
      },
    },
  },
  plugins: [],
};
