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

#
# functions
#

check_command()
{
    COMMAND=$1
    which $1 >& /dev/null
}

vman()
{
    man $1 | col -b | vim -c "set ft=man" -R -
}

tmpwrite()
{
  chmod u+w "$1"
  vim "$1"
  chmod u-w "$1"
}

magit()
{
    dir='.'
    [ $# -gt 0 ] && dir="$1"
    emacs -nw --eval "(magit-status-solo \"$dir\")"
}

git_prompt()
{
    if check_command git
    then
        branch=`git symbolic-ref HEAD 2>/dev/null | sed 's/refs\/heads\///g'`
        if [ "$branch" != "" ]
        then
            sts=`git status -s`
            if [ "$sts" = "" ]
            then
                color="$c_good"
            elif `echo "$sts" | grep -v '??' >& /dev/null`
            then
                color="$c_bad"
            else
                color="$c_dirty"
            fi

            ahead=`git log --branches="*$branch" --oneline --not --remotes 2>/dev/null | wc -l | cut -d ' ' -f 8`

            echo -n "$color"
            echo -n "$branch"
            echo -n "$c_reset"
            [ "$ahead" -ne 0 ] && echo -n " ($ahead)"
            echo -n "|"
        fi
    fi
}

svn_prompt()
{
    if $(check_command svn && svn info >& /dev/null)
    then
        st=`svn status`
        if `echo "$st" | grep -v '?' >& /dev/null`
        then
            echo -n "$c_bad"
        elif [ "$st" != "" ]
        then
            echo -n "$c_dirty"
        else
            echo -n "$c_good"
        fi
        echo -n svn
        echo -n "$c_reset|"
    fi
}

scm_prompt()
{
    git_prompt
    svn_prompt
}

prompt()
{
    if [ `whoami` = 'root'  ]
    then
        P_USER="$c_bad"
    else
        P_USER="$c_good"
    fi

    PROMPT='(%j|%B%?%b)${P_USER}%n$c_reset@%m> '
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
        FTP_SITE="ftp://ftp.nluug.nl"
        export PKG_PATH="$FTP_SITE/pub/OpenBSD/`uname -r`/packages/`uname -m`/"
        export PACKAGE_PATH=$PKG_PATH

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

netbsd()
{

    if [ "$OSNAME" = "NetBSD" ]
    then
        FTP_SITE="ftp://ftp.fr.netbsd.org"
        export PKG_PATH="$FTP_SITE/pub/pkgsrc/packages/NetBSD/`uname -m`/6.0/All"
        export PACKAGE_PATH=$PKG_PATH

        if check_command gls
        then
            alias ls='gls --color=auto'
        else
            alias ls='ls'
        fi

        if check_command ggrep
        then
            alias grep='ggrep --color=auto'
        else
            unalias grep
            SPOT_ARGS=""
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
        [ -e "/Applications/Sublime Text 2.app" ] && alias sublime_text='open -a "/Applications/Sublime Text 2.app"'

        #Macports
        export PATH=/usr/local/bin:/opt/local/bin:/opt/local/sbin:$PATH:/Library/Frameworks/Python.framework/Versions/3.2/bin:/usr/local/git/bin:/usr/local/sbin
        export MANPATH=/opt/local/share/man:$MANPATH
        export DISPLAY=:0.0


        # Fixes fore Postgres.app
        export PATH="$HOME/bin:/Applications/Postgres.app/Contents/MacOS/bin:$PATH"

        _psql()
        {
            SAVE=$DYLD_FALLBACK_LIBRARY_PATH
            unset DYLD_FALLBACK_LIBRARY_PATH
            psql "$*"
            export DYLD_FALLBACK_LIBRARY_PATH=$SAVE
        }
        alias psql=_psql
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
    local GOROOT_DIRECTORY=${HOME}/bin/go

    if [ -d ${GOROOT_DIRECTORY} ]
    then
        export GOROOT=${GOROOT_DIRECTORY}
        export PATH=${PATH}:${GOROOT}/bin
    fi

    local GOPATH_DIRECTORY="${HOME}/work/go"

    if [ -d ${GOPATH_DIRECTORY}  ]
    then
        export GOPATH="$GOPATH_DIRECTORY"
        export PATH=${PATH}:${GOPATH}/bin
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

ssh_agent_start()
{
    local pid=$(pgrep ssh-agent)
    local ssh_agent_file=${HOME}/.ssh_agent.sh

    if [ "$pid" = "" ]
    then
        [ -f "${ssh_agent_file}" ] && rm -f "${ssh_agent_file}"
        ssh-agent -s | grep -v echo > "${ssh_agent_file}"
    fi

    [ -f "${ssh_agent_file}" ] && source "${ssh_agent_file}"
    ssh-add 2> /dev/null
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
alias vman=vman
alias tmpwrite=tmpwrite
alias vimpager='vim -R -'
alias miamstylo=spot
alias qui="~/bin/qui.py"
alias school='ssh wacren_p@ssh.epitech.net'
alias bpython='bpython -q'
alias ri="echo card"

check_command gvim && alias vim='gvim -v'

#
# docker
#

docker_rmi_repository() {
    [ -z $1 ] && echo "Please provide a repository name" && exit 1
    docker rmi -f $(docker images | awk "/$1/ {print \$3}")
}

alias dkillall='docker kill $(docker ps -qa)'
alias drmall='docker rm -f $(docker ps -qa)'
alias dflush='docker rm -f $(docker ps -a | awk "/Exited/ {print \$1}") 2>/dev/null'
alias dflushi='docker rmi -f $(docker images | awk "/<none>/ {print \$3}") 2>/dev/null'
alias dclean='echo "removed containers:" && dflush ; echo "\nremoved images:" && dflushi'
alias cddocker='cd ${HOME}/work/go/src/github.com/docker/'
alias drmi=docker_rmi_repository

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
netbsd
freebsd
darwin
prompt
venv_py
go_setup

LP_MARK_DEFAULT="$"
LP_ENABLE_BATT=0
LP_ENABLE_LOAD=0
LP_ENABLE_TEMP=0
[[ $- = *i*  ]] && . ${HOME}/.zsh/liquidprompt/liquidprompt

if [ -f $HOME/.zshrc_local ]; then
    . $HOME/.zshrc_local
fi
