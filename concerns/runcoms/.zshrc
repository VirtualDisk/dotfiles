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

export TF_LOG="INFO"

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
alias tfp='tf plan -out .tfplan'
alias tfpv='tfp -var-file=secrets.tfvars'
alias tfdv='tf destroy -var-file=secrets.tfvars'
alias tfa='tf apply .tfplan && rm -v .tfplan'
alias tfix='docker run -it -v $(pwd):/terraform --platform=linux/amd64 hashicorp/terraform -chdir=/terraform init'
alias tfpx='docker run -it -v $(pwd):/terraform --platform=linux/amd64 hashicorp/terraform -chdir=/terraform plan'
alias tfax='docker run -it -v $(pwd):/terraform --platform=linux/amd64 hashicorp/terraform -chdir=/terraform apply'
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
alias livingroom="curl -X POST http://homeassistant.default.zoe/api/webhook/living-room-bright"
alias zbright="curl -X POST http://homeassistant.default.zoe/api/webhook/zoe-lights-bright"
alias zoff="curl -X POST http://homeassistant.default.zoe/api/webhook/zoe-off"
alias zdim="curl -X POST http://homeassistant.default.zoe/api/webhook/zoe-lights-dim"
alias fan="curl -X POST http://homeassistant.default.zoe/api/webhook/toggle-ac"
alias zpurple="curl -X POST http://homeassistant.default.zoe/api/webhook/zoe-lights-purple"
alias zbi="curl -X POST http://homeassistant.default.zoe/api/webhook/zoe-lights-bi"

alias os='openstack --os-cloud=openstack --insecure'
# os() {
#     if [[ -z "${@}" ]]; then
#         echo "Running interactively."
#         ssh -i ~/.ssh/ubuntu zoe@192.168.1.34 "microstack.openstack"
#     else
#         ssh -i ~/.ssh/ubuntu zoe@192.168.1.34 "microstack.openstack ${@}"
#     fi
# }

shipdev() {
    if [[ -z "${1}" ]]; then
        echo "Error: file name required"
    else
        scp -r -i ~/.ssh/ubuntu ${1} ubuntu@192.168.1.232:~ && dev
    fi
}

# Functions
# BEGIN ANSIBLE MANAGED BLOCK: asdf
if [ -e "$HOME/.asdf/asdf.sh" ]; then
  source $HOME/.asdf/asdf.sh
  source $HOME/.asdf/completions/asdf.bash
fi
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

kzke() {
        echo "switched to Zoë Kubernetes Engine"
        export KUBECONFIG="${HOME}/.kube/config.zke"
}

kzoe() {
        echo "zoe mode"
        export KUBECONFIG="${HOME}/.kube/k3s.yaml"
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
    /usr/local/bin/kubectl config use-context "${1}"
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

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/zoe.blanco/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
