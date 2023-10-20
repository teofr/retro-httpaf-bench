#!/bin/bash
set -xe

run_duration="${RUN_DURATION:-30}"


rm -rf output-th/*
mkdir -p output-th
rps=2000000

# Total 72 CPUS
for th in 1 8 16 32; do
  export GOMAXPROCS=$th
  export COHTTP_DOMAINS=$th
  export HTTPAF_EIO_DOMAINS=$th
  export RUST_CORES=$th
  export LIBSEFF_THREADS=$th
  for cmd in "libseff_simple.exe" "libscheff.exe" "libseff_spilling.exe" "libseff_stealing.exe" "libseff_epoll.exe" "rust_hyper.exe" "cohttp_eio.exe" "nethttp_go.exe" ; do
      ./build/$cmd &
      running_pid=$!
      sleep 2;
      ./build/wrk2 -t 32 -d${run_duration}s -L -s ./build/json.lua -R $rps -c 1000 http://localhost:8082 > output-th/run-$cmd-$th-1000.txt;
      kill ${running_pid};
      sleep 1;
  done
done

# source build/pyenv/bin/activate
# mv build/parse_output.ipynb .
# jupyter nbconvert --to html --execute parse_output.ipynb
# mv parse_output* output/
