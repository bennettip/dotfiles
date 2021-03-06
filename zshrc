#
# ~/.zshrc
#

# ~/.zshrc {
# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
# }

# ~/.bashrc {
# Change the window title of X terminals
precmd () {print -Pn "\e]0;%n@%m:%~\a"}
# }

# rc/zshrc {
# HISTORY
# number of lines kept in history
export HISTSIZE=10000
# number of lines saved in the history after logout
export SAVEHIST=10000
# location of history
export HISTFILE=~/.zhistory
# append command to history file once executed
setopt APPEND_HISTORY
# remove copies of lines in the history list and keep the newly added one
setopt HIST_IGNORE_ALL_DUPS
# }

# bash_profile_course {
# Change command prompt
source ~/.dotfiles/plugins/git/contrib/completion/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1
# '%n' adds the name of the current user to the prompt
# '$(__git_ps1 " (%s)")' adds git-related stuff
# '%1~' adds the name of the current directory
setopt PROMPT_SUBST
PS1='%F{magenta}%n%F{yellow}$(__git_ps1 " (%s)") %F{cyan}%1~ %f%# '
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
source /usr/share/doc/fzf/examples/key-bindings.zsh
# enable fuzzy auto-completion
source /usr/share/doc/fzf/examples/completion.zsh

# ------- command-not-found
. /etc/zsh_command_not_found

# ------- zsh-autosuggestions
source ~/.dotfiles/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# ------- fasd
path_prepend "$HOME/.dotfiles/plugins/fasd"
eval "$(fasd --init auto)"
alias v='f -e vim'          # quick opening files with vim
alias j='fasd_cd -d'
alias jj='fasd_cd -d -i'

#---------------------------------------------------------------------------
# CUSTOM SETTINGS
#---------------------------------------------------------------------------

# vi key binding
bindkey '^R' history-incremental-search-backward
export EDITOR=vim
bindkey -v

# change cursor shape in different modes
function zle-keymap-select zle-line-init zle-line-finish {
    case $KEYMAP in
        vicmd)
            print -n '\e[1 q' # block cursor
            ;;
        viins|main)
            print -n '\e[5 q' # line cursor
            ;;
    esac
}
zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select

# reduce wait time after Esc
KEYTIMEOUT=1

export LS_COLORS="di=36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"

path_prepend "$HOME/.local/bin"

# Start tmux on every shell login
if command -v tmux >/dev/null 2>&1 && [ "${DISPLAY}" ]; then
    # if not inside a tmux session, and if no session is started, start a new session
    [ -z "${TMUX}" ] && (tmux attach >/dev/null 2>&1 || tmux)
fi
