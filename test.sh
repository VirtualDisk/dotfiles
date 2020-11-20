#!/usr/bin/env bash
set -euo pipefail

start="$(date +%s)"
git pull
docker build -t dotfiles_test . && docker run --rm dotfiles_test
stop="$(date +%s)"

runtime="$((stop-start))"
message="test was successful and took ${runtime} seconds to run"

echo "${message}"
curl -d "${message}" "https://nosnch.in/d90d78316e"otfiles_test
