#! /usr/bin/env bash

# Enable the subsequent settings only in interactive sessions
case $- in
*i*) ;;
*) return ;;
esac

# Source environment config
if [ -f "$HOME"/.bashenv ]; then
	. "$HOME"/.bashenv
fi

# Source aliases
if [ -f "$HOME"/.aliases ]; then
	source "$HOME"/.aliases
fi

# Source functions
if [ -f "$HOME"/.functions ]; then
	source "$HOME"/.functions
fi

# choose preferred prompt, oh-my-bash or oh-my-posh
if [ "$(command -v oh-my-posh)" ]; then
	eval "$(oh-my-posh --init --shell bash --config "$HOME/.config/ohmyposh/ohmyposhv3-v2.json")"
else
	[[ ! -f "$OSH"/oh-my-bash.sh ]] || source "$OSH"/oh-my-bash.sh
fi

if [ -f ~/.config/op/plugins.sh ]; then
	source "$HOME"/.config/op/plugins.sh
fi

if [ -f /usr/local/etc/bash_completion ]; then
	. /usr/local/etc/bash_completion
fi

if [[ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]]; then
	. "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
fi

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# Which completions would you like to load? (completions can be found in ~/.oh-my-bash/completions/*)
# Custom completions may be added to ~/.oh-my-bash/custom/completions/
# Example format: completions=(ssh git bundler gem pip pip3)
# Add wisely, as too many completions slow down shell startup.
completions=(
	defaults
	brew
	dirs
	docker
	docker-compose
	gh
	git
	git_flow
	composer
	ssh
)

# Which aliases would you like to load? (aliases can be found in ~/.oh-my-bash/aliases/*)
# Custom aliases may be added to ~/.oh-my-bash/custom/aliases/
# Example format: aliases=(vagrant composer git-avh)
# Add wisely, as too many aliases slow down shell startup.
aliases=(
	general
)

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-bash/plugins/*)
# Custom plugins may be added to ~/.oh-my-bash/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	fasd
	git
	bashmarks

	brew
	npm
	nvm
)

fastfetch
