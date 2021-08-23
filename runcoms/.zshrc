# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Source Google Cloud SDK

source '/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Aliases

alias k=kubectl
alias mk=minikube
alias dps="docker ps --format=$FORMAT"
alias gam="/Users/zoe.blanco/bin/gamadv-xtd3/gam"
alias tf=terraform
alias y="yes > /dev/null"
alias it="cd ~/Greenhouse/IT"
alias inf="cd ~/Greenhouse/infrastructure"
# alias grhse="cd ~/Greenhouse"
alias pj="cd ~/Projects"
alias td=terraform-docs
alias 11a="ssh -i $HOME/.ssh/11a ghlaps@172.18.0.149"
alias mbp="ssh zoe@zoes-mbp.lan"
alias tfi='tf init -backend-config=state.conf'
alias tfp='tf plan -out .tfplan'
alias tfa='tf apply .tfplan && rm -v .tfplan'
alias kt="killall tmux"
alias gst="git status"
alias ga="git add"
alias gcam="git commit -a -m"
alias showhidden="defaults write com.apple.finder AppleShowAllFiles YES && killall Finder"
alias hidehidden="defaults write com.apple.finder AppleShowAllFiles NO && killall Finder"

# Functions

kc() {
	kubectl config use-context "${1}"
}

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

n2ip() {
    aws \
      ec2 describe-instances \
      --filters "Name=tag:Name,Values=*${1}*" Name=instance-state-name,Values=running \
        | jq -r '
          .Reservations[].Instances[]
          | [.NetworkInterfaces[0].PrivateIpAddress,
            (.Tags[] |
              select(.Key == "Name").Value),(.InstanceId),(.LaunchTime)] | join("\t")
          '
        }

teamid() {
    codesign -dv "${1}" 2>&1 | ag --nocolor TeamIdentifier
}

GAM_DIR="${HOME}/.gam"
gamgetcurrentcontext() {
    awk -F/ '/config_dir/ {print $5}' ${GAM_DIR}/gam.cfg
}

printgamcurrentcontext() {
    echo "$(gamgetcurrentcontext)"
    }

gamlistcontexts() {
    awk '/"email":/ {print $2}' ${GAM_DIR}/*/oauth2.txt \
        |sed -e 's/\"//g' \
        -e 's/\,//g' \
        | fzf 
    echo "GAM current context: $(printgamcurrentcontext)"
}

gamswitchcontexts() {
    sed -i -e "s/$(printgamcurrentcontext)/${1}/" "${GAM_DIR}/gam.cfg" 
}

gamc() {
    if [[ "${1}" == "" ]]; then
        gamlistcontexts
    else 
        gamswitchcontexts "${1}"
    fi
}
