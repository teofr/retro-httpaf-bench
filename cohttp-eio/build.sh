#! /usr/bin/env nix-shell
#! nix-shell -i bash -p opam

set -xe

opam switch remove --yes cohttp-eio-build || true
rm -f ./cohttp_eio.exe || true
opam switch create --packages=dune,eio_main,mdx,uri,fmt,ocaml.5.1.0,ptime cohttp-eio-build
opam exec -- dune clean --profile=release
opam exec -- dune build --profile=release
cp ./_build/default/cohttp_eio.exe ./cohttp_eio.exe
opam switch remove --yes cohttp-eio-build

exit