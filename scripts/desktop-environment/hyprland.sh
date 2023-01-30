#!/usr/bin/env bash

#github-action genshdoc
#
# @file Hyprland custom script
# @brief Contains the functions used to configure and theme Hyprland window manager
# @stdout Output routed to install.log
# @stderror Output routed to install.log

HYPR_HOME="$DOTS_DIR"/linux/hyprland/home

hypr_backup_existing() {
	message "[>>] Backing up existing dotfiles to $BACKUP_LOCATION"

	mkdir -p "$BACKUP_LOCATION"

	# backup .config
	mv ~/.config/Kvantum "$BACKUP_LOCATION"/.config/
	mv ~/.config/OpenRGB "$BACKUP_LOCATION"/.config/
	mv ~/.config/aconfmgr "$BACKUP_LOCATION"/.config/
	mv ~/.config/ckb-next "$BACKUP_LOCATION"/.config/
	mv ~/.config/gtk-2.0 "$BACKUP_LOCATION"/.config/
	mv ~/.config/gtk-3.0 "$BACKUP_LOCATION"/.config/
	mv ~/.config/gtk-4.0 "$BACKUP_LOCATION"/.config/
	mv ~/.config/hypr "$BACKUP_LOCATION"/.config/
	mv ~/.config/mako "$BACKUP_LOCATION"/.config/
	mv ~/.config/paru "$BACKUP_LOCATION"/.config/
	mv ~/.config/qt5ct "$BACKUP_LOCATION"/.config/
	mv ~/.config/qt6ct "$BACKUP_LOCATION"/.config/
	mv ~/.config/rofi "$BACKUP_LOCATION"/.config/
	mv ~/.config/swappy "$BACKUP_LOCATION"/.config/
	mv ~/.config/swaylock "$BACKUP_LOCATION"/.config/
	mv ~/.config/waybar "$BACKUP_LOCATION"/.config/
	mv ~/.config/wlogout "$BACKUP_LOCATION"/.config/
	mv ~/.config/mimeapps.list "$BACKUP_LOCATION"/.config/

	mv ~/.screenlayout/primary.sh "$BACKUP_LOCATION"
	mv ~/.gtkrc-2.0 "$BACKUP_LOCATION"
}

hypr_create_symlink() {
	message "[>>] Creating sym links for hyprland files"

	sudo ln -s ~/.local/share/wlroots-env/ /usr/local/share/
	sudo ln -s ~/.config/waybar/ /usr/local/share/waybar
	sudo ln -s ~/.local/bin/Hyprland-custom /usr/local/bin/
	sudo ln -s ~/.local/bin/xdg-desktop-portal.sh /usr/local/bin/
	sudo ln -s ~/.local/bin/hyprland_setup_dual_monitors.sh /usr/local/bin
	sudo ln -s ~/.local/bin/hyprland_cleanup_after_startup.s /usr/local/binh
	sudo ln -s ~/.local/bin/hyprland_handle_monitor_connect.sh /usr/local/bin
}

hypr_enable_systemd_services() {
	message "[>>] Enabling user systemd services for hyprland"

	systemctl --user enable --now hypr-waybar.service
	systemctl --user enable --now waybar-config.path
	systemctl --user enable --now hypr-swayidle.service
	systemctl --user enable --now hyprpaper.service
	systemctl --user enable --now hyprland-desktop-portal.service
}

hypr_copy_configuration() {
	message "[>>] Copying config files for hyprland"

	# copy files in when not replacing contents completely
	cp -r "$HYPR_HOME"/.local/ ~/.local/
	cp -r "$HYPR_HOME"/.themes/ ~/.themes/
	cp -r "$HYPR_HOME"/.screenlayout/ ~/.screenlayout/
	cp -r "$HYPR_HOME"/.config/systemd/ ~/.config/systemd/

	# symlinks for stuff replaced completely
	ln -s "$HYPR_HOME"/.config/Kvantum ~/.config/Kvantum
	ln -s "$HYPR_HOME"/.config/OpenRGB ~/.config/OpenRGB
	ln -s "$HYPR_HOME"/.config/ckb-next ~/.config/ckb-next
	ln -s "$HYPR_HOME"/.config/fish/conf.d/tide.fish ~/.config/fish/conf.d/tide.fish
	ln -s "$HYPR_HOME"/.config/gtk-3.0 ~/.config/gtk-3.0
	ln -s "$HYPR_HOME"/.config/gtk-4.0 ~/.config/gtk-4.0
	ln -s "$HYPR_HOME"/.config/hypr ~/.config/hypr
	ln -s "$HYPR_HOME"/.config/mako ~/.config/mako
	ln -s "$HYPR_HOME"/.config/paru ~/.config/paru
	ln -s "$HYPR_HOME"/.config/qt5ct ~/.config/qt5ct
	ln -s "$HYPR_HOME"/.config/qt6ct ~/.config/qt6ct
	ln -s "$HYPR_HOME"/.config/rofi ~/.config/rofi
	ln -s "$HYPR_HOME"/.config/swappy ~/.config/swappy
	ln -s "$HYPR_HOME"/.config/swaylock ~/.config/swaylock
	ln -s "$HYPR_HOME"/.config/waybar ~/.config/waybar
	ln -s "$HYPR_HOME"/.config/wlogout ~/.config/wlogout
	ln -s "$HYPR_HOME"/.config/mimeapps.list ~/.config/mimeapps.list
	ln -s "$HYPR_HOME"/.gitconfig.local ~/.gitconfig.local
	ln -s "$HYPR_HOME"/.gtkrc-2.0 ~/.gtkrc-2.0

	# copy desktop file for display manager
	sudo mkdir -p /usr/share/wayland-sessions/
	sudo cp "$DOTS_DIR"/linux/hyprland/usr/share/wayland-sessions/hyprland-custom.desktop /usr/share/wayland-sessions/
}

hyprland_install() {
	hypr_backup_existing

	hypr_copy_configuration
	hypr_create_symlink
	hypr_enable_systemd_services

	cat_theme_all
}
