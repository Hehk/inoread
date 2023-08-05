#!/bin/bash

function build() {
  killall server.exe
  dune build _build/default/server/server.exe
  dune build @melange
  bash scripts/build-js.sh
  dune exec -- server/server.exe &
}

source_dirs="bin projects"
args=${*:-"bin/server.exe"}
cmd="dune exec ${args}"

function sigint_handler() {
  kill "$(jobs -pr)"
  exit 1
}

trap sigint_handler SIGINT

while true; do
  dune build
  dune build @melange
  bash scripts/build-js.sh

  $cmd &
  fswatch -r -1 $source_dirs
  printf "\nRestarting server.exe due to filesystem change\n"
  kill "$(jobs -pr)"
done
