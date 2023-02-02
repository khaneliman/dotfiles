# Variables setup
$GIT_DIR = git rev-parse --show-toplevel
$DOTS_DIR = $GIT_DIR+"/dots"
$SCRIPTS_DIR = $GIT_DIR+"/scripts"
$wc = New-Object net.webclient

##
# Script exports
##
$REGISTRY_ENTRY_CLASS = $SCRIPTS_DIR+"/os/windows/classes/registry-entry.ps1"
$UPSERT_REGISTRY_ENTRY = $SCRIPTS_DIR+"/os/windows/utils/upsert_registry_entry.ps1"
$TEST_COMMAND_EXISTS = $SCRIPTS_DIR+"/os/windows/utils/test_command_exists.ps1"
$USER_PREFERENCES_MASK = $SCRIPTS_DIR+"/os/windows/utils/update_userpreferencesmask.ps1"
$ELEVATE_SCRIPT = $SCRIPTS_DIR+"/os/windows/utils/elevate_script.ps1"

# Source functions
.$TEST_COMMAND_EXISTS
.$USER_PREFERENCES_MASK

##
# Set powershell execution policy
##
echo 'Setting powershell to allow execution of scripts'
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser

##
# Install fonts
##
echo '
Installing fonts'
.$SCRIPTS_DIR/os/windows/install_fonts.ps1 $DOTS_DIR"/shared/home/.fonts/SanFransisco"

##
# Enable developer mode
##
write-host "
Enabling developer mode and installing WSL"
.$SCRIPTS_DIR/os/windows/enable_developer_mode.ps1

##
# Install software
##
echo "
Installing software."
.$SCRIPTS_DIR/os/windows/install_programs.ps1

##
# Customize windows taskbar
##
write-host "
Customizing the taskbar"
.$SCRIPTS_DIR/os/windows/customize_taskbar.ps1

##
# Customize cursor
##
write-host "
Installing Catppuccin-Mocha-Blue-Cursors"
.$SCRIPTS_DIR/os/windows/customize_cursor.ps1 "$DOTS_DIR/windows/themes/Cursor/Catppuccin-Mocha-Blue-Cursors/install.inf"

##
# Update windows theme
##
write-host "
Installing Explorer Themes" 
.$SCRIPTS_DIR/os/windows/customize_explorer.ps1 "$DOTS_DIR/windows/themes/Explorer/" "$DOTS_DIR/windows/themes/Explorer/catppuccin" "$DOTS_DIR/windows/themes/Explorer/catppuccin/Shell/NormalColor" "$DOTS_DIR/windows/themes/Explorer/catppuccin/wallpapers"

# ##
# # Copy Config Files
# ##
# write-host "
# Installing Config Files" 
# .$SCRIPTS_DIR/os/windows/copy_configs.ps1 "$DOTS_DIR/windows/home/" "$DOTS_DIR/shared/home/"