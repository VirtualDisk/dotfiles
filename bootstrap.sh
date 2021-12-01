#!/usr/bin/env bash
set -euo pipefail

check_brew() {
    if [[ -f /opt/homebrew/bin/brew ]]; then
        echo "Brew found."
        check_ansible
    else
        echo "Brew not found. Installing..."
        /bin/bash -c \
            "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
}

check_ansible() {
    if [[ -f /opt/homebrew/bin/ansible ]]; then
        echo "Ansible found. Running playbook..."
        ansible-playbook -i "${PWD}/.ansible/inventory.yml \
            ${PWD}/playbool.yml"
    else
        echo "Ansible not found. Installing..."
        brew update
        brew upgrade
        brew install ansible
        check_ansible
    fi
}

main() {
    check_brew
    check_ansible
}

main
