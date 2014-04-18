export PS1="\[$(tput bold)$(tput setaf 32)\]\u@\h \[$(tput setaf 250)\w \[$(tput sgr0)\]$ "
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export GREP_OPTIONS="--color"

export HISTCONTROL=erasedups
export HISTSIZE=10000
shopt -s histappend

alias ls="ls -G"
