#!/usr/bin/env bash
set -euo pipefail

start="$(date +%s)"
# git pull
docker-compose build
stop="$(date +%s)"

runtime="$((stop-start))"

docker-compose rm -f -s ubuntu && docker-compose rm -f -s arch

message="Test was successful and took ${runtime} seconds to run."

echo "${message}"
curl -d "${message}" "https://nosnch.in/d90d78316e"
logger "${message}" --tag dotfiles
