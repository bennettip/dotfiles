#!/bin/sh
DOTFILES_HOME=~/.dotfiles

warn() {
    echo "$1" >&2
}

die() {
    warn "$1"
    exit 1
}

for COMMAND in fzf vim command-not-found zsh tmux git; do
    ! [ -x "$(command -v $COMMAND)" ] && die "Please install $COMMAND."
done

[ -e "$DOTFILES_HOME" ] && die "$DOTFILES_HOME already exists."

git clone https://github.com/bennettip/dotfiles.git "$DOTFILES_HOME"
cd "$DOTFILES_HOME" || exit
git submodule update --init

./install.sh

cd "$DOTFILES_HOME/plugins/fasd" || exit
PREFIX="$DOTFILES_HOME/plugins/fasd" make install

echo "dotfiles is installed."
