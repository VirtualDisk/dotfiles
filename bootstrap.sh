#!/usr/bin/env bash
set -euo pipefail

RESTORE=$(echo -en '\033[0m')
RED=$(echo -en '\033[00;31m')
GREEN=$(echo -en '\033[00;32m')
YELLOW=$(echo -en '\033[00;33m')
BLUE=$(echo -en '\033[00;34m')
MAGENTA=$(echo -en '\033[00;35m')
PURPLE=$(echo -en '\033[00;35m')
CYAN=$(echo -en '\033[00;36m')
LIGHTGRAY=$(echo -en '\033[00;37m')
LRED=$(echo -en '\033[01;31m')
LGREEN=$(echo -en '\033[01;32m')
LYELLOW=$(echo -en '\033[01;33m')
LBLUE=$(echo -en '\033[01;34m')
LMAGENTA=$(echo -en '\033[01;35m')
LPURPLE=$(echo -en '\033[01;35m')
LCYAN=$(echo -en '\033[01;36m')
WHITE=$(echo -en '\033[01;37m')

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
	DISTRO="$(awk -F '=' '{print $2}' /etc/os-release | head -n 1 | sed 's/"//g')"

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
		"${PWD:-/home/ubuntu}/playbook.yaml" --ask-become-pass
}

rundazsh() {
	chsh -s /bin/zsh
	zsh
}

main() {
	printf "${YELLOW}Now bootstrapping the highly opinionated Zoë Environment...${RESTORE}\n"
	printf "${BLUE}Detected ${OSTYPE} environment.${RESTORE}\n"
	echo ${RED}weeee${YELLOW}eeeee${GREEN}eeeee${BLUE}eeeee${PURPLE}eeeee${RESTORE}

	start="$(date +%s)"

	check_platform

	stop="$(date +%s)"
	runtime="$((stop - start))"

	echo "${GREEN}Bootstrap was successful and took ${YELLOW}${runtime} ${GREEN}seconds to run.${RESTORE}"
	printf "\n"
	neofetch
}

main
