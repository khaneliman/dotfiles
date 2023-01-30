#!/usr/bin/env bash
SHARED_HOME="$DOTS_DIR"/shared/home/

shared_backup_existing() {
	message "[>>] Backing up existing dotfiles to $BACKUP_LOCATION"

	mkdir -p "$BACKUP_LOCATION"/.local/share/

	# backup .config
	mv ~/.config/BetterDiscord "$BACKUP_LOCATION"/.config/
	mv ~/.config/alacritty "$BACKUP_LOCATION"/.config/
	mv ~/.config/astronvim "$BACKUP_LOCATION"/.config/
	mv ~/.config/bat "$BACKUP_LOCATION"/.config/
	mv ~/.config/btop "$BACKUP_LOCATION"/.config/
	mv ~/.config/davmail "$BACKUP_LOCATION"/.config/
	mv ~/.config/fastfetch "$BACKUP_LOCATION"/.config/
	mv ~/.config/fish "$BACKUP_LOCATION"/.config/
	mv ~/.config/kitty "$BACKUP_LOCATION"/.config/
	mv ~/.config/micro "$BACKUP_LOCATION"/.config/
	mv ~/.config/nvim "$BACKUP_LOCATION"/.config/
	mv ~/.local/share/nvim "$BACKUP_LOCATION"/.local/share/nvim/
	mv ~/.config/ranger "$BACKUP_LOCATION"/.config/
	mv ~/.config/spicetify "$BACKUP_LOCATION"/.config/
	mv ~/.config/topgrade.toml "$BACKUP_LOCATION"/.config/

	mv ~/.gnupg "$BACKUP_LOCATION"
	mv ~/.ssh "$BACKUP_LOCATION"
	mv ~/.gitconfig "$BACKUP_LOCATION"
	mv ~/.gitconfig.functions "$BACKUP_LOCATION"
	mv ~/.gitconfig.signing "$BACKUP_LOCATION"
	mv ~/.wakatime.cfg "$BACKUP_LOCATION"
	mv ~/.wegorc "$BACKUP_LOCATION"
}

correct_ssh_permissions() {
	message "[>>] Settings ~/.ssh permissions"

	chmod 700 ~/.ssh
	chmod 600 ~/.ssh/*
}

install_bat_themes() {
	if [[ $(command -v bat) ]]; then
		message "[>>] Installing bat theme"
		# bat requires cache to be rebuilt to detect themes in config directory
		bat cache --build
	else
		message '[!!] bat not detected... installation instructions: https://github.com/sharkdp/bat#installation'
	fi
}

install_better_discord() {
	if [[ $(command -v betterdiscordctl) ]]; then
		message '[>>] Better discord detected... installing..'
		betterdiscordctl install
	else
		message '[!!] Better Discord not detected... installation instructions: https://docs.betterdiscord.app/users/getting-started/installation'
	fi
}

install_fish_plugins() {
	if [[ $(command -v fish) ]]; then
		message "[>>] Installing fisher..."
		fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"

		message "[>>] Installing fish plugins"
		message "[>>] DO NOT configure Tide when prompted"

		cp "$DOTS_DIR"/shared/home/.config/fish/fish_plugins ~/.config/fish/

		fish -c "fisher update"
	else
		message '[!!] Fish not detected... installation instructions: https://fishshell.com/'
	fi
}

install_spicetify() {
	if [[ $(command -v spicetify) ]]; then

		message '[>>] Spicetify detected.. configuring and setting theme'

		if [[ "$OSTYPE" == "linux-gnu"* ]]; then

			message '[>>] Linux detected.. checking for spotify installations'

			# Spotify path
			if [[ -d "/opt/spotify/" ]]; then
				message '[>>] Spotify detected in /opt/spotify.. setting permissions and spotify_path'

				sudo chmod a+wr /opt/spotify
				sudo chmod a+wr /opt/spotify/Apps -R

				command -v spicetify && spicetify config spotify_path /opt/spotify/

			elif [[ -d "/usr/share/spotify" ]]; then
				message '[>>] Spotify detected in /usr/share/spotify.. settings permissions and spotify_path'

				sudo chmod a+wr /usr/share/spotify
				sudo chmod a+wr /usr/share/spotify/Apps -R

				command -v spicetify && spicetify config spotify_path /usr/share/spotify

			elif [[ -d "$HOME/.var/app/com.spotify.Client/config/spotify" ]]; then
				message '[>>] Spotify detected in ~/.var/app/com.spotify.Client/config/spotify.. settings permissions and spotify_path'

				sudo chmod a+wr ~/.var/app/com.spotify.Client/config/spotify
				sudo chmod a+wr ~/.var/app/com.spotify.Client/config/spotify/Apps -R

				command -v spicetify && spicetify config spotify_path ~/.var/app/com.spotify.Client/config/spotify
			fi

			# Preferences path
			if [[ -f "$HOME/.config.spotify/prefs" ]]; then
				message '[>>] Spotify prefs found at ~/.config/spotify/prefs... settings prefs_path'

				command -v spicetify && spicetify config prefs_path ~/.config/spotify/prefs

			elif [[ -f "$HOME/.var/app/com.spotify.Client/config/spotify/prefs" ]]; then
				message '[>>] Spotify prefs found at ~/.var/app/com.spotify.Client/config/spotify/prefs... settings prefs_path'

				command -v spicetify && spicetify config prefs_path ~/.var/app/com.spotify.Client/config/spotify/prefs
			fi
		fi

		if [[ "$OSTYPE" == "darwin"* ]]; then

			message '[>>] macOS detected.. checking for spotify installations'

			# Spotify path
			if [[ -d "/Applications/Spotify.app/" ]]; then
				message '[>>] Spotify detected in /Applications/Spotify.app/.. setting spotify_path'

				command -v spicetify && spicetify config spotify_path /Applications/Spotify.app/Contents/Resources
			fi

			# Preferences path
			if [[ -f "$HOME/Library/Application Support/Spotify/prefs" ]]; then
				message '[>>] Spotify prefs found at ~/Library/Application Support/Spotify/prefs... settings prefs_path'

				command -v spicetify && spicetify config prefs_path "$HOME/Library/Application Support/Spotify/prefs"
			fi
		fi

		spicetify config inject_css 1
		spicetify config replace_colors 1
		spicetify config custom_apps marketplace

		spicetify backup apply
		spicetify apply
	else
		message '[!!] Spicetify not detected... installation instructions: https://spicetify.app/docs/advanced-usage/installation/'
	fi
}

initialize_submodules() {
	message '[>>] Pulling submodules'

	git submodule update --init --recursive --remote
	git pull --recurse-submodules
}

shared_copy_configuration() {
	message '[>>] Copying shared config files'

	# copy home folder dotfiles if you dont want to use symlinks
	# cp -r "$DOTS_DIR"/shared/home/. ~

	# link files that replace contents of location
	ln -s "$SHARED_HOME"/.config/BetterDiscord ~/.config/BetterDiscord
	ln -s "$SHARED_HOME"/.config/alacritty ~/.config/alacritty
	ln -s "$SHARED_HOME"/.config/nvim ~/.config/nvim
	ln -s "$SHARED_HOME"/.config/astronvim/lua/user ~/.config/nvim/lua/user
	ln -s "$SHARED_HOME"/.config/bat ~/.config/bat
	ln -s "$SHARED_HOME"/.config/btop ~/.config/btop
	ln -s "$SHARED_HOME"/.config/davmail ~/.config/davmail
	ln -s "$SHARED_HOME"/.config/fastfetch ~/.config/fastfetch
	ln -s "$SHARED_HOME"/.config/fish ~/.config/fish
	ln -s "$SHARED_HOME"/.config/kitty ~/.config/kitty
	ln -s "$SHARED_HOME"/.config/micro ~/.config/micro
	ln -s "$SHARED_HOME"/.config/ranger ~/.config/ranger
	ln -s "$SHARED_HOME"/.config/spicetify ~/.config/spicetify
	ln -s "$SHARED_HOME"/.config/topgrade.toml ~/.config/topgrade.toml
	ln -s "$SHARED_HOME"/.gnupg ~/.gnupg
	ln -s "$SHARED_HOME"/.ssh ~/.ssh
	ln -s "$SHARED_HOME"/.face ~/.face
	ln -s "$SHARED_HOME"/.face.icon ~/.face.icon
	ln -s "$SHARED_HOME"/.gitconfig ~/.gitconfig
	ln -s "$SHARED_HOME"/.gitconfig.functions ~/.gitconfig.functions
	ln -s "$SHARED_HOME"/.gitconfig.signing ~/.gitconfig.signing
	ln -s "$SHARED_HOME"/.wakatime.cfg ~/.wakatime.cfg
	ln -s "$SHARED_HOME"/.wegorc ~/.wegorc

	# copy files that dont replace contents of location
	cp -r "$SHARED_HOME"/.fonts/ ~/.fonts/
	cp -r "$SHARED_HOME"/.local/ ~/.local/
}

shared_install() {

	# Backup
	shared_backup_existing

	# Fetch dependencies
	initialize_submodules

	# Copy config
	shared_copy_configuration
	correct_ssh_permissions

	# Installations
	install_spicetify
	install_better_discord
	install_bat_themes
	install_fish_plugins
}
