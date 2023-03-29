# Add paths
fish_add_path "/opt/local/bin" "/opt/local/sbin" # Homebrew applications
fish_add_path "$HOME"/kde/src/kdesrc-build # KDE src location
fish_add_path /usr/lib/jvm/default/bin # java bin
fish_add_path "$HOME"/.cargo/bin # cargo bin
fish_add_path "$PNPM_HOME" 
fish_add_path "$HOME"/.spicetify

# Source aliases
if [ -f "$HOME"/.aliases ];
    source ~/.aliases
end

# 1password plugin
if [ -f ~/.config/op/plugins.sh ];
    source ~/.config/op/plugins.sh
end

# Brew environment
if [ -f /opt/homebrew/bin/brew ];
	eval "$("/opt/homebrew/bin/brew" shellenv)"
end

# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish' ];
 source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
end
if [ -f '/nix/var/nix/profiles/default/etc/profile.d/nix.fish' ];
 source '/nix/var/nix/profiles/default/etc/profile.d/nix.fish'
end
# End Nix

# SSH setup 
[ $(command -v fish_ssh_agent) ] && fish_ssh_agent
load_ssh # if you need ssh loading keys on shell launch

# OS Dependent config
switch (uname)
    case Linux
        [ -f "/usr/share/doc/find-the-command/ftc.fish" ] && source /usr/share/doc/find-the-command/ftc.fish noupdate quiet
       
        # IF Arch
        if [ -f "/etc/arch-release" ];
            [ $(command -v neofetch) ] && alias neofetch='neofetch --source $HOME/.config/neofetch/arch'
            
            if [ $(command -v hyprctl) ];
                # Hyprland logs 
                alias hl='cat /tmp/hypr/$(lsd -t /tmp/hypr/ | head -n 1)/hyprland.log'
                alias hl1='cat /tmp/hypr/$(lsd -t -r /tmp/hypr/ | head -n 2 | tail -n 1)/hyprland.log'
            end
        end
    case Darwin
        eval $("/opt/homebrew/bin/brew" shellenv)
    case '*'
        echo Hi, stranger!
end

# Fetch on terminal open
if status is-interactive
    fastfetch 
end
