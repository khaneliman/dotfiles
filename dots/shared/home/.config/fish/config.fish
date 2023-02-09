# Add paths
fish_add_path "/opt/local/bin" "/opt/local/sbin" # Homebrew applications
fish_add_path "$HOME"/kde/src/kdesrc-build # KDE src location
fish_add_path /usr/lib/jvm/default/bin # java bin

if [ -f ~/.config/op/plugins.sh ];
    source ~/.config/op/plugins.sh
end

# pnpm
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
set -gx PATH "$PNPM_HOME" $PATH
# pnpm end

# Replace ls with lsd
[ $(command -v lsd) ] && alias ls='lsd -al --color=always --group-directories-first' # preferred listing
[ $(command -v lsd) ] && alias la='lsd -a --color=always --group-directories-first'  # all files and dirs
[ $(command -v lsd) ] && alias ll='lsd -l --color=always --group-directories-first'  # long format
[ $(command -v lsd) ] && alias lt='lsd -a --tree --color=always --group-directories-first -I .git' # tree listing
[ $(command -v lsd) ] && alias lst='lsd -al --tree --color=always --group-directories-first -I .git' # tree listing
[ $(command -v lsd) ] && alias llt='lsd -l --tree --color=always --group-directories-first -I .git' # tree listing
[ $(command -v lsd) ] && alias l.="lsd -a | egrep '^\.'"                             # show only dotfilesalias ls='lsd -a'

# Replace some more things with better alternatives
[ $(command -v bat) ] && alias cat='bat'

# File management
alias rcp="rsync -rahP --mkpath --modify-window=1" # Rsync copy keeping all attributes,timestamps,permissions'
alias rmv="rsync -rahP --mkpath --modify-window=1 --remove-sent-files" # Rsync move keeping all attributes,timestamps,permissions
alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias wget='wget -c '

# Navigation shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

# Colorize output
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Misc
alias pls='sudo'
alias clr='clear'
alias vim='nvim'

# Cryptography
alias genpass='openssl rand -base64 20' # Generate a random, 20-charactered password
alias sha='shasum -a 256' # Test checksum
alias sshperm='find .ssh/ -type f -exec chmod 600 {} \;; find .ssh/ -type d -exec chmod 700 {} \;; find .ssh/ -type f -name "*.pub" -exec chmod 644 {} \;'

# Network
alias cn='ping -c 5 8.8.8.8' # Ping google, checking network
alias ipe='curl ifconfig.co' # Get external IP address
alias ips='ip link show' # Get network interfaces information
alias wloff='rfkill block wlan' # Block wlan, killing wifi connection
alias wlon='rfkill unblock wlan' # Unblock wlan, start wifi connection

# program shortcuts
[ $(command -v topgrade) ] && alias upd="topgrade $argv"
[ $(command -v lazygit) ] && alias lg="lazygit $argv"

# SSH setup 
[ $(command -v fish_ssh_agent) ] && fish_ssh_agent
load_ssh # if you need ssh loading keys on shell launch

# OS Dependent config
switch (uname)
    case Linux
        [ -f "/usr/share/doc/find-the-command/ftc.fish" ] && source /usr/share/doc/find-the-command/ftc.fish noupdate quiet
        
        alias grubup="sudo update-grub"
        alias psmem='ps auxf | sort -nr -k 4'
        alias psmem10='ps auxf | sort -nr -k 4 | head -10'
        alias hw='hwinfo --short'                                   # Hardware Info
        alias jctl="journalctl -p 3 -xb" # Get the error messages from journalctl
        alias runsrv="systemctl list-units  --type=service  --state=running $argv" 
       
        # Package management
        # IF Arch
        if [ -f "/etc/arch-release" ];
            [ ! -x /usr/bin/yay ] && [ -x /usr/bin/paru ] && alias yay='paru'
            [ $(command -v expac) ] && alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
            alias reinstallall="sudo pacman -Qqn | sudo  pacman -S -" # Reinstall all packages
            alias fixpacman="sudo rm /var/lib/pacman/db.lck" # Remove pacman lock
            alias cleanup='sudo pacman -Rns (pacman -Qtdq)' # Cleanup orphaned packages
            alias rmpkg="sudo pacman -Rdd"
            alias gitpkg='pacman -Q | grep -i "\-git" | wc -l'			# List amount of -git packages
            [ $(command -v expac) ] && alias big="expac -H M '%m\t%n' | sort -h | nl"              # Sort installed packages according to size in MB 
            alias yeet="yay -Rns $argv" # Remove package and all dependencies
            alias yeetorphan="pacman -Qtdq | sudo pacman -Rns - $argv"
            alias neofetch='neofetch --source $HOME/.config/neofetch/arch'

            # Get fastest mirrors
            alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
            alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
            alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
            alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

            if [ $(command -v hyprctl) ];
                # Hyprland logs 
                alias hl='cat /tmp/hypr/$(lsd -t /tmp/hypr/ | head -n 1)/hyprland.log'
                alias hl1='cat /tmp/hypr/$(lsd -t -r /tmp/hypr/ | head -n 2 | tail -n 1)/hyprland.log'
            end
            
            # Fetch on terminal open
            if status is-interactive
                neofetch 
            end
        else if [ -f "/etc/fedora-release" ];
            # Fetch on terminal open
            if status is-interactive
                fastfetch
            end
        else 
             # Fetch on terminal open
            if status is-interactive
                fastfetch
            end
        end
    case Darwin
        eval $("/opt/homebrew/bin/brew" shellenv)
        
        # Fetch on terminal open
        if status is-interactive
            fastfetch
        end

    case '*'
            echo Hi, stranger!
end

