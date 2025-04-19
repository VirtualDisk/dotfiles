#!/usr/bin/env bash
set -euo pipefail
main() {
    if [ "$#" -ne 1 ]; then
        echo "Invalid number of arguments. Please run this script and specify ubuntu or arch."
        exit 1
    fi

    if [ "${1}" = "ubuntu" ] || [  "${1}" = "arch" ] || [ "${1}" = "debian" ]; then
        docker-compose run --entrypoint "/usr/bin/zsh" "${1}"
    else
        echo "Unknown platform $1, please select ubuntu or arch."
    fi
}

main "$@"
