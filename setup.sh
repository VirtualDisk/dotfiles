#!/usr/bin/env bash
set -euo pipefail

set_vars()  {
    export HOMEBREW_BUNDLE_FILE="./Brewfile"
    export TERMINAL="iterm2"
}

set_dir()   {
    mkdir -p "$HOME/src"
    cd "$HOME/src"
}

brew()  {
    echo "Starting setup script. Installing brew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    brew bundle
}

oh_my_zsh() {
    echo "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

gogh()  {
    echo "Cloning Gogh repo..."
    git clone https://github.com/Mayccoll/Gogh.git gogh
    echo "Installing brogrammer theme. Welcome, bro."
    ./brogrammer.sh
}

vim()   {
    echo "Installing vim configs..."

    mkdir ~/.vim_runtime
    cp ./vim/* ~/.vim_runtime
    cd ~/.vim_runtime

    echo 'set runtimepath+=~/.vim_runtime

    source ~/.vim_runtime/vimrcs/basic.vim
    source ~/.vim_runtime/vimrcs/filetypes.vim
    source ~/.vim_runtime/vimrcs/plugins_config.vim
    source ~/.vim_runtime/vimrcs/extended.vim

    try
    source ~/.vim_runtime/my_configs.vim
    catch
    endtry' > ~/.vimrc

    echo "Installed the Ultimate Vim configuration successfully! Enjoy :-)"
}

vim_tf()    {
    echo "Installing vim terraform plugin..."
    (cd ~/.vim_runtime/my_plugins;
    git clone https://github.com/hashivim/vim-terraform.git)
}

aliases()     {
   echo "# Aliases
    alias k=kubectl
    alias mk=minikube
    alias tf=terraform
    alias td=terraform-docs
    alias dps="docker ps --format=$FORMAT"
    alias gam="~/bin/gamadv-xtd3/gam"
    alias y="yes > /dev/null"
    alias cat="pygmentize -g"
    alias grep=ag
    alias pj="cd ~/Projects"
    alias it="cd ~/Projects/IT-SaaS-automation"
    alias inf="cd ~/Projects/infrastructure"" >> ~/.zshrc
    }

main()  {
    set_vars
    set_dir
    brew
    oh_my_zsh
    gogh
    vim
    vim_tf
    aliases
}
