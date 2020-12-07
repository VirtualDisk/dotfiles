#!/usr/bin/env bash
set -uo pipefail

set_vars()  {
    export SCRIPTDIR="$HOME/.setup"
    export GITDIR="$HOME/src"
    export HOMEBREW_BUNDLE_FILE="$HOME/.setup/Brewfile"
    export TERMINAL="iterm2"
    export BASE_URL=${BASE_URL:-"https://raw.githubusercontent.com/Mayccoll/Gogh/master"}
}

brewtime()  {
    echo "Starting setup script. Installing brew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    brew bundle
}

oh_my_zsh() {
    echo "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}

plevel10k()   {
#TODO: find and remove existing theme line in zshrc
#TODO: skip config wizard
(cp "$SCRIPTDIR/.p10k.zsh" "$HOME";
cp "$SCRIPTDIR/p10k/fonts/*" "/Library/Fonts")

git clone --depth=1 "https://github.com/romkatv/powerlevel10k.git" "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
sed -i -e "s/ZSH_THEME="robbyrussel"/ZSH_THEME="powerelevel10k/powerlevel10k"/g" "$HOME/.zshrc"
}

vim_install()   {
    echo "Installing vim configs..."

    cp -R ".vim_runtime" "$HOME"
    #cp -R "$SCRIPTDIR/.vim_runtime" "$HOME"

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
    (cd "$HOME/.vim_runtime/my_plugins";
    git clone https://github.com/hashivim/vim-terraform.git)
}

aliases()     {
    #TODO: this doesn't work, and likely needs to be a heredoc
   echo "# Aliases
    alias k=kubectl
    alias mk=minikube
    alias tf=terraform
    alias td=terraform-docs
    alias gam="$HOME/bin/gamadv-xtd3/gam"
    alias y="yes > /dev/null"
    alias cat="pygmentize -g"
    alias grep=ag
    alias pj="cd ~/Projects"
    alias it="cd ~/Projects/IT-SaaS-automation"
    alias inf="cd ~/Projects/infrastructure"" >> ~/.zshrc
    }

set_defaults()      {
    echo "Enabling dark mode..."
    sudo defaults write /Library/Preferences/.GlobalPreferences.plist _HIEnableThemeSwitchHotKey -bool true
    echo "Disabling natural scroll..."
    defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
}

macktruck()     {
    echo "Running mackup restore..."
    cp "$SCRIPTDIR/mackup/.mackup.cfg" "$HOME"
    mackup restore
}

main()  {
    set_vars
    brewtime
    oh_my_zsh
    vim_install
    vim_tf
    #aliases
    set_defaults
    macktruck
    plevel10k
    #TODO: add ~/.ssh & other secret file copy logic from ext usb
}

if [[ "$(/usr/bin/id -u)" -ne 0 ]]; then
    echo "You must run this script as root."
    exit 2
else
    main
fi
