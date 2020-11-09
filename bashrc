#
# ~/.bashrc
#

# ~/.bashrc {
# If not running interactively, don't do anything
#case $- in
#    *i*) ;;
#      *) return;;
#esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=10000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Change the window title of X terminals
PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
# }

# bash_profile_course {
# Enable tab completion
source ~/.dotfiles/plugins/git/contrib/completion/git-completion.bash

# colors!
yellow="\[\033[0;33m\]"
cyan="\[\033[0;36m\]"
purple="\[\033[0;35m\]"
reset="\[\033[0m\]"

# Change command prompt
source ~/.dotfiles/plugins/git/contrib/completion/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1
# '\u' adds the name of the current user to the prompt
# '\$(__git_ps1)' adds git-related stuff
# '\W' adds the name of the current directory
export PS1="$purple\u$yellow\$(__git_ps1)$cyan \W$reset $ "
# }

#---------------------------------------------------------------------------
# ALIASES AND FUNCTIONS
#---------------------------------------------------------------------------
alias ls='ls --color=auto'
alias cp='cp -i --reflink=always'   # confirm before overwriting something
alias mv='mv -i'
alias df='df -h'                    # human-readable sizes
alias python='python3'

# do not try connecting to the X server
# reduce Vim startup time in tmux
alias vim='vim -X'

# ex - archive extractor
# usage: ex <file>
ex() {
    if [ -f "$1" ] ; then
        case $1 in
            *.tar.bz2)  tar xjf "$1" ;;
            *.tar.gz)   tar xzf "$1" ;;
            *.bz2)      bunzip2 "$1" ;;
            *.rar)      unrar x "$1" ;;
            *.gz)       gunzip "$1" ;;
            *.tar)      tar xf "$1" ;;
            *.tbz2)     tar xjf "$1" ;;
            *.tgz)      tar xzf "$1" ;;
            *.zip)      unzip "$1" ;;
            *.Z)        uncompress "$1" ;;
            *.7z)       7z x "$1" ;;
            *)          echo "'$1' cannot be extracted via ex()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# path_prepend - prepend new path to $PATH
# usage: path_prepend <new_path_to_add>
# https://unix.stackexchange.com/questions/124444/how-can-i-cleanly-add-to-path
path_prepend() {
    case "${PATH:=$1}" in
        *:"$1":*)   ;;
        *)          PATH="$1:$PATH" ;;
    esac;
}

# swap - swap the names of two files
# usage: swap <file1> <file2>
swap() {
    local TMPFILE
    TMPFILE=$(mktemp)
    mv "$1" "$TMPFILE" && mv "$2" "$1" && mv "$TMPFILE" "$2"
}

#---------------------------------------------------------------------------
# PLUGIN SETTINGS
#---------------------------------------------------------------------------

# ------- tmuxifier
path_prepend "$HOME/.dotfiles/plugins/tmuxifier/bin"
eval "$(tmuxifier init -)"

# ------- fzf
# enable fzf keybindings
source /usr/share/doc/fzf/examples/key-bindings.bash
# enable fuzzy auto-completion
source /usr/share/doc/fzf/examples/completion.bash

# ------- fasd
path_prepend "$HOME/.dotfiles/plugins/fasd"
eval "$(fasd --init auto)"
alias v='f -e vim'          # quick opening files with vim
alias j='fasd_cd -d'
alias jj='fasd_cd -d -i'

#---------------------------------------------------------------------------
# CUSTOM SETTINGS
#---------------------------------------------------------------------------
complete -cf sudo

export LS_COLORS="di=36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"

path_prepend "$HOME/.local/bin"

# Start tmux on every shell login
if command -v tmux >/dev/null 2>&1 && [ "${DISPLAY}" ]; then
    # if not inside a tmux session, and if no session is started, start a new session
    [ -z "${TMUX}" ] && (tmux attach >/dev/null 2>&1 || tmux)
fi
