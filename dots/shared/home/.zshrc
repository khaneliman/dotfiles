# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Source zsh plugi# Download Znap, if it's not there yet.
[[ -f ~/.config/zsnap/zsh-snap/znap.zsh ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git ~/.config/zsnap/zsh-snap

source ~/.config/zsnap/zsh-snap/znap.zsh  # Start Znapns

# `znap source` automatically downloads and starts your plugins.
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-syntax-highlighting

export VISUAL="nvim"
export EDITOR="$VISUAL"
export MICRO_TRUECOLOR=1
export PATH="$PATH:/opt/local/bin:/opt/local/sbin:$HOME/.local/share/pnpm:~/.spicetify"
PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

    autoload -Uz compinit
    compinit
fi

  plugins=(
  git zsh-autosuggestions zsh-syntax-highlighting sudo
  web-search history macos zsh-navigation-tools zsh-interactive-cd
  web-search wd vscode urltools universalarchive tmux tig themes
  rsync ripgrep react-native pip nvm npm node ng gitignore
  github git-prompt git-flow fzf dotnet docker command-not-found
  colorize colored-man-pages brew 1password)

# Sketchybar interactivity overloads
function brew() {
  command brew "$@"

  if [[ $* =~ "upgrade" ]] || [[ $* =~ "update" ]] || [[ $* =~ "outdated" ]]; then
    sketchybar --trigger brew_update
  fi
  
  local dump_commands=('install' 'uninstall') # Include all commands that should do a brew dump
  local main_command="${1}"

  for command in "${dump_commands[@]}"; do
    [[ "${command}" == "${main_command}" ]] && brew bundle dump --file="${HOME}/.Brewfile" --force
  done
}

function mas() {
  command mas "$@"

  if [[ $* =~ "upgrade" ]] || [[ $* =~ "update" ]] || [[ $* =~ "outdated" ]]; then
    sketchybar --trigger brew_update
  fi
}

function zen() {
  ~/.config/sketchybar/plugins/zen.sh $1
}

function push() {
  command git push
  sketchybar --trigger git_push
}

fastfetch

# Source aliases
source ~/.aliases
if [ $(command -v oh-my-posh) ]; then
  eval "$(oh-my-posh --init --shell zsh --config "$HOME/.config/ohmyposh/ohmyposhv3-v2.json")"
else 
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
znap source romkatv/powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
fi
