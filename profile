# http://misc.flogisoft.com/bash/tip_colors_and_formatting
# http://superuser.com/questions/223132/how-do-i-fix-my-colour-bash-prompt-wrapping

export PS1="\[\e[1m\e[38;5;32m\]\u@\h \[\e[38;5;250m\]\w \[\e[38;5;7m\]$ \[\e[0m\]"
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export GREP_OPTIONS="--color"

export HISTCONTROL=erasedups
export HISTSIZE=10000
shopt -s histappend
export HISTIGNORE="ls:exit:pwd:clear"

alias ls="ls -G"
