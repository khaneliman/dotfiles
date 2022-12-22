# Source zsh plugins
ZSH_THEME="bira"
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh
eval "$(starship init zsh)"

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

[ -d "/opt/homebrew/share/zsh-autosuggestions/" ] && source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ||
  source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

[ -d "/opt/homebrew/share/zsh-syntax-highlighting/highlighters" ] && export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/opt/homebrew/share/zsh-syntax-highlighting/highlighters ||
  export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/usr/local/share/zsh-syntax-highlighting/highlighters

plugins=(
  git zsh-autosuggestions zsh-syntax-highlighting sudo
  web-search history macos zsh-navigation-tools zsh-interactive-cd
  web-search wd vscode urltools universalarchive tmux tig themes
  rsync ripgrep react-native pip nvm npm node ng gitignore
  github git-prompt git-flow fzf dotnet docker command-not-found
  colorize colored-man-pages brew 1password)

# Aliases for common dirs
alias home="cd ~"

# System Aliases
alias ..="cd .."
alias clear="clear && fastfetch"

# Git Aliases
alias add="git add"
alias commit="git commit"
alias pull="git pull"
alias stat="git status"
alias gdiff="git diff HEAD"
alias vdiff="git difftool HEAD"
alias log="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias cfg="git --git-dir=$HOME/dotfiles/ --work-tree=$HOME"

export "MICRO_TRUECOLOR=1"

# Sketchybar interactivity overloads
function brew() {
  command brew "$@"

  if [[ $* =~ "upgrade" ]] || [[ $* =~ "update" ]] || [[ $* =~ "outdated" ]]; then
    sketchybar --trigger brew_upgrade
  fi
}

function mas() {
  command mas "$@"

  if [[ $* =~ "upgrade" ]] || [[ $* =~ "update" ]] || [[ $* =~ "outdated" ]]; then
    sketchybar --trigger brew_upgrade
  fi
}

function zen() {
  ~/.config/sketchybar/plugins/zen.sh $1
}

function push() {
  command git push
  sketchybar --trigger git_push
}

alias n="nnn"
function nnn() {
  command nnn "$@"

  if [ -f "$NNN_TMPFILE" ]; then
    . "$NNN_TMPFILE"
  fi
}

# Only load conda into path but dont actually use the bloat that comes with it
# export PATH="$HOME/miniforge3/bin:/usr/local/anaconda3/bin:$PATH"
# export NNN_TMPFILE="$HOME/.config/nnn/.lastd"
# export EDITOR="$(which nvim)"
# export VISUAL="$HOME/.config/nnn/plugins/selnew.sh"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/Users/khaneliman/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/Users/khaneliman/miniforge3/etc/profile.d/conda.sh" ]; then
#         . "/Users/khaneliman/miniforge3/etc/profile.d/conda.sh"
#     else
#         export PATH="/Users/khaneliman/miniforge3/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# <<< conda initialize <<<

neofetch
export PATH=$PATH:/Users/khaneliman/.spicetify
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
