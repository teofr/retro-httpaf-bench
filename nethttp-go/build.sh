#! /usr/bin/env nix-shell
#! nix-shell -i bash -p go --pure

set -xe

go clean
go build -o nethttp_go.exe httpserv.go

exit