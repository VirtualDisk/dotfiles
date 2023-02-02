autoload -Uz compinit
compinit
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export HISTFILE="${HOME}/.zsh_history"
export HISTFILESIZE=1000000000000
export HISTSIZE=10000000000000
setopt HIST_FIND_NO_DUPS

export ZOEREPO="${HOME}/Projects/zoes-bakery"

# export TF_LOG="INFO"

# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#
# source "~/.zshsecrets"
# Source Prezto.

if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
    source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Source asdf
source /opt/homebrew/opt/asdf/libexec/asdf.sh

# Source Google Cloud SDK
source '/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'

# Source kubectl completion
source <(argo completion zsh)
source <(talosctl completion zsh)
source <(/usr/local/bin/kubectl completion zsh)
# complete -F __start_kubectl k

. "/opt/homebrew/etc/profile.d/z.sh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Aliases
alias a=argo
alias k=kubectl
alias t=talosctl
alias dev='ssh -i ${HOME}/.ssh/ubuntu ubuntu@dev.zoe'
alias tf=terraform
alias inf="cd ~/Greenhouse/infrastructure"
alias tfi='tf init -backend-config=state.conf'
alias ztfp='tf plan -out .tfplan'
alias tfp='tf plan -out .tfplan'
alias tfpv='tfp -var-file=secrets.tfvars'
alias tfdv='tf destroy -var-file=secrets.tfvars'
alias tfa='tf apply .tfplan && rm -v .tfplan'
alias dj="dajoku"
alias y="yes > /dev/null"
alias pj="cd ~/Projects"
alias kt="killall tmux"
alias gst="git status"
alias ga="git add"
alias gcam="git commit -m"
alias gco='git checkout $(git branch | fzf)'
alias showhidden="defaults write com.apple.finder AppleShowAllFiles YES && killall Finder"
alias hidehidden="defaults write com.apple.finder AppleShowAllFiles NO && killall Finder"
alias dockerid="docker ps |awk 'FNR == 2 {print $1}' |pbcopy"
alias ansible="ansible -i ~/.ansible/inventory.yml"
alias ap="ansible-playbook -i ~/.ansible/inventory.yml --ask-become-pass"
alias livingroom="curl -X POST http://homeassistant.zoe/api/webhook/living-room-bright"
alias zbright="curl -X POST http://homeassistant.zoe/api/webhook/zoe-lights-bright"
alias zoff="curl -X POST http://homeassistant.zoe/api/webhook/zoe-off"
alias zdim="curl -X POST http://homeassistant.zoe/api/webhook/zoe-lights-dim"
alias fan="curl -X POST http://homeassistant.zoe/api/webhook/toggle-ac"
alias zpurple="curl -X POST http://homeassistant.zoe/api/webhook/zoe-lights-purple"
alias zbi="curl -X POST http://homeassistant.zoe/api/webhook/zoe-lights-bi"
alias cleardns="sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder"
alias sshm="aws ssm start-session --target"

zop() {
    if [[ ! $(pgrep 'Docker Desktop') ]];  then
        open "/Applications/Docker.app"
    fi
    docker-compose --file ${ZOEREPO}/secrets/onepassword/docker-compose.yaml up -d
    export OP_CONNECT_TOKEN=$(op item get 'zoe connect token terraform' |yq .Fields.credential)
}

tfix() {
    PREVDIR="$(pwd | rev| awk -F / '{print $1}' | rev)"
    cd ..
    docker run -it -v $(pwd):/terraform --platform=linux/amd64 hashicorp/terraform "-chdir=/terraform/${PREVDIR}" init
    cd "${PREVDIR}"
}

tfax() {
    PREVDIR="$(pwd | rev| awk -F / '{print $1}' | rev)"
    cd ..
    docker run -it -v "${HOME}/.kube":"/root/.kube" -v "${HOME}/.ssh":"/root/.ssh" -v $(pwd):/terraform --platform=linux/amd64 hashicorp/terraform "-chdir=/terraform/${PREVDIR}" apply
    cd "${PREVDIR}"
}

