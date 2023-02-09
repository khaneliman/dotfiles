# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Source zsh plugi# Download Znap, if it's not there yet.
[[ -f ~/.config/zsnap/zsh-snap/znap.zsh ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git ~/Git/zsh-snap

source ~/.config/zsnap/zsh-snap/znap.zsh  # Start Znapns

# `znap source` automatically downloads and starts your plugins.
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-syntax-highlighting
znap source romkatv/powerlevel10k

ZSH_THEME="bira"
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh
eval "$(starship init zsh)"

export VISUAL="nvim"
export EDITOR="$VISUAL"

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm


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

alias ls='lsd -al --color=always --group-directories-first' # preferred listing
alias la='lsd -a --color=always --group-directories-first'  # all files and dirs
alias ll='lsd -l --color=always --group-directories-first'  # long format
alias lt='lsd -a --tree --color=always --group-directories-first' # tree listing
alias l.="lsd -a | egrep '^\.'"                                     # show only dotfiles

export "MICRO_TRUECOLOR=1"

# Sketchybar interactivity overloads
function brew() {
  command brew "$@"

  if [[ $* =~ "upgrade" ]] || [[ $* =~ "update" ]] || [[ $* =~ "outdated" ]]; then
    sketchybar --trigger brew_update
  fi
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

export PATH=$PATH:~/.spicetify
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

fastfetch

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
