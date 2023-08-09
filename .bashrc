#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
export PATH=$PATH:/usr/local/texlive/2023/bin/x86_64-linux
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias gbr='g++ -std=c++17 -Wall -Wextra -Wno-error=pedantic -Weffc++ -fsanitize=address,undefined *.cpp'
alias cls='clear'
alias wifi='iwctl'

RED="\[\e[91m\]"
ENDCOLOR="\[\e[0m\]"
export PS1="${RED}[\u@\h \W]\$${ENDCOLOR} "


#Startx Automatically
if [[ -z "$DISPLAY" ]] && [[ $(tty) = /dev/tty1 ]]; then
    startx
fi
alias config='/usr/bin/git --git-dir=/home/qualia/.cfg/ --work-tree=/home/qualia'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias config='/usr/bin/git --git-dir=/home/qualia/.cfg/ --work-tree=/home/qualia'
