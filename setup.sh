#!/usr/bin/env bash
set -uo pipefail

check_sudo() {
    if [[ "$(/usr/bin/id -u)" -ne 0 ]]; then
        echo "You must run this script as root."
        exit 2
    else
        main
    fi
}
set_vars()  {
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

git clone --depth=1 "https://github.com/romkatv/powerlevel10k.git" \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
# sed -i -e "s/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k/powerlevel10k"/g" "$HOME/.zshrc"
}

symlinks() {
    ln -sf "$(PWD)/.vim_runtime" "${HOME}/.vim_runtime"
    ln -sf $(PWD)/.zshrc ${HOME}/.zshrc
    ln -sf $(PWD)/.tmux.conf ${HOME}/.tmux.conf
    ln -sf "$(PWD)/.p10k.zsh" "${HOME}";
    ln -sf "$(PWD)/p10k/fonts/*" "/Library/Fonts"
}

set_defaults()      {
    echo "Enabling dark mode..."
    sudo defaults write /Library/Preferences/.GlobalPreferences.plist _HIEnableThemeSwitchHotKey -bool true
    echo "Disabling natural scroll..."
    defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
}

macktruck()     {
    echo "Running mackup restore..."
    cp "$PWD/mackup/.mackup.cfg" "$HOME"
    mackup restore
}

main()  {
    check_sudo
    set_vars
    brewtime
    oh_my_zsh
    symlinks
    set_defaults
    macktruck
    plevel10k
}

