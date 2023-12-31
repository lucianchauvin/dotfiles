#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
alias ls='ls --color=auto -lh'
alias lsa='ls --color=auto -lh -a'
alias grep='grep --color=auto'
alias gbr='g++ -std=c++20 -Wall -Wextra -Wno-error=pedantic -Weffc++ -fsanitize=address,undefined *.cpp; ./a.out'
alias cls='clear'
alias wifi='iwctl'

RED="\[\e[91m\]"
ENDCOLOR="\[\e[0m\]"
export PS1="${RED}[\u@\h \W]\$${ENDCOLOR} "

bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

#Startx Automatically
if [[ -z "$DISPLAY" ]] && [[ $(tty) = /dev/tty1 ]]; then
    startx
fi
alias blth='sudo systemctl start bluetooth'
alias copy='xclip -selection clipboard'
alias n='nvim'
alias google='google-chrome-stable'
alias g='google-chrome-stable'
alias tests='make -C tests clean && make -C tests -j12 run-all -k'
alias .='alacritty --working-directory=$(pwd) & disown'

[[ -s /etc/profile.d/autojump.sh ]] && source /etc/profile.d/autojump.sh

mkcdir ()
{
    mkdir -p -- "$1" &&
       cd -P -- "$1"
}

duls () {
    paste <( du -hs -- "$@" | cut -f1 ) <( ls -ldf -- "$@" )
}
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
