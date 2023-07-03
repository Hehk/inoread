#!/bin/bash

npx tailwindcss build ./client/styles.css -o ./dist/styles.css
dune build @melange
npx esbuild ./dist/styles.css --minify --outfile=./dist/styles.css --allow-overwrite
npx esbuild ./_build/default/client/client/client/grid.js --target=es2020 --platform=browser --bundle --outfile=./dist/grid.js
