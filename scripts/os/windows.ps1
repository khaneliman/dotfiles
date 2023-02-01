# Variables setup
$GIT_DIR = git rev-parse --show-toplevel
$DOTS_DIR = $GIT_DIR+"/dots"
$SCRIPTS_DIR = $GIT_DIR+"/scripts"
$wc = New-Object net.webclient

# Source functions
.$SCRIPTS_DIR/os/windows/utils/test_command_exists.ps1

echo 'Setting powershell to allow execution of scripts'
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser

##
# Check path and Update path if needed
#
echo '
Adding to user path, as needed.'
$PATH = [Environment]::GetEnvironmentVariable("PATH", "User")

# local bin
$local_bin = "$($env:USERPROFILE)\.local\bin\"
if( $PATH -notlike "*"+$local_bin+"*" ){
    echo '  Adding ~/.local/bin to path'
    .$SCRIPTS_DIR/os/windows/utils/append_user_path.cmd %USERPROFILE%\.local\bin\
} else {
    echo '  ~/.local/bin already in path. Skipping.'
}

# msys bin
$msys_bin = "C:\msys64\usr\bin"
if( $PATH -notlike "*"+$msys_bin+"*" ){
    echo '  Adding C:\msys64\usr\bin to path'
    .$SCRIPTS_DIR/os/windows/utils/append_user_path.cmd C:\msys64\usr\bin
} else {
    echo '  C:\msys64\usr\bin already in path. Skipping.'
}

##
# Install fonts
##
echo '
Installing fonts'
.$SCRIPTS_DIR/os/windows/install_fonts.ps1 $DOTS_DIR"/shared/home/.fonts/SanFransisco"

##
# Install software
##
echo "
Installing software."
.$SCRIPTS_DIR/os/windows/install_programs.ps1

##
# Enable developer mode
##
write-host "
Enabling developer mode and installing WSL"
.$SCRIPTS_DIR/os/windows/enable_developer_mode.ps1

##
# Customize windows taskbar
##
write-host "
Customizing the taskbar"
.$SCRIPTS_DIR/os/windows/customize_taskbar.ps1

##
# Update windows theme
##
write-host "
Installing Explorer Themes" 
.$SCRIPTS_DIR/os/windows/customize_explorer.ps1 "$DOTS_DIR/windows/themes/Explorer/" "$DOTS_DIR/windows/themes/Explorer/catppuccin"

##
# Customize cursor
##
write-host "
Installing Catppuccin-Mocha-Blue-Cursors"
.$SCRIPTS_DIR/os/windows/customize_cursor.ps1 "$DOTS_DIR/windows/themes/Cursor/Catppuccin-Mocha-Blue-Cursors/install.inf"