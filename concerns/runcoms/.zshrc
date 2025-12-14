# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
export ZSH="$HOME/.oh-my-zsh"
export ZSH_THEME="powerlevel10k/powerlevel10k"
export XDG_CONFIG_HOME="${HOME}/.config"

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit

ZSH_TMUX_AUTOSTART=true

plugins=(
  aliases
  argocd 
  docker
  docker-compose
  git 
  helm 
  history-substring-search
  k9s
  kubectl 
  terraform 
  tmux
  task
  vi-mode
  web-search
)


export HISTFILE="${HOME}/.zsh_history"
export HISTFILESIZE=1000000000000
export HISTSIZE=10000000000000
setopt HIST_FIND_NO_DUPS

export GPG_TTY=$(tty)

export ZOEREPO="${HOME}/Projects/zoe-infrastructure"
export SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt
export EDITOR=nvim
export KUBE_EDITOR=nvim
export K9S_CONFIG_DIR="${HOME}/.dotfiles/concerns/k9s"
export KUBECONFIG="${HOME}/.kube/config"
export TALOSCONFIG="${HOME}/.talos/config"
# timg, photo and video viewer
export TIMG_USE_UPPER_BLOCK=1


if [[ -s "${ZDOTDIR:-$HOME}/.zshmac" ]]; then
    source "${ZDOTDIR:-$HOME}/.zshmac"
fi

if [[ -s "${ZDOTDIR:-$HOME}/.zshcompletions" ]]; then
    source "${ZDOTDIR:-$HOME}/.zshcompletions"
fi

if [[ -s "${ZDOTDIR:-$HOME}/.zshfunctions" ]]; then
    source "${ZDOTDIR:-$HOME}/.zshfunctions"
fi

if [[ -s "${ZDOTDIR:-$HOME}/.zshgreenhouse" ]]; then
    source "${ZDOTDIR:-$HOME}/.zshgreenhouse"
fi

if [[ -s "${ZDOTDIR:-$HOME}/.zshsecrets" ]]; then
    source "${ZDOTDIR:-$HOME}/.zshsecrets"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Aliases
alias vim=nvim
alias vi=nvim
alias grepo="cdfzf Greenhouse"
alias repo="cdfzf Projects"
alias a=argo
alias k=kubectl
# alias k9s='k9s --context $(command kubectl config get-contexts -o name | fzf)'
alias t=talosctl
alias dev='ssh -i ${HOME}/.ssh/ubuntu ubuntu@dev.zoe'
alias linstor='kubectl exec -n cozy-linstor deploy/linstor-controller -- linstor'
alias tf=terraform
alias inf="cd ~/Greenhouse/infrastructure"
alias tfi='tf init -backend-config=state.conf'
alias ztfp='tf plan -out .tfplan'
alias tfp='tf plan'
alias tfpl='terraform plan -out=.tfplan && terraform show -json .tfplan | jq '"'"'.resource_changes[]|select(.change.actions != ["no-op"])|(.change.actions|join(","))+": "+.address'"'"' -r'
alias tfpv='tfp -var-file=secrets.tfvars'
alias tfdv='tf destroy -var-file=secrets.tfvars'
alias tfa='tf apply'
alias dj="dajoku"
alias music="ncmpcpp --host mpd.zoe"
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
alias realpath=grealpath
# alias ap="ansible-playbook -i ~/.ansible/inventory.yml --ask-become-pass"
alias livingroom="curl -X POST http://homeassistant.zoe/api/webhook/living-room-bright"
alias zbright="curl -X POST http://homeassistant.zoe/api/webhook/zoe-lights-bright"
alias zoff="curl -X POST http://homeassistant.zoe/api/webhook/zoe-off"
alias zdim="curl -X POST http://homeassistant.zoe/api/webhook/zoe-lights-dim"
alias fan="curl -X POST http://homeassistant.zoe/api/webhook/toggle-ac"
alias zpurple="curl -X POST http://homeassistant.zoe/api/webhook/zoe-lights-purple"
alias zbi="curl -X POST http://homeassistant.zoe/api/webhook/zoe-lights-bi"
alias cleardns="sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder"
alias ytmp3="yt-dlp -x --audio-format mp3"

export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -l -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd -t d . $HOME"

eval "$(direnv hook zsh)"

# Added by Windsurf
export PATH="/Users/zoe.blanco/.codeium/windsurf/bin:$PATH"

source $ZSH/oh-my-zsh.sh
