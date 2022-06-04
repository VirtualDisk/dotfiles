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
    /usr/local/bin/kubectl config set-context --current --namespace="${1}"
}

kzoe() {
    if [[ $(ag "192.168.1.221" "${HOME}/.kube/config") ]]; then
        echo "not switching"
    else
       mv "${HOME}/.kube/config" "${HOME}/.kube/config.gh"
       mv "${HOME}/.kube/config.zoe" "${HOME}/.kube/config" 
       echo "zoe mode"
    fi
}

kwork() {
    if [[ $(ag "192.168.1.221" "${HOME}/.kube/config") ]]; then
       mv "${HOME}/.kube/config" "${HOME}/.kube/config.zoe"
       mv "${HOME}/.kube/config.gh" "${HOME}/.kube/config" 
       echo "work mode"
    else
        echo "not switching"
    fi
}

# Aliases
# alias k=kubectl
alias a=argo
alias k=kubectl
alias mk=minikube
alias tf=terraform
alias y="yes > /dev/null"
alias pj="cd ~/Projects"
alias kt="killall tmux"
alias gst="git status"
alias ga="git add"
alias gcam="git commit -m"
alias gco='git checkout $(git branch | fzf)'
alias gcaml="lint && git commit -a -m"
alias showhidden="defaults write com.apple.finder AppleShowAllFiles YES && killall Finder"
alias hidehidden="defaults write com.apple.finder AppleShowAllFiles NO && killall Finder"
alias dockerid="docker ps |awk 'FNR == 2 {print $1}' |pbcopy"
alias ansible="ansible -i ~/.ansible/inventory.yml"
alias ap="ansible-playbook -i ~/.ansible/inventory.yml --ask-become-pass"
alias llights="curl -X POST http://192.168.1.254/api/webhook/living-room-lights"
alias zbright="curl -X POST http://192.168.1.254/api/webhook/zoe-lights-bright"
alias zdim="curl -X POST http://192.168.1.254/api/webhook/zoe-lights-dim"

kubectl() {
    # only sort if we are listing objects
    if [[ $(echo "${@}" |ag "get") ]]; then
     /usr/local/bin/kubectl "${@}" |sort
    else
     /usr/local/bin/kubectl "${@}"
    fi
}
 
# pipe ultralist into fzf for ultra-fast searching of tasks!
alias uf="script -c \"ultralist l\"  < /dev/null | fzf --ansi"

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

###
alias it="cd ~/Greenhouse/IT"
alias inf="cd ~/Greenhouse/infrastructure"
alias grnhse="cd ~/Greenhouse"
alias td=terraform-docs
alias tfi='tf init -backend-config=state.conf'
alias tfp='tf plan -out .tfplan'
alias tfpv='tfp -var-file=secrets.tfvars'
alias tfdv='tf destroy -var-file=secrets.tfvars'
alias tfa='tf apply .tfplan && rm -v .tfplan'
alias dj="dajoku"

export ASDF_HASHICORP_OVERWRITE_ARCH=amd64

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

dread() #short for "defaults read"
{
    defaults read $(pwd)/"${1}"
}
