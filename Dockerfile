FROM ocaml/opam:alpine-ocaml-4.14 as build-ocaml

WORKDIR /home/opam

USER root
RUN apk add --no-cache openssl-dev libev-dev
USER opam

COPY --chown=opam:opam inoread.opam .
RUN opam install . --deps-only

COPY --chown=opam:opam . .
RUN opam exec -- dune build

FROM ocaml/opam:ubuntu-22.04-ocaml-4.14 as build-js

WORKDIR /usr/src/app
RUN sudo apt-get update && sudo apt-get install -y nodejs npm pkg-config libev-dev

COPY package.json package-lock.json .
RUN npm ci

COPY --chown=opam:opam inoread.opam .
RUN opam install . --deps-only

COPY . .

RUN npm run build

FROM ocaml/opam:alpine-ocaml-4.14 as run

WORKDIR /home/opam

USER root
RUN apk add --no-cache openssl libev
USER opam

COPY --from=build-js --chown=opam:opam /usr/src/app/dist dist
COPY --from=build-ocaml --chown=opam:opam /home/opam/_build/default/server/server.exe server.exe

ENTRYPOINT ["./server.exe"]
