#!/usr/bin/env bash

#github-action genshdoc
#
# @file Hyprland custom script
# @brief Contains the functions used to configure and theme Hyprland window manager
# @stdout Output routed to install.log
# @stderror Output routed to install.log

HYPR_HOME="$DOTS_DIR"/linux/hyprland/home

hypr_backup_existing() {
	message "Backing up existing dotfiles to $BACKUP_LOCATION"

	# backup .config
	backup_files "$HOME"/.config/Kvantum "$BACKUP_LOCATION"/.config/
	backup_files "$HOME"/.config/OpenRGB "$BACKUP_LOCATION"/.config/
	# backup_files "$HOME"/.config/aconfmgr "$BACKUP_LOCATION"/.config/ # not being used right now
	backup_files "$HOME"/.config/ckb-next "$BACKUP_LOCATION"/.config/
	backup_files "$HOME"/.config/gtk-2.0 "$BACKUP_LOCATION"/.config/
	backup_files "$HOME"/.config/gtk-3.0 "$BACKUP_LOCATION"/.config/
	backup_files "$HOME"/.config/gtk-4.0 "$BACKUP_LOCATION"/.config/
	backup_files "$HOME"/.config/hypr "$BACKUP_LOCATION"/.config/
	backup_files "$HOME"/.config/mako "$BACKUP_LOCATION"/.config/
	backup_files "$HOME"/.config/paru "$BACKUP_LOCATION"/.config/
	backup_files "$HOME"/.config/qt5ct "$BACKUP_LOCATION"/.config/
	backup_files "$HOME"/.config/qt6ct "$BACKUP_LOCATION"/.config/
	backup_files "$HOME"/.config/rofi "$BACKUP_LOCATION"/.config/
	backup_files "$HOME"/.config/swappy "$BACKUP_LOCATION"/.config/
	backup_files "$HOME"/.config/swaylock "$BACKUP_LOCATION"/.config/
	backup_files "$HOME"/.config/swaync "$BACKUP_LOCATION"/.config/
	backup_files "$HOME"/.config/waybar "$BACKUP_LOCATION"/.config/
	backup_files "$HOME"/.config/wlogout "$BACKUP_LOCATION"/.config/
	backup_files "$HOME"/.config/mimeapps.list "$BACKUP_LOCATION"/.config/

	backup_files "$HOME"/.screenlayout/primary.sh "$BACKUP_LOCATION"/.screenlayout/
	backup_files "$HOME"/.gtkrc-2.0 "$BACKUP_LOCATION"
}

hypr_create_symlink() {
	message "Creating sym links for hyprland files"

	sudo ln -s -f "$HOME"/.local/share/wlroots-env/ /usr/local/share/
	sudo ln -s -f "$HOME"/.config/waybar/ /usr/local/share/
	sudo ln -s -f "$HOME"/.local/bin/Hyprland-custom /usr/local/bin/
	sudo ln -s -f "$HOME"/.local/bin/xdg-desktop-portal.sh /usr/local/bin/
	sudo ln -s -f "$HOME"/.local/bin/hyprland_setup_dual_monitors.sh /usr/local/bin
	sudo ln -s -f "$HOME"/.local/bin/hyprland_cleanup_after_startup.s /usr/local/binh
	sudo ln -s -f "$HOME"/.local/bin/hyprland_handle_monitor_connect.sh /usr/local/bin

	success_message "Successfully created Hyprland launcher symlinks"
}

hypr_enable_systemd_services() {
	message "Enabling user systemd services for hyprland"

	systemctl --user enable --now hypr-waybar.service
	systemctl --user enable --now waybar-config.path
	systemctl --user enable --now hypr-swayidle.service
	systemctl --user enable --now hyprpaper.service
	systemctl --user enable --now hyprland-desktop-portal.service
}

hypr_copy_configuration() {
	message "Copying config files for hyprland"

	# copy files in when not replacing contents completely
	copy_files "$HYPR_HOME"/.local/ "$HOME"/
	copy_files "$HYPR_HOME"/.themes/ "$HOME"/
	copy_files "$HYPR_HOME"/.screenlayout/ "$HOME"/
	copy_files "$HYPR_HOME"/.config/systemd/ "$HOME"/.config/

	# symlinks for stuff replaced completely
	link_locations "$HYPR_HOME"/.config/Kvantum "$HOME"/.config/Kvantum
	link_locations "$HYPR_HOME"/.config/OpenRGB "$HOME"/.config/OpenRGB
	link_locations "$HYPR_HOME"/.config/alacritty/local.alacritty.yml "$HOME"/.config/alacritty/local.alacritty.yml
	link_locations "$HYPR_HOME"/.config/ckb-next "$HOME"/.config/ckb-next
	link_locations "$HYPR_HOME"/.config/fish/conf.d/tide.fish "$HOME"/.config/fish/conf.d/tide.fish
	link_locations "$HYPR_HOME"/.config/gtk-3.0 "$HOME"/.config/gtk-3.0
	link_locations "$HYPR_HOME"/.config/gtk-4.0 "$HOME"/.config/gtk-4.0
	link_locations "$HYPR_HOME"/.config/hypr "$HOME"/.config/hypr
	link_locations "$HYPR_HOME"/.config/mako "$HOME"/.config/mako
	link_locations "$HYPR_HOME"/.config/mimeapps.list "$HOME"/.config/mimeapps.list
	link_locations "$HYPR_HOME"/.config/paru "$HOME"/.config/paru
	link_locations "$HYPR_HOME"/.config/qt5ct "$HOME"/.config/qt5ct
	link_locations "$HYPR_HOME"/.config/qt6ct "$HOME"/.config/qt6ct
	link_locations "$HYPR_HOME"/.config/rofi "$HOME"/.config/rofi
	link_locations "$HYPR_HOME"/.config/swappy "$HOME"/.config/swappy
	link_locations "$HYPR_HOME"/.config/swaylock "$HOME"/.config/swaylock
	link_locations "$HYPR_HOME"/.config/swaync "$HOME"/.config/swaync
	link_locations "$HYPR_HOME"/.config/waybar "$HOME"/.config/waybar
	link_locations "$HYPR_HOME"/.config/wlogout "$HOME"/.config/wlogout

	link_locations "$HYPR_HOME"/.local/share/fastfetch/presets/local-overrides "$HOME"/.local/share/fastfetch/presets/local-overrides

	link_locations "$HYPR_HOME"/.gitconfig.local "$HOME"/.gitconfig.local
	link_locations "$HYPR_HOME"/.gtkrc-2.0 "$HOME"/.gtkrc-2.0

	# copy desktop file for display manager
	sudo mkdir -p /usr/share/wayland-sessions/
	sudo cp "$DOTS_DIR"/linux/hyprland/usr/share/wayland-sessions/hyprland-custom.desktop /usr/share/wayland-sessions/
	success_message "Successfully copied Hyprland login manager file"
}

hyprland_install() {
	hypr_backup_existing

	hypr_copy_configuration
	hypr_create_symlink
	# hypr_enable_systemd_services # if you'd like systemd services

	cat_theme_all
}
