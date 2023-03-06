#!/usr/bin/env bash

MAC_HOME="$DOTS_DIR"/macos/yabai/home

for filename in "$SCRIPTS_DIR"/os/mac/*.sh; do
	[ -e "$filename" ] || continue
	source "$filename"
done

1password_ssh_link() {
	if [[ -d "$HOME"/Library/Group\ Containers/2BUA8C4S2C.com.1password/ ]]; then
		message "Linking 1password ssh agent to home folder..."
		mkdir -p "$HOME"/.1password && link_locations "$HOME"/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock "$HOME"/.1password/agent.sock
		success_message "1password ssh agent linked up"
	else
		warning_message "1password not installed. Skipping linking ssh agent..."
	fi
}

brew_install() {
	# Install Brew
	if (! command -v brew); then
		message "Installing Brew..."
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	else
		warning_message "Brew already installed. Skipping..."
	fi

	brew analytics off
}

bundle_install() {
	if (command -v brew); then
		message "Installing taps, brews, casks, and apps... "
		brew bundle --file "$HOME"/.Brewfile
	else
		warning_message "Brew not installed! Skipping apps..."
	fi
}

enable_brew_servies() {
	# Start Services
	if (command -v brew); then
		message "Starting Services (grant permissions)..."
		brew services start skhd
		brew services start yabai
		brew services start sketchybar
	else
		warning_message "Brew not installed! Skipping enabling services..."
	fi
}

install_fonts() {
	# macOS Fonts aren't read from "$HOME"/.fonts and symbolic links dont work, need to move to "$HOME"/Library/Fonts
	message "Installing fonts..."
	sudo mv "$HOME"/.fonts/* "$HOME"/Library/Fonts/
	success_message "Fonts installed"
}

mac_backup_existing() {
	message "Backing up existing dotfiles to $BACKUP_LOCATION"

	backup_files "$HOME"/.config/sketchybar "$BACKUP_LOCATION"/.config/
	backup_files "$HOME"/.config/skhd "$BACKUP_LOCATION"/.config/
	backup_files "$HOME"/.config/yabai "$BACKUP_LOCATION"/.config/

	backup_files "$HOME"/.Brewfile "$BACKUP_LOCATION"/
	backup_files "$HOME"/.hammerspoon "$BACKUP_LOCATION"/
	backup_files "$HOME"/.gitconfig.local "$BACKUP_LOCATION"/
	backup_files "$HOME/Application Support/Firefox/Profiles/" "$BACKUP_LOCATION"/Application Support/Firefox/Profiles/
	backup_files "$HOME/Application Support/BetterDiscord/" "$BACKUP_LOCATION"/Application Support/
}

mac_copy_configuration() {
	message "Installing config files..."
	# copy home folder dotfiles if you dont want to use symlinks
	# copy_files "$DOTS_DIR"/macos/yabai/home/. "$HOME"

	# symlinks for files that completely replace location
	link_locations "$MAC_HOME"/.config/alacritty/local.alacritty.yml "$HOME"/.config/alacritty/local.alacritty.yml
	link_locations "$MAC_HOME"/.config/fish/conf.d/tide.fish "$HOME"/.config/fish/conf.d/tide.fish
	link_locations "$MAC_HOME"/.config/fish/functions/brew.fish "$HOME"/.config/fish/functions/brew.fish
	link_locations "$MAC_HOME"/.config/fish/functions/suyabai.fish "$HOME"/.config/fish/functions/suyabai.fish
	link_locations "$MAC_HOME"/.config/fish/functions/zen.fish "$HOME"/.config/fish/functions/zen.fish
	link_locations "$MAC_HOME"/.config/kitty/macos.kitty.conf "$HOME"/.config/kitty/macos.kitty.conf
	link_locations "$MAC_HOME"/.config/ranger/config/local.conf "$HOME"/.config/ranger/config/local.conf
	link_locations "$MAC_HOME"/.config/sketchybar "$HOME"/.config/sketchybar
	link_locations "$MAC_HOME"/.config/skhd "$HOME"/.config/skhd
	link_locations "$MAC_HOME"/.config/yabai "$HOME"/.config/yabai
	link_locations "$MAC_HOME"/.config/BetterDiscord "$HOME/Library/Application Support/BetterDiscord"

	link_locations "$MAC_HOME"/.local/bin/helper "$HOME"/.local/bin/helper
	link_locations "$MAC_HOME"/.local/share/fastfetch/presets/local-overrides "$HOME"/.local/share/fastfetch/presets/local-overrides

	link_locations "$MAC_HOME"/.Brewfile "$HOME"/.Brewfile
	link_locations "$MAC_HOME"/.hammerspoon "$HOME"/.hammerspoon
	link_locations "$MAC_HOME"/.gitconfig.local "$HOME"/.gitconfig.local

	# copy files that dont replace location
	copy_files "$MAC_HOME"/.terminfo "$HOME"/
	copy_files "$MAC_HOME"/Library "$HOME"/
	copy_files "$HOME"/.mozilla/firefox/ "$HOME/Application Support/Firefox/Profiles/"
	copy_files "$HOME"/.config/Caprine/ "$HOME/Application Support/Caprine/"
}

mac_install() {
	mac_backup_existing

	# Configure macOS
	change_defaults
	mac_change_symbolickeys

	# Copy configuration
	mac_copy_configuration
	install_fonts

	# Installs
	brew_install
	bundle_install
	customize_dock

	1password_ssh_link

	cat_theme_all

	# Enable services
	enable_brew_servies

	set_wallpapers

	# Output current SIP status
	csrutil status
}

set_wallpapers() {
	if [[ $(command -v yabai) ]]; then
		message "Setting wallpapers for each desktop"

		LOCAL_WALLPAPERS="$(realpath "$HOME"/.local/share/wallpapers/catppuccin)"

		yabai -m space --focus 1

		i=0

		for file in "$LOCAL_WALLPAPERS"/*.png; do
			((i = i + 1))
			echo "Setting wallpaper on space $i to $file..."
			# take action on each file. $f store current file name
			osascript -e 'tell application "Finder" to set desktop picture to POSIX file "'"$file"'"'
			yabai -m space --focus next 2 &>/dev/null
			sleep 0.1
		done

		success_message "Desktop pictures set."
	else
		warning_message "Yabai is not running. Cannot set wallpapers. Skipping..."
	fi
}
