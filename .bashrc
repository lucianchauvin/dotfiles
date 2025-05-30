# if not running interactively, don't do anything
[[ $- != *i* ]] && return
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [[ ! "$DISPLAY" == "" ]] && [ -z "$TMUX" ]; then
    exec tmux
fi

cd() {
  if builtin cd "$@"; then
    export gr=$(git rev-parse --show-toplevel 2>/dev/null || echo "")
  fi
}

alias ls='ls --color=auto -lhtr --group-directories-first'
alias lsa='ls --color=auto -lh -a --group-directories-first'
alias grep='grep --color=auto'
alias gbr='g++ -g -Wall -Wextra -Wno-error=pedantic -Weffc++ -fsanitize=address,undefined *.cpp; ./a.out'
alias grr='g++ -Wall -Wextra -Wno-error=pedantic -Weffc++ -fsanitize=address,undefined -O9 *.cpp; ./a.out'
alias gcr='gcc -g -Wall -Wextra -Wno-error=pedantic -fsanitize=address,undefined *.c; ./a.out'
alias javacfx="javac --module-path $PATH_TO_FX --add-modules javafx.controls"
alias javafx="java --module-path $PATH_TO_FX --add-modules javafx.controls"
alias cls='clear'
alias wifi='iwctl'
alias blth='sudo systemctl start bluetooth'
alias copy='xclip -selection clipboard'
alias vim="nvim"
alias n='nvim'
alias tests='make -C tests clean && make -C tests -j12 run-all -k'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias dutop='ncdu'
alias z='zathura' 
alias nethack='ssh nethack@alt.org'
alias cdg='cd $gr'

function parse_git_branch() {
    BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
    if [ ! "${BRANCH}" == "" ]
    then
        STAT=`parse_git_dirty`
        echo "(${BRANCH}${STAT})"
    else
        echo ""
    fi
}

# get current status of git repo
function parse_git_dirty {
    status=`git status 2>&1 | tee`
    dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
    untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
    ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
    newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
    renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
    deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
    bits=''
    if [ "${renamed}" == "0" ]; then
        bits=">${bits}"
    fi
    if [ "${ahead}" == "0" ]; then
        bits="*${bits}"
    fi
    if [ "${newfile}" == "0" ]; then
        bits="+${bits}"
    fi
    if [ "${untracked}" == "0" ]; then
        bits="?${bits}"
    fi
    if [ "${deleted}" == "0" ]; then
        bits="x${bits}"
    fi
    if [ "${dirty}" == "0" ]; then
        bits="!${bits}"
    fi
    if [ ! "${bits}" == "" ]; then
        echo " ${bits}"
    else
        echo ""
    fi
}

RED="\[\e[91m\]"
YELLOW="\[\e[33m\]"
GREEN="\[\e[32m\]"
ENDCOLOR="\[\e[0m\]"

if [ -n "$SSH_CONNECTION" ]; then
	export PS1="${YELLOW}[\u@\h \W]${GREEN}\`parse_git_branch\`${YELLOW}\$${ENDCOLOR} "
else
	export PS1="${RED}[\u@\h \W]${GREEN}\`parse_git_branch\`${RED}\$${ENDCOLOR} "
fi

export EDITOR="nvim"
export GPG_TTY=$(tty)

export MANPAGER="less -R --use-color -Dd+r -Du+b"
export MANROFFOPT="-P -c"

set -o vi
#bind -m vi-command 'Control-l: clear-screen'
#bind -m vi-insert 'Control-l: clear-screen'

HISTSIZE=
HISTFILESIZE=
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

#Startx automatically in tty1
if [[ -z "$DISPLAY" ]] && [[ $(tty) = /dev/tty1 ]]; then
    startx
fi

#Autojump stuff
[[ -s /etc/profile.d/autojump.sh ]] && source /etc/profile.d/autojump.sh

mkcdir () {
    mkdir -p -- "$1" && cd -P -- "$1"
}

duls () {
    paste <( du -hs -- "$@" | cut -f1 ) <( ls -ldf -- "$@" )
}

# Created by `pipx` on 2024-02-08 04:44:56
export PATH="$PATH:/home/lucian/.local/bin:/opt/scorep/bin"
export PATH_TO_FX="/usr/lib/jvm/java-22-openjfx/lib"

export GDK_SCALE=2
export GDK_DPI_SCALE=0.5

lazy_load_nvm() {
    unset -f npm node nvm
    export NVM_DIR=~/.nvm
    [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
}

npm() {
    lazy_load_nvm
    npm $@
}

node() {
    lazy_load_nvm
    node $@
}

nvm() {
    lazy_load_nvm
    nvm $@
}

#SCC
export PATH=$PATH:/home/lucian/downloads/code_saturne-8.3.1.build/arch/Linux/bin/

#PYENV
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"
