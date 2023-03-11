#! /usr/bin/env bash

# Enable the subsequent settings only in interactive sessions
case $- in
*i*) ;;
*) return ;;
esac

[ -f "$HOME"/.bashenv ] && . "$HOME"/.bashenv
source "$HOME"/.aliases

# choose preferred prompt, oh-my-bash or oh-my-posh
if [ "$(command -v oh-my-posh)" ]; then
	eval "$(oh-my-posh --init --shell bash --config "$HOME/.config/ohmyposh/ohmyposhv3-v2.json")"
else
	[[ ! -f "$OSH"/oh-my-bash.sh ]] || source "$OSH"/oh-my-bash.sh
fi

eval "$("/opt/homebrew/bin/brew" shellenv)"

if [ -f ~/.config/op/plugins.sh ]; then
	source "$HOME"/.config/op/plugins.sh
fi

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
[[ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]] && . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

fastfetch
