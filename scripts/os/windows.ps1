# Variables setup
$global:GIT_DIR = git rev-parse --show-toplevel
$global:DOTS_DIR = $GIT_DIR+"/dots"
$global:SCRIPTS_DIR = $GIT_DIR+"/scripts"
$Env:PSModulePath = $Env:PSModulePath+";$SCRIPTS_DIR/os/windows/modules"
$global:wc = New-Object net.webclient

##
# Set powershell execution policy
##
Write-Host 'Setting powershell to allow execution of scripts'
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser

##
# Install fonts
##
Write-Host '
Installing fonts'
.$SCRIPTS_DIR/os/windows/Install-Fonts.ps1 $DOTS_DIR"/shared/home/.fonts/SanFransisco"

##
# Enable developer mode
##
Write-Host "
Enabling developer mode and Windows Features"
.$SCRIPTS_DIR/os/windows/Enable-WindowsFeatures.ps1

##
# Install software
##
Write-Host "
Installing software."
.$SCRIPTS_DIR/os/windows/Install-Programs.ps1

##
# Customize windows taskbar
##
Write-Host "
Customizing the taskbar"
.$SCRIPTS_DIR/os/windows/Customize-Taskbar.ps1

##
# Customize cursor
##
Write-Host "
Installing Catppuccin-Mocha-Blue-Cursors"
.$SCRIPTS_DIR/os/windows/Install-Cursor.ps1 "$DOTS_DIR/windows/themes/Cursor/Catppuccin-Mocha-Blue-Cursors/install.inf"

##
# Update windows theme
##
Write-Host "
Installing Explorer Themes" 
.$SCRIPTS_DIR/os/windows/Install-Theme.ps1 "$DOTS_DIR/windows/themes/Explorer/" "$DOTS_DIR/windows/themes/Explorer/catppuccin" "$DOTS_DIR/windows/themes/Explorer/catppuccin/Shell/NormalColor" "$DOTS_DIR/windows/themes/Explorer/catppuccin/wallpapers"

Write-Host "
Setting Windows Colors" 
.$SCRIPTS_DIR/os/windows/Theme-Explorer.ps1

# ##
# # Copy/Link Config Files
# ##
# Write-Host "
# Installing Config Files" 
# .$SCRIPTS_DIR/os/windows/copy_configs.ps1 "$DOTS_DIR/windows/home/" "$DOTS_DIR/shared/home/"
