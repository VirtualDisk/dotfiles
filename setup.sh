#!/usr/bin/env bash
set -uo pipefail
sudo -v

set_vars()  {
    SCRIPTDIR="$HOME/.setup"
    export HOMEBREW_BUNDLE_FILE="$HOME/.setup/Brewfile"
    export TERMINAL="iterm2"
	GITDIR="$HOME/src"
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

gogh_install()  {
    export COLOR_01="#1f1f1f"           # HOST
    export COLOR_02="#f81118"           # SYNTAX_STRING
    export COLOR_03="#2dc55e"           # COMMAND
    export COLOR_04="#ecba0f"           # COMMAND_COLOR2
    export COLOR_05="#2a84d2"           # PATH
    export COLOR_06="#4e5ab7"           # SYNTAX_VAR
    export COLOR_07="#1081d6"           # PROMP
    export COLOR_08="#d6dbe5"           #

    export COLOR_09="#d6dbe5"           #
    export COLOR_10="#de352e"           # COMMAND_ERROR
    export COLOR_11="#1dd361"           # EXEC
    export COLOR_12="#f3bd09"           #
    export COLOR_13="#1081d6"           # FOLDER
    export COLOR_14="#5350b9"           #
    export COLOR_15="#0f7ddb"           #
    export COLOR_16="#ffffff"           #

    export BACKGROUND_COLOR="#131313"   # Background Color
    export FOREGROUND_COLOR="#d6dbe5"   # Text
    export CURSOR_COLOR="$FOREGROUND_COLOR" # Cursor
    export PROFILE_NAME="Brogrammer"
    # =============================================================== #
    # | Apply Colors
    # ===============================================================|#
    SCRIPT_PATH="${SCRIPT_PATH:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
    PARENT_PATH="$(dirname "${SCRIPT_PATH}")"

    # Allow developer to change url to forked url for easier testing
    # IMPORTANT: Make sure you export this variable if your main shell is not bash
    BASE_URL=${BASE_URL:-"https://raw.githubusercontent.com/Mayccoll/Gogh/master"}

    if [[ -e "${PARENT_PATH}/apply-colors.sh"  ]]; then
          bash "${PARENT_PATH}/apply-colors.sh"
      else
            if [[ "$(uname)" = "Darwin"  ]]; then
                    # OSX ships with curl and ancient bash
                    bash -c "$(curl -so- "${BASE_URL}/apply-colors.sh")"
                    else
                    # Linux ships with wget
                    bash -c "$(wget -qO- "${BASE_URL}/apply-colors.sh")"
            fi
    fi

}

vim_install()   {
    echo "Installing vim configs..."

    (cp "$SCRIPTDIR/.vim_runtime $HOME"

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
    (cd "$HOME/.vim_runtime/my_plugins";
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
    darkmode
    macktruck
}
main
