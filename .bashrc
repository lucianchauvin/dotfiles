#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
export PATH=$PATH:/usr/local/texlive/2023/bin/x86_64-linux:/home/qualia/.local/bin
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
alias config='/usr/bin/git --git-dir=/home/qualia/.cfg/ --work-tree=/home/qualia'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias config='/usr/bin/git --git-dir=/home/qualia/.cfg/ --work-tree=/home/qualia'
alias blth='sudo systemctl start bluetooth'
alias copy='xclip -selection clipboard'
alias n='nvim'
[[ -s /etc/profile.d/autojump.sh ]] && source /etc/profile.d/autojump.sh
