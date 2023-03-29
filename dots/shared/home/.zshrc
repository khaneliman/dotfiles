#! /usr/bin/env zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Source environment
if [ -f "$HOME"/.zshenv ]; then
	source "$HOME"/.zshenv
fi

# Source aliases
if [ -f "$HOME"/.aliases ]; then
  source ~/.aliases
fi

# Source functions
if [ -f "$HOME"/.functions ]; then
	source "$HOME"/.functions
fi

##
#
# Znap plugin management
#
##
# Source zsh plugi# Download Znap, if it's not there yet.
[[ -f ~/.config/zsnap/zsh-snap/znap.zsh ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git ~/.config/zsnap/zsh-snap

# Start znap
source ~/.config/zsnap/zsh-snap/znap.zsh

# `znap source` automatically downloads and starts your plugins.
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-syntax-highlighting

# oh my zsh plugins
plugins=(
git zsh-autosuggestions zsh-syntax-highlighting sudo
web-search history macos zsh-navigation-tools zsh-interactive-cd
web-search wd vscode urltools universalarchive tmux tig themes
rsync ripgrep react-native pip nvm npm node ng gitignore
github git-prompt git-flow fzf dotnet docker command-not-found
colorize colored-man-pages brew 1password)

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# zsh completions 
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi

# Determine prompt 
if [ $(command -v oh-my-posh) ]; then
  eval "$(oh-my-posh --init --shell zsh --config "$HOME/.config/ohmyposh/ohmyposhv3-v2.json")"
else 
  # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
  znap source romkatv/powerlevel10k
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
fi

fastfetch
