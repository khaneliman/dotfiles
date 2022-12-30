fish_add_path  "/opt/local/bin" "/opt/local/sbin"
fish_add_path $HOME/kde/src/kdesrc-build
fish_add_path /usr/lib/jvm/default/bin

# Hide welcome message
set fish_greeting

set -g theme_nerd_fonts yes

# Git config
set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_showupstream informative
set -g __fish_git_prompt_showdirtystate yes
set -g __fish_git_prompt_char_stateseparator ' '
set -g __fish_git_prompt_char_cleanstate '✔'
set -g __fish_git_prompt_char_dirtystate '✚'
set -g __fish_git_prompt_char_invalidstate '✖'
set -g __fish_git_prompt_char_stagedstate '●'
set -g __fish_git_prompt_char_stashstate '⚑'
set -g __fish_git_prompt_char_untrackedfiles '?'
set -g __fish_git_prompt_char_upstream_ahead ''
set -g __fish_git_prompt_char_upstream_behind ''
set -g __fish_git_prompt_char_upstream_diverged 'ﱟ'
set -g __fish_git_prompt_char_upstream_equal ''
set -g __fish_git_prompt_char_upstream_prefix ''''

## Useful aliases
# Replace ls with exa
[ $(command -v lsd) ] && alias ls='lsd -al --color=always --group-directories-first' # preferred listing
[ $(command -v lsd) ] && alias la='lsd -a --color=always --group-directories-first'  # all files and dirs
[ $(command -v lsd) ] && alias ll='lsd -l --color=always --group-directories-first'  # long format
[ $(command -v lsd) ] && alias lt='lsd -aT --color=always --group-directories-first' # tree listing
[ $(command -v lsd) ] && alias l.="lsd -a | egrep '^\.'"                             # show only dotfiles

# Replace some more things with better alternatives
[ $(command -v bat) ] && alias cat='bat'

# Common use
alias rcp="rsync -rahP --mkpath --modify-window=1" # Rsync copy keeping all attributes,timestamps,permissions'
alias rmv="rsync -rahP --mkpath --modify-window=1 --remove-sent-files" # Rsync move keeping all attributes,timestamps,permissions
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

# OS Dependent config
switch (uname)
    case Linux
        [ ! -x /usr/bin/yay ] && [ -x /usr/bin/paru ] && alias yay='paru'
        [ -f "/usr/share/doc/find-the-command/ftc.fish" ] && source /usr/share/doc/find-the-command/ftc.fish
        
        alias grubup="sudo update-grub"
        alias psmem='ps auxf | sort -nr -k 4'
        alias psmem10='ps auxf | sort -nr -k 4 | head -10'
        alias upd='/usr/bin/update'
        alias hw='hwinfo --short'                                   # Hardware Info
        alias jctl="journalctl -p 3 -xb" # Get the error messages from journalctl

        # Package management
        [ $(command -v expac) ] && alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
        alias reinstallall="sudo pacman -Qqn | sudo  pacman -S -" # Reinstall all packages
        alias fixpacman="sudo rm /var/lib/pacman/db.lck" # Remove pacman lock
        alias cleanup='sudo pacman -Rns (pacman -Qtdq)' # Cleanup orphaned packages
        alias rmpkg="sudo pacman -Rdd"
        alias gitpkg='pacman -Q | grep -i "\-git" | wc -l'			# List amount of -git packages
        [ $(command -v expac) ] && alias big="expac -H M '%m\t%n' | sort -h | nl"              # Sort installed packages according to size in MB 
    case Darwin
        eval $("/opt/homebrew/bin/brew" shellenv)
    case '*'
            echo Hi, stranger!
end

export VISUAL="nvim"
export EDITOR="$VISUAL"

# SSH setup 
fish_ssh_agent

if status is-interactive
    # Commands to run in interactive sessions can go here
    fastfetch
end

