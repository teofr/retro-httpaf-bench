#!/bin/bash
set -xe

run_duration="${RUN_DURATION:-30}"

export GOMAXPROCS=8
export COHTTP_DOMAINS=8
export HTTPAF_EIO_DOMAINS=8
export RUST_CORES=8
export LIBSEFF_THREADS=8

rm -rf output-conn/*
mkdir -p output-conn
rps=800000

for conn in 100 1000 5000 10000 50000; do
  for cmd in "libseff_simple.exe" "libscheff.exe" "libseff_spilling.exe" "libseff_stealing.exe" "libseff_epoll.exe" "rust_hyper.exe" "cohttp_eio.exe" "nethttp_go.exe" ; do
      ./build/$cmd &
      running_pid=$!
      sleep 2;
      ./build/wrk2 -t 24 -d${run_duration}s -L -s ./build/json.lua -R $rps -c $conn http://localhost:8082 > output-conn/run-$cmd-$rps-$conn.txt;
      kill ${running_pid};
      sleep 1;
  done
done

# source build/pyenv/bin/activate
# mv build/parse_output.ipynb .
# jupyter nbconvert --to html --execute parse_output.ipynb
# mv parse_output* output/
