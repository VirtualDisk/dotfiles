#!/usr/bin/env bash
set +x
main() {
    # scp -r "$(PWD)" "zoe@${1}:~"
    ssh -i ~/.ssh/id_rsa "zoe@${1}" -t 'cd $HOME/.dotfiles && ./bootstrap.sh'
}
main "${1}"
