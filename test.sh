#!/usr/bin/env bash
set -euo pipefail

start="$(date +%s)"
# git pull
docker-compose build
stop="$(date +%s)"

runtime="$((stop-start))"

docker-compose rm ubuntu -sfv && docker compose rm arch -sfv

message="test was successful and took ${runtime} seconds to run"

echo "${message}"
curl -d "${message}" "https://nosnch.in/d90d78316e"
logger "${message}"
