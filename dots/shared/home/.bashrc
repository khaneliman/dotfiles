#! /usr/bin/env bash
# Enable the subsequent settings only in interactive sessions
case $- in
*i*) ;;
*) return ;;
esac

# Path to your oh-my-bash installation.
export OSH="$HOME"/.oh-my-bash

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-bash is loaded.
OSH_THEME="powerlevel10k"

# To disable the uses of "sudo" by oh-my-bash, please set "false" to
# this variable.  The default behavior for the empty value is "true".
OMB_USE_SUDO=true

# To enable/disable display of Python virtualenv and condaenv
OMB_PROMPT_SHOW_PYTHON_VENV=true # enable

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

source "$HOME"/.aliases

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
[[ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]] && . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"

export PATH="$PATH:/opt/local/bin:/opt/local/sbin:$HOME/.local/share/pnpm:~/.spicetify"
PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"
export VISUAL="nvim"
export EDITOR="$VISUAL"
export MICRO_TRUECOLOR=1

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

fastfetch
