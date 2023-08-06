FROM ocaml/opam:alpine-ocaml-5.0 as build-ocaml

WORKDIR /home/opam

USER root
RUN apk add --no-cache openssl-dev libev-dev
USER opam

COPY --chown=opam:opam inoread.opam .
RUN opam-2.2 install . --deps-only

COPY --chown=opam:opam . .
RUN opam-2.2 exec -- dune build
RUN opam-2.2 exec -- dune build @melange

FROM node:18-alpine as build-js

WORKDIR /usr/src/app

COPY package.json package-lock.json .
RUN npm ci

COPY . .
# required to get the melange generated code
COPY --from=build-ocaml /home/opam/_build _build

RUN sh ./scripts/build-js.sh

FROM ocaml/opam:alpine-ocaml-5.0 as run

WORKDIR /home/opam

USER root
RUN apk add --no-cache openssl libev
USER opam

COPY --from=build-js --chown=opam:opam /usr/src/app/dist dist
COPY --from=build-ocaml --chown=opam:opam /home/opam/_build/default/bin/server.exe server.exe

ENTRYPOINT ["./server.exe"]
