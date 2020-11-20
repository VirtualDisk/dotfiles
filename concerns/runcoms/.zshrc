autoload -Uz compinit
compinit
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
source "~/.zshsecrets"
# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
    source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Source asdf
source /opt/homebrew/opt/asdf/libexec/asdf.sh

# Source Google Cloud SDK
source '/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'

# Source kubectl completion
source <(kubectl completion zsh)
complete -F __start_kubectl k

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Aliases

alias k=kubectl
alias mk=minikube
alias tf=terraform
alias y="yes > /dev/null"
alias pj="cd ~/Projects"
alias kt="killall tmux"
alias gst="git status"
alias ga="git add"
alias gcam="git commit -a -m"
alias gcaml="lint && git commit -a -m"
alias showhidden="defaults write com.apple.finder AppleShowAllFiles YES && killall Finder"
alias hidehidden="defaults write com.apple.finder AppleShowAllFiles NO && killall Finder"
alias dockerid="docker ps |awk 'FNR == 2 {print $1}' |pbcopy"
alias ansible="ansible -i ~/.ansible/inventory.yml"
alias ap="ansible-playbook -i ~/.ansible/inventory.yml --ask-become-pass"

# Functions
# BEGIN ANSIBLE MANAGED BLOCK: asdf
if [ -e "$HOME/.asdf/asdf.sh" ]; then
  source $HOME/.asdf/asdf.sh
  source $HOME/.asdf/completions/asdf.bash
fi
# END ANSIBLE MANAGED BLOCK: asdf
