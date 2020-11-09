#!/bin/bash
DOTFILES_HOME=$(pwd)
ZSH=$(which zsh)

chsh_zsh() {
    if ! chsh -s "$ZSH"; then
        echo "chsh command unsuccessful. Change your default shell manually."
    else
        export SHELL="$ZSH"
        echo "Shell successfully changed to '$ZSH'."
    fi
}

cd ..
for TARGET in inputrc bashrc zshrc tmux.conf; do
    if [ -e ".$TARGET" ] && [ ! -L ".$TARGET" ]; then
        mv ".$TARGET" ".$TARGET.old"
        echo
    fi
    if [ ! -L ".$TARGET" ]; then
        ln -s "$DOTFILES_HOME/$TARGET" ".$TARGET"
    fi
done
if [[ "$SHELL" =~ .*/zsh ]]; then
    echo "Good. You are using $SHELL. No need to chsh."
else
    echo "Please change your shell to $ZSH"
    chsh_zsh
fi

cd "$DOTFILES_HOME" || exit
git submodule update --init
