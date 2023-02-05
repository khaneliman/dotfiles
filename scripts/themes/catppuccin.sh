#!/usr/bin/env bash

cat_backup_existing() {
	backup_files "$HOME"/.gtkrc-2.0 "$BACKUP_LOCATION"/
	backup_files "$HOME"/.config/gtk-4.0 "$BACKUP_LOCATION"/.config/
	backup_files "$HOME"/.config/gtk-3.0 "$BACKUP_LOCATION"/.config/
	backup_files "$HOME"/.config/Kvantum "$BACKUP_LOCATION"/.config/
	backup_files "$HOME"/.config/qt5ct "$BACKUP_LOCATION"/.config/
	backup_files "$HOME"/.config/qt6ct "$BACKUP_LOCATION"/.config/
}

cat_theme_gtk() {
	# Gtk Theme workaround
	# Set gsettings for theme
	message "Configure gsettings to use Catppuccin..."
	gsettings set org.gnome.desktop.interface gtk-theme 'Catppuccin-Macchiato'
	gsettings set org.gnome.desktop.interface icon-theme 'oomox-Catppuccin-Macchiato'
	gsettings set org.gnome.desktop.interface font-name 'Liga SFMono Nerd Font 10'
	gsettings set org.gnome.desktop.interface cursor-theme 'Catppuccin-Mocha-Dark-Cursors'
	gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
	gsettings set org.gnome.desktop.interface enable-animations true
	success_message "Set gsettings to Catppuccin"

	# Set gtkrc file themes
	message "Configure gtkrc files to use Catppuccin..."
	sed -i 's/gtk-theme-name.*/gtk-theme-name="Catppuccin-Macchiato"/' "$HOME"/.gtkrc-2.0
	sed -i 's/gtk-icon-theme-name.*/gtk-icon-theme-name="oomox-Catppuccin-Macchiato"/' "$HOME"/.gtkrc-2.0
	sed -i 's/gtk-font-name.*/gtk-font-name="Liga SFMono Nerd Font 10"/' "$HOME"/.gtkrc-2.0
	sed -i 's/gtk-theme-name.*/gtk-theme-name=Catppuccin-Macchiato/' "$HOME"/.config/gtk-3.0/settings.ini
	sed -i 's/gtk-icon-theme-name.*/gtk-icon-theme-name=oomox-Catppuccin-Macchiato/' "$HOME"/.config/gtk-3.0/settings.ini
	sed -i 's/gtk-font-name.*/gtk-font-name="Liga SFMono Nerd Font 10"/' "$HOME"/.config/gtk-3.0/settings.ini
	sed -i 's/gtk-theme-name.*/gtk-theme-name=Catppuccin-Macchiato/' "$HOME"/.config/gtk-4.0/settings.ini
	sed -i 's/gtk-icon-theme-name.*/gtk-icon-theme-name=oomox-Catppuccin-Macchiato/' "$HOME"/.config/gtk-4.0/settings.ini
	sed -i 's/gtk-font-name.*/gtk-font-name="Liga SFMono Nerd Font 10"/' "$HOME"/.config/gtk-4.0/settings.ini
	success_message "Set gtkrc to use Catppuccin"

	# Copy theme css files to gtk folders
	message "Replace gtk css files with Catppuccin..."
	replace_files "$HOME"/.themes/Catppuccin-Macchiato/gtk-4.0/gtk.css "$HOME"/.config/gtk-4.0/gtk.css
	replace_files "$HOME"/.themes/Catppuccin-Macchiato/gtk-4.0/gtk-dark.css "$HOME"/.config/gtk-4.0/gtk-dark.css
	replace_files "$HOME"/.themes/Catppuccin-Macchiato/gtk-3.0/gtk.css "$HOME"/.config/gtk-3.0/gtk.css
	replace_files "$HOME"/.themes/Catppuccin-Macchiato/gtk-3.0/gtk-dark.css "$HOME"/.config/gtk-3.0/gtk-dark.css
}

cat_theme_qt() {
	# Qt Theme Workaround
	message "Configure qt files to use Catppuccin..."
	sed -i 's/theme=.*/theme=Catppuccin-Macchiato-Blue/' "$HOME"/.config/Kvantum/kvantum.kvconfig
	sed -i 's/icon_theme=.*/icon_theme="oomox-Catppuccin-Macchiato"/' "$HOME"/.config/qt5ct/qt5ct.conf
	sed -i 's/fixed=.*/fixed="Liga SFMono Nerd Font Mono 10"/' "$HOME"/.config/qt5ct/qt5ct.conf
	sed -i 's/general=.*/general="Liga SFMono Nerd Font 10"/' "$HOME"/.config/qt5ct/qt5ct.conf
	sed -i 's/style=.*/style="kvantum"/' "$HOME"/.config/qt5ct/qt5ct.conf
	sed -i 's/icon_theme=.*/icon_theme="oomox-Catppuccin-Macchiato"/' "$HOME"/.config/qt6ct/qt6ct.conf
	sed -i 's/fixed=.*/fixed="Liga SFMono Nerd Font Mono 10"/' "$HOME"/.config/qt6ct/qt6ct.conf
	sed -i 's/general=.*/general="Liga SFMono Nerd Font 10"/' "$HOME"/.config/qt6ct/qt6ct.conf
	sed -i 's/style=.*/style="kvantum"/' "$HOME"/.config/qt6ct/qt6ct.conf
	success_message "Set qtct configuration to Catppuccin"
}

cat_theme_firefox() {
	# Install firefox theme
	case "$(uname)" in
	"Linux")
		"$SCRIPT_DIR"/firefox-themer.sh -p dev -t minimal
		;;
	"Darwin")
		# TODO: need to identify location on mac
		;;
	esac
}

cat_theme_spotify() {
	# Set spicetify theme
	if [[ $(command -v spicetify) ]]; then
		message "setting spicetify theme"
		spicetify config current_theme catppuccin-macchiato
		spicetify config color_scheme blue
		spicetify apply
		success_message "Installed Spotify Catppuccin theme"
	else
		error_message "Spicetify not detected... installation instructions: https://spicetify.app/docs/advanced-usage/installation/"
	fi
}

cat_theme_all() {
	cat_backup_existing

	if [ "$(uname)" = "Linux" ]; then
		cat_theme_gtk
		cat_theme_qt
	else
		warning_message "Not running Linux. Skipping GTK/QT themes."
	fi

	cat_theme_firefox
	cat_theme_spotify
}
