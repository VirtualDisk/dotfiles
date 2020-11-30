#!/usr/bin/env bash
set -uo pipefail
sudo -v

set_vars()  {
    SCRIPTDIR="$HOME/.setup"
    export HOMEBREW_BUNDLE_FILE="$HOME/.setup/Brewfile"
    export TERMINAL="iterm2"
	GITDIR="$HOME/src"
}

brewtime()  {
    echo "Starting setup script. Installing brew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    brew bundle
}

oh_my_zsh() {
    echo "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

gogh_install()  {
    mkdir -p "$GITDIR"
    echo "Cloning Gogh repo..."
    git clone https://github.com/Mayccoll/Gogh.git "$GITDIR"
    echo "Installing brogrammer theme. Welcome, bro."
    "$GITDIR"/Gogh/themes/brogrammer.sh
}

vim_install()   {
    echo "Installing vim configs..."

    (mkdir ~/.vim_runtime
    cd ~/.vim_runtime

    echo 'set runtimepath+=~/.vim_runtime

    source ~/.vim_runtime/vimrcs/basic.vim
    source ~/.vim_runtime/vimrcs/filetypes.vim
    source ~/.vim_runtime/vimrcs/plugins_config.vim
    source ~/.vim_runtime/vimrcs/extended.vim

    try
    source ~/.vim_runtime/my_configs.vim
    catch
    endtry' > ~/.vimrc)

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
    alias gam="$HOME/bin/gamadv-xtd3/gam"
    alias y="yes > /dev/null"
    alias cat="pygmentize -g"
    alias grep=ag
    alias pj="cd ~/Projects"
    alias it="cd ~/Projects/IT-SaaS-automation"
    alias inf="cd ~/Projects/infrastructure"" >> ~/.zshrc
    }

darkmode()      {
    echo "Enabling dark mode..."
    sudo defaults write /Library/Preferences/.GlobalPreferences.plist _HIEnableThemeSwitchHotKey -bool true
}

macktruck()     {
    echo "Running mackup restore..."
    cp "$SCRIPTDIR/mackup/.mackup.cfg" "$HOME"
    mackup restore
}


main()  {
    set_vars
    set_dir
    brewtime
    oh_my_zsh
    gogh_install
    vim_install
    vim_tf
    aliases
}
main
