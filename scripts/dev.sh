#!/bin/bash

fswatch -o ./server | while read num; do
  dune build
  dune exec -- server/server.exe
  
  dune build @melange
  bash scripts/build-js.sh
done
