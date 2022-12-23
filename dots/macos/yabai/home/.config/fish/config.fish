fish_add_path  "/opt/local/bin" "/opt/local/sbin"
eval $("/opt/homebrew/bin/brew" shellenv)

if status is-interactive
    # Commands to run in interactive sessions can go here
    fastfetch
end

# Hide welcome message
set fish_greeting

## Useful aliases
# Replace ls with exa
alias ls='lsd -al --color=always --group-directories-first' # preferred listing
alias la='lsd -a --color=always --group-directories-first'  # all files and dirs
alias ll='lsd -l --color=always --group-directories-first'  # long format
alias lt='lsd -aT --color=always --group-directories-first' # tree listing
alias l.="lsd -a | egrep '^\.'"                                     # show only dotfiles

# Replace some more things with better alternatives
alias cat='bat --style header --style rules --style snip --style changes --style header'

# Common use
alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias wget='wget -c '

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias please='sudo'

# Recent installed packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"

# thefuck --alias | source

export VISUAL="nvim"
export EDITOR="$VISUAL"

fish_ssh_agent
