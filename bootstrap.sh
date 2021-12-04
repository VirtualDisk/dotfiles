#!/usr/bin/env bash
set -euo pipefail
set -x

check_platform() {
    case "${OSTYPE}" in
        "darwin"*)
            # become_off
            check_brew
            ;;
        "linux-gnu")
            # become_on
            check_ansible_linux
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

check_ansible_linux() {
    if [[ -f /usr/bin/ansible ]]; then
        echo "Ansible found. Installing collections and running playbook..."
        install_collections
    else
        echo "Ansible not found. Installing..."
        # sudo apt update
        # sudo apt upgrade
        # sudo apt install ansible
        apt update
        apt upgrade -y
        apt install ansible -y
        check_ansible_linux
    fi

}

install_collections() {
    ansible-galaxy collection install community.general
    ansible-galaxy collection install ansible.posix
    ansible-galaxy collection install community.docker
    ansible-galaxy install cimon-io.asdf
    ansible-galaxy install markosamuli.asdf
    ansible-playbook -i "${PWD}/.ansible/inventory.yml" \
        "${PWD}/playbook.yml" --ask-become-pass
}

become_on() {
    sed 's/become: yes/become: no' "${PWD}/playbook.yml"
}

become_off() {
    sed 's/become: no/become: yes' "${PWD}/playbook.yml"
}

rundazsh(){
    chsh -s /bin/zsh
    zsh
}

main() {
    check_platform
}

main
