## Advanced command-not-found hook
source /usr/share/doc/find-the-command/ftc.fish

fish_add_path $HOME/kde/src/kdesrc-build
fish_add_path /usr/lib/jvm/default/bin

# Fish colors
set -g fish_color_command --bold green
set -g fish_color_error red
set -g fish_color_quote yellow
set -g fish_color_param white
set -g fish_pager_color_selected_completion blue

# Some config
set -g fish_greeting
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

# Get terminal emulator
set TERM_EMULATOR (ps -aux | grep (ps -p $fish_pid -o ppid=) | awk 'NR==1{print $11}')

# Neofetch
if status --is-interactive
   fastfetch | lolcat
end

# Replace some more things with better alternatives
alias cat='bat --style header --style --style snip --style changes --style header'
[ ! -x /usr/bin/yay ] && [ -x /usr/bin/paru ] && alias yay='paru'

# Common use
alias clear="clear && fastfetch | lolcat"
alias nuke="sudo pacman -Rns"
alias pls="sudo"

# File commands
alias rcp="rsync -rahP --mkpath --modify-window=1" # Rsync copy keeping all attributes,timestamps,permissions'
alias rmv="rsync -rahP --mkpath --modify-window=1 --remove-sent-files" # Rsync move keeping all attributes,timestamps,permissions
alias tarnow='tar -acf '
alias untar='tar -zxvf '
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

# System commands
alias grubup="sudo update-grub"
alias wget='wget -c '
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias upd='/usr/bin/update'
alias hw='hwinfo --short'                                   # Hardware Info
alias jctl="journalctl -p 3 -xb" # Get the error messages from journalctl

# Package management
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl" # Recent installed packages
alias reinstallall="sudo pacman -Qqn | sudo  pacman -S -" # Reinstall all packages
alias fixpacman="sudo rm /var/lib/pacman/db.lck" # Remove pacman lock
alias cleanup='sudo pacman -Rns (pacman -Qtdq)' # Cleanup orphaned packages
alias rmpkg="sudo pacman -Rdd"
alias gitpkg='pacman -Q | grep -i "\-git" | wc -l'			# List amount of -git packages
alias big="expac -H M '%m\t%n' | sort -h | nl"              # Sort installed packages according to size in MB

# Directory abbreviations
abbr -a -g d 'dirs'
abbr -a -g h 'cd $HOME'
alias ls='lsd -al --color=always --group-directories-first' # preferred listing
alias la='lsd -a --color=always --group-directories-first'  # all files and dirs
alias ll='lsd -l --color=always --group-directories-first'  # long format
alias lt='lsd -a --tree --color=always --group-directories-first' # tree listing
alias l.="lsd -a | egrep '^\.'"                                     # show only dotfiles

# Get fastest mirrors
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

# Hyprland logs 
alias hl='cat /tmp/hypr/$(lsd -t /tmp/hypr/ | head -n 1)/hyprland.log'
alias hl1='cat /tmp/hypr/$(lsd -t -r /tmp/hypr/ | head -n 2 | tail -n 1)/hyprland.log'

# Custom bins

# Locale
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Exports
export VISUAL="nvim"
export EDITOR="$VISUAL"

# Term
switch "$TERM_EMULATOR"
case '*kitty*'
	export TERM='xterm-kitty'
case '*'
	export TERM='xterm-256color'
end

# User abbreviations
abbr -a -g ytmp3 'youtube-dl --extract-audio --audio-format mp3'				# Convert/Download YT videos as mp3
abbr -a -g cls 'clear'																								# Clear
abbr -a -g h 'history'																								# Show history
abbr -a -g upd 'yay -Syu --noconfirm'																								# Update everything
abbr -a -g please 'sudo'																						# Polite way to sudo
abbr -a -g fucking 'sudo'																						# Rude way to sudo
abbr -a -g sayonara 'shutdown now'																	# Epic way to shutdown
abbr -a -g stahp 'shutdown now'																		# Panik - stonk man
abbr -a -g ar 'echo "awesome.restart()" | awesome-client'							# Reload AwesomeWM
abbr -a -g shinei 'kill -9'																						# Kill ala DIO
abbr -a -g kv 'kill -9 (pgrep vlc)'																			# Kill zombie vlc
abbr -a -g priv 'fish --private'																				# Fish incognito mode
abbr -a -g sshon 'sudo systemctl start sshd.service'										# Start ssh service
abbr -a -g sshoff 'sudo systemctl stop sshd.service'										# Stop ssh service
abbr -a -g untar 'tar -zxvf'																					# Untar
abbr -a -g genpass 'openssl rand -base64 20'													# Generate a random, 20-charactered password
abbr -a -g sha 'shasum -a 256'																			# Test checksum
abbr -a -g cn 'ping -c 5 8.8.8.8'																			# Ping google, checking network
abbr -a -g ipe 'curl ifconfig.co'																				# Get external IP address
abbr -a -g ips 'ip link show'																					# Get network interfaces information
abbr -a -g wloff 'rfkill block wlan'																			# Block wlan, killing wifi connection
abbr -a -g wlon 'rfkill unblock wlan'																		# Unblock wlan, start wifi connection
abbr -a -g ff 'firefox'																								# Launch firefox

# Source plugins
# Useful plugins: archlinux bang-bang cd colorman sudope vcs
if test -d "$HOME/.local/share/omf/pkg/colorman/"
	source ~/.local/share/omf/pkg/colorman/init.fish
end

# Make su launch fish
function su
   command su --shell=/usr/bin/fish $argv
end

set LAST_REPO ""
function cd 
    builtin cd "$argv";
    git rev-parse 2>/dev/null;

    if [ $status -eq 0 ]
        if [ "$LAST_REPO" != $(basename $(git rev-parse --show-toplevel)) ]
        onefetch
        set LAST_REPO $(basename $(git rev-parse --show-toplevel))
        end
    end
end
export "MICRO_TRUECOLOR=1"

# pnpm
set -gx PNPM_HOME "/home/khaneliman/.local/share/pnpm"
set -gx PATH "$PNPM_HOME" $PATH
# pnpm end

fish_ssh_agent

if [ -n "$RANGER_LEVEL" ]
	export PS1="[ranger]$PS1"
end
