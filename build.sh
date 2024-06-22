#!/bin/bash
# Build Factorio server with Podman
SOFTWARE="curl jq podman tar xz"

function sanity_check() {
   ok=1
   for prog in $SOFTWARE
   do
      which $prog > /dev/null || { echo "Missing program $prog."; ok=0; }
   done
   test $ok -ne 1 && { echo "Sanity check failed. Aboring." ; exit 1; }
}

sanity_check

GAME_VERSION=$(curl https://factorio.com/api/latest-releases | jq .stable.headless -r)

podman build -t --build-arg VERSION=$GAME_VERSION .