tfaxd() {
    PREVDIR="$(pwd | rev| awk -F / '{print $1}' | rev)"
    cd ..
    docker run -e TF_LOG="DEBUG" -it -v "${HOME}/.kube":"/root/.kube" -v "${HOME}/.ssh":"/root/.ssh" -v $(pwd):/terraform --platform=linux/amd64 hashicorp/terraform "-chdir=/terraform/${PREVDIR}" apply
    cd "${PREVDIR}"
}

#!/bin/bash
# find_and_replace.sh
findreplace() {
    echo "Find and replace in current directory!"
    echo "File pattern to look for? (eg '*.txt')"
    read filepattern
    echo "Existing string?"
    read existing
    echo "Replacement string?"
    read replacement
    echo "Replacing all occurences of $existing with $replacement in files matching $filepattern"

    find . -type f -name $filepattern -print0 | xargs -0 sed -i '' -e "s#$existing#$replacement#g"
}

udmdns() {
    ssh -i "~/.ssh/unifi" "root@192.168.1.1" "pkill dnsmasq"
}


av() {
  case $1 in
    s) export AWS_PROFILE="dev.use1";;
    sw) export AWS_PROFILE="dev.usw2";;
    p) export AWS_PROFILE="prod.use1";;
    pw) export AWS_PROFILE="prod.usw2";;
    pec) export AWS_PROFILE="prod.euc1";;
    pew) export AWS_PROFILE="prod.euw1";;
    b) export AWS_PROFILE="bastion.use1";;
    *) export AWS_PROFILE="$1";;
  esac
}

# Functions
# BEGIN ANSIBLE MANAGED BLOCK: asdf
# if [ -e "$HOME/.asdf/asdf.sh" ]; then
#   source $HOME/.asdf/asdf.sh
#   source $HOME/.asdf/completions/asdf.bash
# fi
# END ANSIBLE MANAGED BLOCK: asdf
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -l -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd -t d . $HOME"

export ASDF_HASHICORP_OVERWRITE_ARCH=amd64

## FUNCTIONS ##
c() {
    dadir=${HOME}/$(cd && fzf|rev|cut -d'/' -f2- |rev)
    cd "${dadir}" 
}

v() {
    dafile=${HOME}/$(cd && fzf)
    dadir="$(echo ${dafile}|rev|cut -d'/' -f2- |rev)"
    vi "${dafile}"
    cd "${dadir}"
}

kn() {
    if [[ $(kubectl get ns "${1}" 2>/dev/null) ]]; then
        /usr/local/bin/kubectl config set-context --current --namespace="${1}"
    elif [[ -z "${1}" ]]; then
        kubectl config set-context --current --namespace="$(kubectl get ns |grep -v 'NAME'|fzf|awk '{print $1}')"
    else
        echo "invalid namespace"
    fi
}

kzoe() {
        echo "zoe mode"
        export KUBECONFIG="${HOME}/.kube/config.zoe"
}

kwork() {
        echo "Switched to work mode. You've got this!"
        echo "Say aloud what you are about to do."
        sleep 5
        export KUBECONFIG="${HOME}/.kube/config.gh"
}


lint() {
    cd "${HOME}/Greenhouse/infrastructure"
    SECONDS=0
    PIDS=()
    docker run --rm -v "$(pwd):/todo" --workdir /todo grnhse/circleci-lint:v2.4.1 required &
    PIDS+=($!)
    docker run --rm -v "$(pwd):/todo" --workdir /todo grnhse/circleci-lint:v2.4.1 optional &
    PIDS+=($!)
    RESULT=0
    for p in "${PIDS[@]}"; do
        if ! wait $p; then
            echo "Failure detected"
            RESULT=1
        fi
    done
    echo "Took: $SECONDS seconds to lint"
    exit $RESULT
}

kc() {
    context="$(cat $(echo $KUBECONFIG) |ag -C 3 context: |ag name: |awk '{print $2}'|fzf)"
    /usr/local/bin/kubectl config use-context "${context}"
}

tc() {
    contexts=$(cat <<-EOF
lasagana
bionicle
EOF
)
    context="$(echo ${contexts} |fzf)"
    talosctl config context "${context}"
}

