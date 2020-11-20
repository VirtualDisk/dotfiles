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
    cd ~/.vim_runtime/my_plugins
    git clone https://github.com/hashivim/vim-terraform.git
}

main()  {
    set_vars
    set_dir
    brew
    gogh
    vim
    vim_tf
}
