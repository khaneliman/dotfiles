#!/usr/bin/env bash

LOGGED_USER=$(stat -f%Su /dev/console)

# Declare all apps here
large_blank='{tile-data={}; tile-type="spacer-tile";}'

small_blank='{tile-data={}; tile-type="small-spacer-tile";}'

launchpad=$(dock_item "/System/Applications/Launchpad.app")

settings=$(dock_item "/System/Applications/System Settings.app")

appstore=$(dock_item "/System/Applications/App Store.app")

notes=$(dock_item "/System/Applications/Notes.app")

firefox=$(dock_item "/Applications/Firefox Developer Edition.app")

mail=$(dock_item "/System/Applications/Mail.app")

messages=$(dock_item "/System/Applications/Messages.app")

messenger=$(dock_item "/Applications/Messenger.app")

teams=$(dock_item "/Applications/Microsoft Teams.app")

safari=$(dock_item "/Applications/Safari.app")

fantastical=$(dock_item "/Applications/Fantastical.app")

reminders=$(dock_item "/System/Applications/Reminders.app")

music=$(dock_item "/System/Applications/Music.app")

plex=$(dock_item "/Applications/Plex.app")

code=$(dock_item "/Applications/Visual Studio Code.app")

# visualstudio=$(dock_item "/Application/Visual Studio (Preview).app")

github=$(dock_item "/Applications/GitHub Desktop.app")

gitkraken=$(dock_item "/Applications/GitKraken.app")

alacritty=$(dock_item "/Applications/Alacritty.app")

kitty=$(dock_item "/Applications/kitty.app")

spotify=$(dock_item "/Applications/Spotify.app")

discord=$(dock_item "/Applications/Discord.app")

dock_item() {
	printf "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>%s</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>" "$1"
}

customize_dock() {
	message "Customizing the dock"
	warning_message "Enter password to delete contents of dock and replace with new setup"

	sudo su "$LOGGED_USER" -c 'defaults delete com.apple.dock persistent-apps'

	sudo su "$LOGGED_USER" -c "defaults write com.apple.dock persistent-apps -array 	\
'$launchpad' '$settings' '$appstore' '$small_blank' 																		\
'$messages' '$messenger' '$teams' '$discord' '$mail' '$small_blank' 										\
'$firefox' '$safari' '$fantastical' '$reminders' '$notes' '$small_blank' 								\
'$music' '$spotify' '$plex' '$small_blank' 																							\
'$code' '$visualstudio' '$github' '$gitkraken' '$small_blank' 													\
'$alacritty' '$kitty'"

	success_message "Dock contents were updated. Restarting dock..."

	killall Dock
}
