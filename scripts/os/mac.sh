#!/usr/bin/env bash

MAC_HOME="$DOTS_DIR"/macos/yabai/home/

mac_backup_existing() {
	message "[>>] Backing up existing dotfiles to $BACKUP_LOCATION"

	mv ~/.config/sketchybar "$BACKUP_LOCATION"/.config/
	mv ~/.config/skhd "$BACKUP_LOCATION"/.config/
	mv ~/.config/yabai "$BACKUP_LOCATION"/.config/
	mv ~/.hammerspoon "$BACKUP_LOCATION"/
	mv ~/.gitconfig.local "$BACKUP_LOCATION"/
	mv ~/.zshrc "$BACKUP_LOCATION"/
}

brew_install() {
	# Install Brew
	message "[>>] Installing Brew..."

	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	brew analytics off
}

bundle_install() {
	message "[>>] Installing taps, brews, casks, and apps... "

	brew bundle --file ./mac/Brewfile
}

change_defaults() {
	message "[>>] Changing macOS defaults..."

	defaults write NSGlobalDomain AppleAccentColor -int 1
	defaults write NSGlobalDomain AppleHighlightColor -string "0.65098 0.85490 0.58431"
	defaults write NSGlobalDomain AppleShowAllExtensions -bool true
	defaults write NSGlobalDomain KeyRepeat -int 1
	defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
	defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
	defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
	defaults write NSGlobalDomain _HIHideMenuBar -bool true
	defaults write com.apple.Finder AppleShowAllFiles -bool true
	defaults write com.apple.LaunchServices LSQuarantine -bool false
	defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1
	defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
	defaults write com.apple.Safari IncludeDevelopMenu -bool true
	defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
	defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
	defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool YES
	defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
	defaults write com.apple.dock "mru-spaces" -bool "false"
	defaults write com.apple.dock autohide -bool true
	defaults write com.apple.finder DisableAllAnimations -bool true
	defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
	defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
	defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
	defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
	defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
	defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
	defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
	defaults write com.apple.finder ShowStatusBar -bool false
	defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
	defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false
	defaults write com.apple.screencapture disable-shadow -bool true
	defaults write com.apple.screencapture location -string "$HOME/Pictures/screenshots/"
	defaults write com.apple.screencapture type -string "png"
	defaults write com.apple.spaces spans-displays -bool false
	defaults write com.apple.finder CreateDesktop false
}

enable_brew_servies() {
	# Start Services
	message "[>>] Starting Services (grant permissions)..."
	brew services start skhd
	brew services start yabai
	brew services start sketchybar
}

install_fonts() {
	# macOS Fonts aren't read from ~/.fonts and symbolic links dont work, need to move to ~/Library/Fonts
	sudo mv ~/.fonts/* ~/Library/Fonts/
}

mac_copy_configuration() {
	# copy home folder dotfiles if you dont want to use symlinks
	# cp -r "$DOTS_DIR"/macos/yabai/home/. ~

	# symlinks for files that completely replace location
	ln -s "$MAC_HOME"/.config/skhd ~/.config/skhd
	ln -s "$MAC_HOME"/.config/yabai ~/.config/yabai
	ln -s "$MAC_HOME"/.config/sketchybar ~/.config/sketchybar
	ln -s "$MAC_HOME"/.hammerspoon ~/.hammerspoon

	ln -s "$MAC_HOME"/.config/ranger/config/local.conf ~/.config/ranger/config/local.conf
	ln -s "$MAC_HOME"/.config/fish/conf.d/tide.fish ~/.config/fish/conf.d/tide.fish
	ln -s "$MAC_HOME"/.config/fish/functions/brew.fish ~/.config/fish/functions/brew.fish
	ln -s "$MAC_HOME"/.config/fish/functions/suyabai.fish ~/.config/fish/functions/suyabai.fish
	ln -s "$MAC_HOME"/.config/fish/functions/zen.fish ~/.config/fish/functions/zen.fish

	ln -s "$MAC_HOME"/.gitconfig.local ~/.gitconfig.local
	ln -s "$MAC_HOME"/.zshrc ~/.zshrc

	# copy files that dont replace location
	cp -r "$MAC_HOME"/.terminfo ~/.terminfo
	cp -r "$MAC_HOME"/Library ~/Library
}

1password_ssh_link() {
	mkdir -p ~/.1password && ln -s ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock ~/.1password/agent.sock
}

mac_install() {
	mac_backup_existing

	# Configure macOS
	change_defaults

	# Copy configuration
	mac_copy_configuration
	install_fonts

	# Installs
	brew_install
	bundle_install

	1password_ssh_link

	cat_theme_all

	# Enable services
	enable_brew_servies

	# Output current SIP status
	csrutil status
}
