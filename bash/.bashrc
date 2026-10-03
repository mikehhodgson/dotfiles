# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
# /etc/omarchy.conf is written by omarchy-dev-link. When absent, force the
# package default instead of preserving a stale inherited dev-link value before
# we decide which rc file to source.
if [[ -f /etc/omarchy.conf ]]; then
  source /etc/omarchy.conf
  export OMARCHY_PATH="${OMARCHY_PATH:-/usr/share/omarchy}"
else
  export OMARCHY_PATH=/usr/share/omarchy
fi
source "$OMARCHY_PATH/default/bash/rc"

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

#export PATH="$PATH:$HOME/.local/bin"


# https://superuser.com/questions/7414/how-can-i-search-the-bash-history-and-rerun-a-command
# $ !cl
# $ !?some

# If the histverify shell option is enabled, and Readline is being
# used, history substitutions are not immediately passed to the shell
# parser. Instead, the expanded line is reloaded into the Readline
# editing buffer for further modification.
shopt -s histverify

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

alias rsnapshot='rsnapshot -c ~/.config/rsnapshot/rsnapshot.conf'
alias backup='rsnapshot -V backup'

alias src='cd ~/src'
alias cx='codex'
alias cxr='codex resume'

