# aliases
alias rmf='shred -uzn 4'
alias rmd='wipe -rfqQ -s 8'
alias daterc='date -R | xsel -b -i' # input date (RFC 5322) to clipboard (for changelog)
alias _date='date +"%d/%m/%Y - %H:%M:%S"' # simple format
alias ls='ls -1l --group-directories-first -hN --color'
alias la='ls -A --color'
alias d='cd ~/Downloads'
alias gm='cd ~/git/myenv'
alias gw='cd ~/git/work'
alias mn='cd ~/git/myenv/notes && vim -c NERDTree'
alias mm='cd ~/main && vim -c NERDTree'
alias m='cd ~/main'
alias v='vim'
alias a='sudo aptitude'
alias n='neomutt'
alias nb='newsboat'
alias tos='cd ~/main/.trash && ls -a'
alias tod='cd ~/main/my && vim todo/head'
alias rb='sudo reboot'
alias sdn='sudo shutdown -h now'
alias cc='xsel -p -c; xsel -b -c' # clear primary/clipboard selections
alias grep='grep --color'
alias diff='diff --color'
alias rm='rm -v'
alias cp='cp -vi'
alias mv='mv -vi'
alias mkdir='mkdir -v'

# exports
export LANG=en_US.UTF8
export EDITOR='/usr/bin/vim'
export BROWSER='/usr/bin/firefox'
export TERMINAL='/usr/bin/xfce4-terminal'
export DEBEMAIL=krekhov.dev@mail.ru
export DEBFULLNAME="Kirill Rekhov"

# function for my .vimrc trick (vnoremap)
# (vim -> visual mode -> ctrl + c -> ~/vbuf)
# ~/vbuf file has saved lines from the clipboard
vbuf()
{
    [ -s ~/vbuf ] && vim ~/vbuf || echo $?
}

# touch file with verbose mode =)
vtouch()
{
    for i do
        touch "$i"
        [ $? == 0 ] && echo "touched: '$i'"
    done
} && alias touch='vtouch'

# .bash_history
HISTSIZE=8000
HISTFILESIZE=$HISTSIZE
HISTCONTROL=ignoreboth

_bash_history_sync()
{
    builtin history -a
    HISTFILESIZE=$HISTSIZE
    builtin history -c
    builtin history -r
}

history()
{
    _bash_history_sync
    builtin history "$@"
}

PROMPT_COMMAND=_bash_history_sync

# color man pages
man()
{
    LESS_TERMCAP_mb=$'\e[0;91m'
    LESS_TERMCAP_md=$'\e[0;91m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[07m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[0;4;32m' \
    command man "$@"
}

# prompt variable
# good ideas: https://github.com/ohmyzsh/ohmyzsh/wiki/Themes#afowler
PS1='\[\e[0;33m\]\A|\[\e[0;32m\]\h:\[\e[0;36m\]\w \[\033[0;34m\]\u\[\e[0m\] \$ '

# set 077 umask for the user
# files -> 600 (rw-------)
# directories -> 700 (rwx------)
# for all users need change /etc/profile
# https://wintelguy.com/umask-calc.pl
(( $(umask) != 077 )) && umask 077

# start the terminal multiplexer
if command -v tmux >/dev/null; then
    [ -z "$TMUX" ] && tmux
fi
