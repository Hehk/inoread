/** @type {import('tailwindcss').Config} */
export default {
  content: {
    files: ["./server/**/*.ml"],
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
