/** @type {import('tailwindcss').Config} */
export default {
  content: {
    files: ['./server/**/*.ml'],
  },
  theme: {
    extend: {
      fontFamily: {
        mono: ['IBM Plex Mono', 'monospace'],
      },
    },
  },
  plugins: [],
};
