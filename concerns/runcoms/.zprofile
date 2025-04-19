#
# Executes commands at login pre-zshrc.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

#
# Browser
#

if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

#
# Editors
#

export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'

#
# Language
#

if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi

#
# Paths
#

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# Set the list of directories that cd searches.
# cdpath=(
#   $cdpath
# )

# Set the list of directories that Zsh searches for programs.
path=(
  /usr/local/Cellar/coreutils/9.3/libexec/gnubin
  /usr/local/{bin,sbin}
  /opt/homebrew/bin
  /opt/homebrew/sbin
  $HOME/.dotfiles/bin
  $HOME/Greenhouse/infrastructure/bin
  $HOME/Greenhouse/it/bin
  $HOME/.asdf/shims
  $HOME/.linkerd2/bin
  $HOME/.asdf/shims
  $HOME/.tfenv/bin
  $HOME/.dajoku-cli/bin
  $HOME/.krew/bin
  $HOME/bin
  /opt/homebrew/opt/ruby/bin
  /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk
  /usr/local/sbin
  /usr/local/bin
  $path
)

fpath=( 
    $HOME/.dotfiles/concerns/argo
    $fpath 
)

# XDG
export XFG_CONFIG_HOME="$HOME/.config"

#
# Less
#

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-F -g -i -M -R -S -w -X -z-4'

# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
if (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi
