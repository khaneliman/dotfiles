#!/usr/bin/env bash

current_time=$(date "+%Y.%m.%d-%H.%M.%S")
backup_location="$HOME/.dotfiles-backup/$current_time/"

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
  mv ~/.config/spicetify "$backup_location"

  mv ~/.gnupg "$backup_location"
  mv ~/.ssh "$backup_location"
  mv ~/.gitconfig "$backup_location"
}

correct_ssh_permissions() {
  chmod 700 ~/.ssh
  chmod 600 ~/.ssh/*
}

install_bat_themes() {
  # bat requires cache to be rebuilt to detect themes in config directory
  bat cache --build
}

install_fish_plugins() {
  fisher update
}

install_spicetify() {
  if [[ $(command -v spicetify) ]]; then

    echo 'Spicetify detected.. configuring and setting theme'

    if [[ "$OSTYPE" == "linux-gnu"* ]]; then

      echo 'Linux detected.. checking for spotify installations'

      # Spotify path
      if [[ -d "/opt/spotify/" ]]; then 
        echo 'Spotify detected in /opt/spotify.. setting permissions and spotify_path'
        
        sudo chmod a+wr /opt/spotify
        sudo chmod a+wr /opt/spotify/Apps -R

        command -v spicetify && spicetify config spotify_path /opt/spotify/

      elif [[ -d "/usr/share/spotify" ]]; then 
        echo 'Spotify detected in /usr/share/spotify.. settings permissions and spotify_path'
        
        sudo chmod a+wr /usr/share/spotify
        sudo chmod a+wr /usr/share/spotify/Apps -R

        command -v spicetify && spicetify config spotify_path /usr/share/spotify

      elif [[ -d "$HOME/.var/app/com.spotify.Client/config/spotify" ]]; then
        echo 'Spotify detected in ~/.var/app/com.spotify.Client/config/spotify.. settings permissions and spotify_path'
        
        sudo chmod a+wr ~/.var/app/com.spotify.Client/config/spotify 
        sudo chmod a+wr ~/.var/app/com.spotify.Client/config/spotify/Apps -R

        command -v spicetify && spicetify config spotify_path ~/.var/app/com.spotify.Client/config/spotify
      fi 

      # Preferences path
      if [[ -f "$HOME/.config.spotify/prefs" ]]; then
      echo 'Spotify prefs found at ~/.config/spotify/prefs... settings prefs_path'
      
      command -v spicetify && spicetify config prefs_path ~/.config/spotify/prefs
    
      elif [[ -f "$HOME/.var/app/com.spotify.Client/config/spotify/prefs" ]]; then 
      echo 'Spotify prefs found at ~/.var/app/com.spotify.Client/config/spotify/prefs... settings prefs_path'
      
      command -v spicetify && spicetify config prefs_path ~/.var/app/com.spotify.Client/config/spotify/prefs
      fi
    fi
    
    if [[ "$OSTYPE" == "darwin"* ]]; then

      echo 'macOS detected.. checking for spotify installations'

      # Spotify path
      if [[ -d "/Applications/Spotify.app/" ]]; then 
        echo 'Spotify detected in /Applications/Spotify.app/.. setting spotify_path'

        command -v spicetify && spicetify config spotify_path /Applications/Spotify.app/Contents/Resources
      fi
      
      # Preferences path
      if [[ -f "$HOME/Library/Application Support/Spotify/prefs" ]]; then
      echo 'Spotify prefs found at ~/Library/Application Support/Spotify/prefs... settings prefs_path'
      
      command -v spicetify && spicetify config prefs_path "$HOME/Library/Application Support/Spotify/prefs"
      fi
    fi
    
    spicetify config current_theme catppuccin-macchiato
    spicetify config color_scheme blue

    spicetify backup apply
    spicetify apply
  fi
}

initialize_submodules() {
  cd "$DOTS_DIR"/shared/home/.config/nvim/ && git submodule update --init
}

shared_copy_configuration() {
	# copy home folder dotfiles
	cp -r "$DOTS_DIR"/shared/home/. ~
}

shared_install() {
  backup_existing
  initialize_submodules
  shared_copy_configuration
  correct_ssh_permissions
  install_spicetify
  install_bat_themes
  install_fish_plugins
}
