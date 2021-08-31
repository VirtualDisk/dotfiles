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
    export TERMINAL="iterm2"
    export BASE_URL=${BASE_URL:-"https://raw.githubusercontent.com/Mayccoll/Gogh/master"}
    export CURRENT_DIR=$(PWD)
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
git clone --depth=1 "https://github.com/romkatv/powerlevel10k.git" \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
# sed -i -e "s/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k/powerlevel10k"/g" "$HOME/.zshrc"
}

symlinks() {
    # ln -sf "${CURRENT_DIR}/.vimrc" "${HOME}/.vimrc"
    # ln -sf "${CURRENT_DIR}/.vim_runtime" "${HOME}/.vim_runtime"
    # ln -sf "${CURRENT_DIR}/.zshrc" "${HOME}/.zshrc"
    # ln -sf "${CURRENT_DIR}/.tmux.conf" "${HOME}/.tmux.conf"
    # ln -sf "${CURRENT_DIR}/.p10k.zsh" "${HOME}/.p10k.zsh"
    # ln -sf "${CURRENT_DIR}/p10k/fonts/*" "/Library/Fonts"
    #TODO: exclude .git from this
    "cd $HOME" && "ln -sf ${CURRENT_DIR}/runcoms/.z*" "."
    "cd $HOME" && "ln -sf ${CURRENT_DIR}/.*" "."
    "cd /Library/Fonts" && "ln -sf ${CURRENT_DIR}/p10k/fonts/*" "."
    "cd $HOME/Movies" && "ln -sf ${CURRENT_DIR}/premiere_template" "."
}


set_defaults()      {
    echo "Enabling dark mode..."
    sudo defaults write "${HOME}/Library/Preferences/.GlobalPreferences.plist _HIEnableThemeSwitchHotKey -bool true"
    echo "Disabling natural scroll..."
    defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
    mkdir -p "${HOME}/Pictures/Screenshots"
    defaults write com.apple.screencapture location "~/Pictures/Screenshots"
    defaults write "${HOME}/Library/Preferences/.GlobalPreferences.plist KeyRepeat 3"
    defaults write "${HOME}/Library/Preferences/.GlobalPreferences.plist InitialKeyRepeat 15"
    osascript -e 'tell application "Finder" to set desktop picture to POSIX file "/Library/Desktop Pictures/Earth Horizon.jpg"'
}

macktruck()     {
    echo "Running mackup restore..."
    cp "${CURRENT_DIR}/mackup/.mackup.cfg" "$HOME"
    mackup restore
}

main()  {
    check_sudo
    set_vars
    brewtime
    oh_my_zsh
    symlinks
    vimstall
    set_defaults
    macktruck
    plevel10k
}

