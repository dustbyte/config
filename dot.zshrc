#!/bin/zsh

#
# init
#

setopt -o emacs
setopt prompt_subst

autoload colors zsh/terminfo
colors

zstyle ':completion:*::::' completer _expand _complete _ignored _approximate
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'

zstyle ':completion:*:expand:*' tag-order all-expansions

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path  "${HOME}/.zsh/cache"
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' file-sort name
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %S--more--
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z} m:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*' ''
zstyle ':completion:*' menu select=1
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
zstyle ':completion:*:processes' command 'ps -o pid,s,nice,stime,args'
zstyle '*' hosts $HOSTS
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' '*?.old' '*?.pro'
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle :compinstall filename "${HOME}/.zshrc"
autoload -Uz compinit
compinit -u

HISTFILE=~/.histfile
HISTSIZE=100
SAVEHIST=100
REPORTTIME=2 # show time when executions lasts longer than X seconds

OSNAME=`uname -s`

ulimit -c 0

#
# Colors
#

c_reset="%{$reset_color%}"
c_good="%{$fg[green]%}"
c_dirty="%{$fg[yellow]%}"
c_bad="%{$fg[red]%}"
c_blue="%{$fg[blue]%}"

#
# functions
#

check_command()
{
    COMMAND=$1
    which $1 >& /dev/null
}

git_prompt()
{
    if check_command git
    then
        branch=`git symbolic-ref HEAD 2>/dev/null | sed 's/refs\/heads\///g'`
        if [ "$branch" != "" ]
        then
            sts=$(git status -s)
            if [ "$sts" = "" ]
            then
                color="$c_good"
            elif `echo "$sts" | grep -v '??' >& /dev/null`
            then
                color="$c_bad"
            else
                color="$c_dirty"
            fi

            ahead=$(git log --branches="*$branch" --oneline --not --remotes 2>/dev/null | wc -l | cut -d ' ' -f 8)

            print_ahead=""
            if [ "${ahead}" -gt 0 ]
            then
                print_ahead="(${ahead})"
            fi

            echo -n " [${color}${branch}${c_reset}${print_ahead}]"
        fi
    fi
}

aws_profile_prompt()
{
    if [ -n "${AWS_PROFILE}" ]
    then
        echo "(${c_blue}${AWS_PROFILE}${c_reset}) "
    fi
}

prompt()
{
    if [ `whoami` = 'root'  ]
    then
        P_USER="$c_bad"
    else
        P_USER="$c_good"
    fi

    if [ -n "$SSH_CLIENT" ]
    then
        HOST_INFO="@${c_blue}%m${c_reset}"
    fi

    PROMPT='$(aws_profile_prompt)(%j|%B%?%b)${P_USER}%n$c_reset${HOST_INFO}:%(5~|%-1~/…/%3~|%4~)$(git_prompt)> '
    RPROMPT=''
}

pkg_search()
{
    echo "ls $1*" | ftp -ap "$PACKAGE_PATH/"
}

freebsd()
{
    if [ "$OSNAME" = "FreeBSD" ]
    then
        alias ls='ls -G'
    fi
}

openbsd()
{

    if [ "$OSNAME" = "OpenBSD" ]
    then
        if check_command colorls
        then
            alias ls='colorls -G'
        else
            alias ls='ls'
        fi

        if check_command ggrep
        then
            export GREP_COMMAND='ggrep'
            export SPOT_ARGS='--color=auto'
            alias grep="${GREP_COMMAND} --color=auto"
        else
            unalias grep
            export SPOT_ARGS=""
        fi
    fi
}

darwin()
{
    if [ "$OSNAME" = "Darwin" ]
    then
        export LC_CTYPE=en_US.UTF-8
        export LC_ALL=en_US.UTF-8
        alias ls='ls -CFG'
        alias clear_cache='sudo rm /var/log/asl/*.asl'
        check_command mvim && alias vim='mvim -v'

        export PATH=/usr/local/bin:/opt/local/bin:/opt/local/sbin:$PATH:/usr/local/git/bin:/usr/local/sbin
        export MANPATH=/opt/local/share/man:$MANPATH
        export DISPLAY=:0.0
    fi
}

venv_py()
{
    if check_command virtualenvwrapper.sh
    then
        export WORKON_HOME="$HOME/.envs"
        source `which virtualenvwrapper.sh`
    fi
}

go_setup()
{
    if [ -e /usr/local/go ]
    then
        export PATH=${PATH}:/usr/local/go/bin
        export GOPATH=$(go env GOPATH)
        export GOBIN=${GOPATH}/bin
        export PATH=${PATH}:${GOBIN}
    fi
}

spot()
{
    pattern=""
    opts="-nRE"
    spath="."
    while [  "$#" != "0" ]
    do
        case "$1" in
            "-i")
            opts=$opts"i"
            ;;
            "-d")
            if [ $spath = '.' ]
            then
                spath="$2"
            else
                spath=$spath "$2"
            fi
            shift
            ;;
            *)
            if [ "$pattern" = "" ]
            then
                pattern="$1"
            else
                pattern="$pattern $1"
            fi
        esac
        shift
    done

    ${GREP_COMMAND:=grep} "${SPOT_ARGS}" "$opts" "$pattern" $spath
}

#
# Vars
#

export PATH=~/bin:~/.cask/bin:$PATH:/sbin:/usr/bin:/usr/sbin:/usr/local/bin
export PAGER='less -isr'
export LESS=-RX
export MANPAGER='/usr/bin/less -isr'
export EDITOR=vim
export SVN_EDITOR=$EDITOR
export VISUAL=$EDITOR
export MANPATH=/usr/man:/usr/X11R6/man:/usr/share/man:/usr/local/share/man:/usr/local/man
export VIMHOME=$HOME/.vim
export SPOT_ARGS="--color=auto"

#
# ls colors
#

export LSCOLORS='cxfxcxdxbxegedabagacad'
export LS_COLORS='di=0;32:fi=0:ln=35:pi=5:so=30;43:bd=30;43:cd=30;43:or=35;43:mi=0:ex=31:*.rpm=90'

#
# less colors
#

export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
export GROFF_NO_SGR=1

#
# aliases
#

alias df='df -h'
alias ls='ls -vCF --color=auto'
alias l='ls -lh'
alias ll=l
alias la='ls -lA'
alias grep='grep --color=auto'
alias sx='startx'
alias stx='startx&;disown;exit'
alias ne="emacs -nw"
alias es='emacs_server'
alias ec='emacs_client -nw'
alias eg='emacs_client&disown'
alias rld='source $HOME/.zshrc'
alias cpyc='find . -name "*.pyc" -print -exec rm -rf {} \;'
alias vimpager='vim -R -'
alias miamstylo=spot
alias qui="~/bin/qui.py"
alias school='ssh wacren_p@ssh.epitech.net'
alias bpython='bpython -q'
alias ri="echo card"

check_command gvim && alias vim='gvim -v'

#
# Set config
#

bindkey "\e[3~" delete-char
bindkey ";5C" forward-word
bindkey ";5D" backward-word
bindkey "^[Od" backward-word
bindkey "^[Oc" forward-word

#
# Start
#

openbsd
freebsd
darwin
prompt
venv_py
go_setup

if [ -f $HOME/.zshrc_local ]; then
    . $HOME/.zshrc_local
fi

if [ -f $HOME/.zprofile ]; then
    . $HOME/.zprofile
fi
