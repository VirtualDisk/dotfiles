#!/usr/bin/env bash
set -euo pipefail
set -x

YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NOCOLOR='\033[0m'

check_platform() {
    case "${OSTYPE}" in
        "darwin"*)
            check_brew
            ;;
        "linux-gnu")
            check_distro
            rundazsh
            ;;
        *)
            echo "Unsupported platform type ${OSTYPE}"
            ;;
    esac
}


check_brew() {
    if [[ -f /opt/homebrew/bin/brew ]]; then
        echo "Brew found."
    else
        echo "Brew not found. Installing..."
        /bin/bash -c \
            "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        check_brew
    fi

    check_ansible_mac
}

check_ansible_mac() {
    if [[ -f /opt/homebrew/bin/ansible ]]; then
        echo "Ansible found. Installing collections and running playbook..."
        install_collections
    else
        echo "Ansible not found. Installing..."
        brew update
        brew upgrade
        brew install ansible
        check_ansible_mac
    fi
}

check_distro() {
    DISTRO="$(awk -F '=' '{print $2}' /etc/os-release |head -n 1 |sed 's/"//g')"

    case "${DISTRO}" in
        "Arch Linux")
            check_ansible_arch
            ;;
        "Ubuntu"*)
            check_ansible_debian
            ;;
        "Debian"*)
            check_ansible_debian
            ;;
        "Raspbian"*)
            check_ansible_debian
            ;;
        *)
            echo "Unsupported distro $DISTRO"
            ;;
    esac
}

check_ansible_debian() {
    if [[ -f /usr/bin/ansible ]]; then
        echo "Ansible found. Installing collections and running playbook..."
        install_collections
    else
        echo "Ansible not found. Installing..."
        sudo apt update
        sudo apt upgrade -y
        sudo apt install ansible -y
        check_ansible_debian
    fi
}

check_ansible_arch() {
    if [[ -f /usr/bin/ansible ]]; then
        echo "Ansible found. Installing collections and running playbook..."
        install_collections
    else
        echo "Ansible not found. Installing..."
        pacman -Syu ansible --noconfirm
        check_ansible_arch
    fi
}

install_collections() {
    ansible-galaxy install -r "${PWD:-/home/ubuntu}/requirements.yml"
    ansible-galaxy collection install -r "${PWD:-/home/ubuntu}/requirements.yml"
    #TODO: make ask become pass a flag bc of kubernetes unintended installs
    ansible-playbook -i "${PWD:-/home/ubuntu}/local_inventory.yml" \
        "${PWD:-/home/ubuntu}/playbook.yml" --ask-become-pass
}

rundazsh(){
    chsh -s /bin/zsh
    zsh
}

main() {
    printf "${YELLOW}Now bootstrapping the highly opinionated Zoë Environment...\n"
    printf "${BLUE}Detected ${OSTYPE} environment.\n"

    start="$(date +%s)"

    check_platform

    stop="$(date +%s)"
    runtime="$((stop-start))"

    printf "${GREEN}Bootstrap was successful and took ${YELLOW}${runtime} ${GREEN}seconds to run.\n"
    printf "\n"
    neofetch
}

main
