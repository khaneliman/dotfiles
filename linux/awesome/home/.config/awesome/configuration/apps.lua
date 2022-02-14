local filesystem = require('gears.filesystem')
local config_dir = filesystem.get_configuration_dir()
local utils_dir = config_dir .. 'utilities/'

return {
	-- The default applications that we will use in keybindings and widgets
	default = {
		-- Default terminal emulator
		terminal = 'kitty',
		-- Default web browser
		web_browser = 'firefox-developer-edition',
		-- Default text editor
		text_editor = 'kate',
		-- Default file manager
		file_manager = 'dolphin',
		-- Default media player
		multimedia = 'vlc',
		-- Default game, can be a launcher like steam
		game = 'steam',
		-- Default graphics editor
		graphics = 'gimp',
		-- Default sandbox
		sandbox = 'virt-manager',
		-- Default IDE
		development = 'code',
		-- Default network manager
		network_manager = 'networkmanager_dmenu',
		-- Default bluetooth manager
		bluetooth_manager = 'blueman-manager',
		-- Default power manager
		power_manager = 'xfce4-power-manager',
		-- Default GUI package manager
		package_manager = 'alacritty -e topgrade',
		-- Default locker
		lock = 'awesome-client "awesome.emit_signal(\'module::lockscreen_show\')"',
		-- Default quake terminal
		quake = 'kitty --name QuakeTerminal',
		-- Default rofi global menu
		rofi_global = 'rofi -dpi ' .. screen.primary.dpi .. 
							' -show "Global Search" -modi "Global Search":' .. config_dir .. 
							'/configuration/rofi/global/rofi-spotlight.sh' .. 
							' -theme ' .. config_dir ..
							'/configuration/rofi/global/rofi.rasi',
		-- Default app menu
		rofi_appmenu = 'rofi -dpi ' .. screen.primary.dpi ..
							' -show drun -theme ' .. config_dir ..
							'/configuration/rofi/appmenu/rofi.rasi'

		-- You can add more default applications here
	},

	-- List of apps to start once on start-up
	run_on_start_up = {
		-- Compositor
		'picom -b --experimental-backends --dbus --config ' ..
		config_dir .. '/configuration/picom.conf',
		-- Load X colors
		'xrdb $HOME/.Xresources',
		-- Polkit and keyring
		'/usr/lib/polkit-kde-authentication-agent-1 &' ..
		' eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg)',
		-- Audio equalizer
		-- 'pulseeffects --gapplication-service',
		-- 'easyeffects --gapplication-service',
		-- Blueman applet
		'blueman-applet',
		-- Music server
		-- 'mpd',
		-- Lockscreen timer
		[[
		xidlehook --not-when-fullscreen --not-when-audio --timer 600 \
		"awesome-client 'awesome.emit_signal(\"module::lockscreen_show\")'" ""
		]],
		-- Corsair keyboard driver
		-- 'ckb-next -b',
		-- RGB software
		-- 'openrgb --startminimized --profile Default'
		-- EWS server (moved to systemd service)
	},

	-- List of binaries/shell scripts that will execute for a certain task
	utils = {
		-- Fullscreen screenshot
		full_screenshot = utils_dir .. 'snap full',
		-- Area screenshot
		area_screenshot = utils_dir .. 'snap area',
		-- Update profile picture
		update_profile  = utils_dir .. 'profile-image'
	}
}
 