# kubectl() {
#     # only sort if we are listing objects
#     if [[ $(echo "${@}" |ag "get all") ]]; then
#      /usr/local/bin/kubectl "${@}"
#     elif [[ $(echo "${@}" |ag "get") ]]; then
#      /usr/local/bin/kubectl "${@}" |sort --numeric-sort
#     else
#      /usr/local/bin/kubectl "${@}"
#     fi
# }

ips() {
    kubectl get svc -A | ag '192' | awk '{print $5 " " $2}' | sort -n
}


export AWS_SDK_LOAD_CONFIG=true
export AWS_DEFAULT_PROFILE="dev.use1"

aws-vault-use() {
    local profile output

    profile="$1"

    output="$(aws-vault exec "$profile" -- env)"
    if [[ $? -ne 0 ]]; then
        echo "$output" >&2
        return 1
    fi

    eval "$(echo "$output" | awk '/^AWS/ && !/^AWS_VAULT/ { print "export " $1 }')"
}

flipstate () {
        to_local () {
                echo "Moving state to local"
                if mv _state.tf _state.tf.local
                then
                        echo "Done"
                        return 0
                else
                        echo "Failed"
                        return 1
                fi
        }
        to_remote () {
                echo "Moving state to remote"
                if mv _state.tf.local _state.tf
                then
                        echo "Done"
                        return 0
                else
                        echo "Failed"
                        return 1
                fi
        }
        if [[ $# -eq 1 ]]
        then
                case "$1" in
                        (local) to_local ;;
                        (remote) to_remote ;;
                esac
        else
                if [[ -f "_state.tf" ]]
                then
                        to_local
                else
                        to_remote
                fi
        fi
}

param () {
	aws ssm get-parameters --with-decryption --names "$(aws ssm get-parameters-by-path --path / --recursive \
  | jq -r '.Parameters[].Name' | fzf)" | jq -er '.Parameters[].Value' | pbcopy
}

get_command_output() {
    aws ssm list-command-invocations \
        --command-id "${1}" \
        --details \
    | jq -r '.CommandInvocations[].CommandPlugins[].Output'
}

ssm() {
    if [[ -z "${1}" ]]; then
        cat <<-EOF | yq .
To start a session: ssm <instance id>
To run a command once and print output: ssm <instance id> <command>
EOF
        return
    fi

    if [[ ! "$(echo "${1}" | grep 'i-*' )" ]]; then
        echo "${1} is not a valid instance ID."
        return
    fi

    if [[ -z "${2}" ]]; then
        aws ssm start-session --target "${1}"
    else
        COMMAND_ID=$(aws ssm send-command \
            --instance-ids "${1}" \
            --document-name "AWS-RunShellScript" \
            --parameters commands="${2}" \
            | jq -r '.Command.CommandId')
        i=0
        while [[ ! $(get_command_output "${COMMAND_ID}") ]]; do
            i=i++
            while [[ i < 3 ]]; do
            echo "This is taking longer than usual. Trying again in 5 seconds."
        done
            sleep 5
        done

        get_command_output "${COMMAND_ID}"
    fi
}

# ap () {
# 	case $1 in
# 		(d) export AWS_PROFILE="dev.use1"  ;;
# 		(dw) export AWS_PROFILE="dev.usw2"  ;;
# 		(p) export AWS_PROFILE="prod.use1"  ;;
# 		(pw) export AWS_PROFILE="prod.usw2"  ;;
# 		(pec) export AWS_PROFILE="prod.euc1"  ;;
# 		(pew) export AWS_PROFILE="prod.euw1"  ;;
# 		(b) export AWS_PROFILE="bastion.use1"  ;;
# 		(*) export AWS_PROFILE="$1"  ;;
# 	esac
# }

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/zoe.blanco/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/zoe.blanco/Greenhouse/infrastructure/docker/zookeeper/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/zoe.blanco/Greenhouse/infrastructure/docker/zookeeper/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/zoe.blanco/Greenhouse/infrastructure/docker/zookeeper/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/zoe.blanco/Greenhouse/infrastructure/docker/zookeeper/google-cloud-sdk/completion.zsh.inc'; fi
