alias rmf='shred -uzn 4'
alias rmd='wipe -rfqQ 8'
alias ls='ls -1l --color'
alias _date='date +"%d/%m/%Y - %H:%M:%S"'
alias gitm='cd ~/git/myenv'
alias gitw='cd ~/git/work'
alias tos='cd ~/main/.trash && ls -a'
alias tod='cd ~/main/other/notes && vim todo/head'

export LANG=en_US.UTF8
export EDITOR='/usr/bin/vim'
export EMAIL=mgrainmi@gmail.com

_to_stderr()
{
    >&2 echo "stderr: $1"
}

# break reminder
c-tm()
{
    if command -v at >/dev/null; then
        if [ ! -z $1 ]; then
            echo "aplay ~/.local/share/prompt.wav" | \
            at now + "$1" minute
        else
            _to_stderr "usage: $ c-tm <minutes>"
        fi
    else
        _to_stderr "command 'at' not found"
    fi
}

# delete all jobs
c-tmr()
{
    if command -v at >/dev/null; then
        atq | awk '{print $1}' | xargs atrm
    else
        _to_stderr "command 'at' not found"
    fi
}

# clear primary / clipboard selection
c-cc()
{
    if command -v xsel >/dev/null; then
        xsel -p -c
        xsel -b -c
    else
        _to_stderr "command 'xsel' not found"
    fi
}

_generate_random_string() {
    cat /dev/urandom | tr -dc 'a-z0-9' | head -c 12
}

# get random symbols to clipboard
# use it for the filename or something else
c-rnd-0()
{
    if command -v xsel >/dev/null; then
        _generate_random_string | xsel -b -i
    else
        _to_stderr "command 'xsel' not found"
    fi
}

# get random symbols to stdout
# use it for a hard password
c-rnd-1()
{
    cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 28 && echo
}

# renames all files to random names in current directory
# need to specify the file format ("txt", "jpg", etc.)
c-rename()
{
    if [ ! -z $1 ]; then
        for file in *.$1; do
            s=$(_generate_random_string)

            while [ -e "${s}.$1" ]; do
                s=$(_generate_random_string)
            done

            mv "$file" "${s}.$1"
        done
    else
        _to_stderr "usage: $ c-rename '<file-format>'"
    fi
}

# remove rc (removed but not purged) packages
# plus debs autoremove and autoclean
c-deb-clean()
{
    rc_packs=$(dpkg -l | grep '^rc' | awk '{print $2}')
    for p in ${rc_packs[*]}; do sudo apt-get purge -y $p; done
    sudo apt-get autoremove -y
    sudo apt-get autoclean
}

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

echo "don't forget to turn on 'c-tm' save your eyes (break reminder)"

[ -z $TMUX ] && tmux
