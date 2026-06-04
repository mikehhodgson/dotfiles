# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

#export PATH="$PATH:$HOME/.local/bin"

export TRY_PATH=~/src/experiments
eval "$(/usr/bin/try init $TRY_PATH)"

export MANWIDTH=80 # man pages column width

export FZF_DEFAULT_COMMAND="fd --hidden --follow --exclude '.{cache,DS_Store,gem,git,npm,parallel,Trash,vscode-oss}' --exclude '{node_modules}/'"

alias gk='gitk --all'
alias yeet='rm'
alias w='curl wttr.in'
alias diskstat='udisksctl status'
alias diskpower='udisksctl power-off -b' # e.g. diskpower /dev/sda
alias diff='diff --color'
alias dlphotos='download-photos'
