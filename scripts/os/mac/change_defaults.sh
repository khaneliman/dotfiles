#!/usr/bin/env bash

change_defaults() {
	message "Changing macOS defaults..."

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

	success_message "Defaults updated"
}
