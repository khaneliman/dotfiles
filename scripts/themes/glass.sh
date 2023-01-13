#!/usr/bin/env bash

glass_backup_existing() {
	cp ~/.gtkrc-2.0 "$BACKUP_LOCATION"/.config/
	cp -r ~/.config/gtk-4.0/ "$BACKUP_LOCATION"/.config/
	cp -r ~/.config/gtk-3.0/ "$BACKUP_LOCATION"/.config/
	cp -r ~/.config/Kvantum/ "$BACKUP_LOCATION"/.config/
	cp -r ~/.config/qt5ct/ "$BACKUP_LOCATION"/.config/
	cp -r ~/.config/qt6ct/ "$BACKUP_LOCATION"/.config/
}

glass_theme_gtk() {
	# Gtk Theme workaround
	# Set gsettings for theme
	echo "gsettings set themes..."
	gsettings set org.gnome.desktop.interface gtk-theme 'Breeze_Dark_Glass_80'
	gsettings set org.gnome.desktop.interface icon-theme 'breeze-dark'
	gsettings set org.gnome.desktop.interface font-name 'Liga SFMono Nerd Font 10'
	gsettings set org.gnome.desktop.interface cursor-theme 'breeze_cursors'
	gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
	gsettings set org.gnome.desktop.interface enable-animations true

	# Set gtkrc file themes
	echo "sed set gtkrc themes..."
	sed -i 's/gtk-theme-name.*/gtk-theme-name="Breeze_Dark_Glass_80"/' ~/.gtkrc-2.0
	sed -i 's/gtk-icon-theme-name.*/gtk-icon-theme-name="breeze-dark"/' ~/.gtkrc-2.0
	sed -i 's/gtk-font-name.*/gtk-font-name="Liga SFMono Nerd Font 10"/' ~/.gtkrc-2.0
	sed -i 's/gtk-theme-name.*/gtk-theme-name=Breeze_Dark_Glass_80/' ~/.config/gtk-3.0/settings.ini
	sed -i 's/gtk-icon-theme-name.*/gtk-icon-theme-name=breeze-dark/' ~/.config/gtk-3.0/settings.ini
	sed -i 's/gtk-font-name.*/gtk-font-name="Liga SFMono Nerd Font 10"/' ~/.config/gtk-3.0/settings.ini
	sed -i 's/gtk-theme-name.*/gtk-theme-name=Breeze_Dark_Glass_80/' ~/.config/gtk-4.0/settings.ini
	sed -i 's/gtk-icon-theme-name.*/gtk-icon-theme-name=breeze-dark/' ~/.config/gtk-4.0/settings.ini
	sed -i 's/gtk-font-name.*/gtk-font-name="Liga SFMono Nerd Font 10"/' ~/.config/gtk-4.0/settings.ini

	# Copy theme css files to gtk folders
	echo "copy theme files..."
	rm -f ~/.config/gtk-4.0/gtk.css
	rm -f ~/.config/gtk-4.0/gtk-dark.css
	ln -s ~/.themes/Breeze_Dark_Glass_80/gtk-4.0/gtk.css ~/.config/gtk-4.0/gtk.css
	ln -s ~/.themes/Breeze_Dark_Glass_80/gtk-4.0/gtk-dark.css ~/.config/gtk-4.0/gtk-dark.css
	rm -f ~/.config/gtk-3.0/gtk.css
	rm -f ~/.config/gtk-3.0/gtk-dark.css
	ln -s ~/.themes/Breeze_Dark_Glass_80/gtk-3.0/gtk.css ~/.config/gtk-3.0/gtk.css
	ln -s ~/.themes/Breeze_Dark_Glass_80/gtk-3.0/gtk-dark.css ~/.config/gtk-3.0/gtk-dark.css
}

glass_theme_qt() {
	# Qt Theme Workaround
	echo "sed set qt file themes..."
	sed -i 's/theme=.*/theme=Breeze_Dark_Glass_80-Blue/' ~/.config/Kvantum/kvantum.kvconfig
	sed -i 's/icon_theme=.*/icon_theme="breeze-dark"/' ~/.config/qt5ct/qt5ct.conf
	sed -i 's/fixed=.*/fixed="Liga SFMono Nerd Font Mono 10"/' ~/.config/qt5ct/qt5ct.conf
	sed -i 's/general=.*/general="Liga SFMono Nerd Font 10"/' ~/.config/qt5ct/qt5ct.conf
	sed -i 's/style=.*/style="kvantum"/' ~/.config/qt5ct/qt5ct.conf
	sed -i 's/icon_theme=.*/icon_theme="breeze-dark"/' ~/.config/qt6ct/qt6ct.conf
	sed -i 's/fixed=.*/fixed="Liga SFMono Nerd Font Mono 10"/' ~/.config/qt6ct/qt6ct.conf
	sed -i 's/general=.*/general="Liga SFMono Nerd Font 10"/' ~/.config/qt6ct/qt6ct.conf
	sed -i 's/style=.*/style="kvantum"/' ~/.config/qt6ct/qt6ct.conf
}

glass_theme_firefox() {
	# Install firefox theme
	case "$(uname)" in
	"Linux")
		"$SCRIPT_DIR"/firefox-themer.sh -p dev -t blurredfox
		;;
	"Darwin")
		# TODO: need to identify location on mac
		;;
	esac
}

glass_theme_spotify() {
	# Set spicetify theme
	if [[ $(command -v spicetify) ]]; then
		echo "setting spicetify theme"
		# spicetify config current_theme ??
		spicetify config color_scheme blue
		spicetify apply
	else
		echo 'Spicetify not detected... installation instructions: https://spicetify.app/docs/advanced-usage/installation/'
	fi
}

glass_theme_all() {
	glass_backup_existing

	if [ "$(uname)" = "Linux" ]; then
		glass_theme_gtk
		glass_theme_qt
	fi

	glass_theme_firefox
	# glass_theme_spotify
}
