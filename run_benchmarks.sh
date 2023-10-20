#!/bin/bash
set -xe

run_duration="${RUN_DURATION:-30}"

export GOMAXPROCS=1
export COHTTP_DOMAINS=1
export HTTPAF_EIO_DOMAINS=1
export RUST_CORES=1
export LIBSEFF_THREADS=1

rm -rf output/*
mkdir -p output

for rps in 35000 50000 100000 200000; do
  for cmd in "libseff_simple.exe" "libscheff.exe" "libseff_spilling.exe" "libseff_stealing.exe" "libseff_epoll.exe" "rust_hyper.exe" "cohttp_eio.exe" "nethttp_go.exe" ; do
      ./build/$cmd &
      running_pid=$!
      sleep 2;
      ./build/wrk2 -t 24 -d${run_duration}s -L -s ./build/json.lua -R $rps -c 1000 http://localhost:8082 > output/run-$cmd-$rps-1000.txt;
      kill ${running_pid};
      sleep 1;
  done
done

# source build/pyenv/bin/activate
# mv build/parse_output.ipynb .
# jupyter nbconvert --to html --execute parse_output.ipynb
# mv parse_output* output/
