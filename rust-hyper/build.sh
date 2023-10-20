#! /usr/bin/env nix-shell
#! nix-shell -i bash -p cargo --pure

set -xe

cargo clean
cargo build --release
cp target/release/rust-hyper ./rust_hyper.exe

exit