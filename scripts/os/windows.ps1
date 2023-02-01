# Variables setup
$GIT_DIR = git rev-parse --show-toplevel
$DOTS_DIR = $GIT_DIR+"/dots"
$SCRIPTS_DIR = $GIT_DIR+"/scripts"
$wc = New-Object net.webclient

# Source functions
.$SCRIPTS_DIR/os/windows/test_command_exists.ps1

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
    .$SCRIPTS_DIR/os/windows/append_user_path.cmd %USERPROFILE%\.local\bin\
} else {
    echo '  ~/.local/bin already in path. Skipping.'
}

# msys bin
$msys_bin = "C:\msys64\usr\bin"
if( $PATH -notlike "*"+$msys_bin+"*" ){
    echo '  Adding C:\msys64\usr\bin to path'
    .$SCRIPTS_DIR/os/windows/append_user_path.cmd C:\msys64\usr\bin
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

## 
# Install scoop
##
if (!(Test-Path -Path "$($env:USERPROFILE)/scoop/shims/scoop" -PathType Leaf)) {
    irm get.scoop.sh | iex
} else {
    write-host ""
    write-host "Scoop already installed. skipping..."
}

#buckets
scoop bucket add main
scoop bucket add extras

# scoops
scoop install sudo
scoop install msys2
scoop install secureuxtheme
scoop install fastfetch
scoop install oh-my-posh
scoop install git
scoop install github
scoop install git-crypt

##
# Install winget
# https://github.com/microsoft/winget-cli/
##
If(!(Test-CommandExists winget)) {
    write-host "Installing winget"
    $download_url = "https://github.com/microsoft/winget-cli/releases/download/v1.4.10173/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
    $download_save_file = "$($env:USERPROFILE)\Downloads\MicrosoftDesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
    $wc.Downloadfile($download_url, $download_save_file)
    Add-AppXPackage -Path $($env:USERPROFILE)\Downloads\MicrosoftDesktopAppInstaller_8wekyb3d8bbwe.msixbundle
} else {
    write-host "Winget already installed. Skipping..."
}

# Program installations
# winget install --id Microsoft.Powershell.Preview
# winget install --id Microsoft.WindowsTerminal.Preview

##
# Win 11 Theme Patcher
# https://mhoefs.eu/software_count.php
##
if (!(Test-Path -Path "$($env:USERPROFILE)\Downloads\UltraUXThemePatcher.exe" -PathType Leaf)) {
    write-host "Downloading UltraUXThemePatcher..."
    $postParams = @{Uxtheme='UltraUXThemePatcher';id='Uxtheme'}
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri https://mhoefs.eu/software_count.php -OutFile "$($env:USERPROFILE)\Downloads\UltraUXThemePatcher.exe" -Method POST -Body $postParams
    write-host "Downloaded to $($env:USERPROFILE)\Downloads\UltraUXThemePatcher.exe"
    write-host "Patch OS to apply themes"
} else {
    write-host ""
    write-host "UltraUXThemePatcher already downloaded. skipping..."
    write-host "Patch OS to apply custom themes"
}

##
# Enable developer mode
##
write-host "
Enabling developer mode and installing WSL"
.$SCRIPTS_DIR/os/windows/enable_developer_mode.ps1 | Out-Null

##
# Mica for Everyone
# https://github.com/MicaForEveryone/MicaForEveryone/releases/latest
##
if (!(Test-Path -Path "$($env:USERPROFILE)\Downloads\MicaForEveryone-x64-Release.msix" -PathType Leaf)) {
    write-host "
Downloading MicaForEveryone..."
    $download_url = "https://github.com/MicaForEveryone/MicaForEveryone/releases/download/v1.3.0.0/MicaForEveryone-x64-Release.msix"
    $download_save_file = "$($env:USERPROFILE)\Downloads\MicaForEveryone-x64-Release.msix"
    $wc.Downloadfile($download_url, $download_save_file)
    write-host "Downloaded to $($env:USERPROFILE)\Downloads\MicaForEveryone-x64-Release.msix. Installing..."
    Add-AppxPackage -Path "$($env:USERPROFILE)\Downloads\MicaForEveryone-x64-Release.msix" -AllowUnsigned
    write-host "Patch OS to apply themes"
} else {
    write-host ""
    write-host "MicaForEveryone already downloaded. installing..."
    Add-AppxPackage -Path "$($env:USERPROFILE)\Downloads\MicaForEveryone-x64-Release.msix" -AllowUnsigned
    write-host "Patch OS to apply custom themes"
}

##
# Customize windows taskbar
##
write-host "
Customizing the taskbar"
.$SCRIPTS_DIR/os/windows/customize_taskbar.ps1 | Out-Null

##
# Update windows theme
##
write-host "
Installing Explorer Themes" 
.$SCRIPTS_DIR/os/windows/customize_explorer.ps1 "$DOTS_DIR/windows/themes/Explorer/" "$DOTS_DIR/windows/themes/Explorer/catppuccin" | Out-Null

##
# Customize cursor
##
write-host "
Installing Catppuccin-Mocha-Blue-Cursors"
.$SCRIPTS_DIR/os/windows/customize_cursor.ps1 "$DOTS_DIR/windows/themes/Cursor/Catppuccin-Mocha-Blue-Cursors/install.inf" | Out-Null