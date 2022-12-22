#!/usr/bin/env bash

backup_location="$HOME/.dotfiles-backup/$(date -d "today" +"%Y%m%d%H%M%S")/"

shared_copy_configuration() {
	# copy home folder dotfiles
	cp -r "$DOTS_DIR"/shared/home/. ~
}

initialize_submodules() {
  cd "$DOTS_DIR"/shared/home/.config/nvim/ && git submodule update --init
}

backup_existing() {
  mkdir -p "$backup_location"

  # backup .config
  mv ~/.config/astronvim "$backup_location"
  mv ~/.config/bat "$backup_location"
  mv ~/.config/btop "$backup_location"
  mv ~/.config/davmail "$backup_location"
  mv ~/.config/fastfetch "$backup_location"
  mv ~/.config/kitty "$backup_location"
  mv ~/.config/nvim "$backup_location"
  mv ~/.config/ranger "$backup_location"

  mv ~/.gnupg "$backup_location"
  mv ~/.ssh "$backup_location"
  mv ~/.gitconfig "$backup_location"

}

shared_install() {
  backup_existing
  initialize_submodules
  shared_copy_configuration
}
