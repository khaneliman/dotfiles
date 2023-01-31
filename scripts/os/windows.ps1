# Variables setup
$GIT_DIR = git rev-parse --show-toplevel
$DOTS_DIR = $GIT_DIR+"/dots"
$SCRIPTS_DIR = $GIT_DIR+"/scripts"

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
    ./windows/append_user_path.cmd %USERPROFILE%\.local\bin\
} else {
    echo '  ~/.local/bin already in path. Skipping.'
}

# msys bin
$msys_bin = "C:\msys64\usr\bin"
if( $PATH -notlike "*"+$msys_bin+"*" ){
    echo '  Adding C:\msys64\usr\bin to path'
    ./windows/append_user_path.cmd C:\msys64\usr\bin
} else {
    echo '  C:\msys64\usr\bin already in path. Skipping.'
}

##
# Install fonts
##
echo '
Installing fonts'
./windows/install_fonts.ps1 $DOTS_DIR"/shared/home/.fonts/SanFransisco"
# $fonts = (New-Object -ComObject Shell.Application).Namespace(0x14)
# Get-ChildItem -Recurse -Path $DOTS_DIR"/shared/home/.fonts/SanFransisco" -Include *.otf | % { $fonts.CopyHere($_.fullname) }

##
# Install software
##

# install winget
# Invoke-WebRequest -Uri https://github.com/microsoft/winget-cli/releases/download/v1.4.10173/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle -OutFile $($env:USERPROFILE)\Downloads\MicrosoftDesktopAppInstaller_8wekyb3d8bbwe.msixbundle
# Add-AppXPackage -Path $($env:USERPROFILE)\Downloads\MicrosoftDesktopAppInstaller_8wekyb3d8bbwe.msixbundle

# Program installations
# winget install --id MSYS2.MSYS2
# winget install --id git.git
# winget install --id Microsoft.Powershell.Preview
# winget install --id Microsoft.WindowsTerminal.Preview
# winget install --id JanDeDobbeleer.OhMyPosh -s winget
# winget install --id GitHub.GitHubDesktop

# git clone --recurse-submodules https://github.com/khaneliman/dotfiles.git ~/.config/.dotfiles

# Win 11 Theme Patcher
if (!(Test-Path -Path "$($env:USERPROFILE)\Downloads\UltraUXThemePatcher.exe" -PathType Leaf)) {
    write-host "Downloading UltraUXThemePatcher..."
    $postParams = @{Uxtheme='UltraUXThemePatcher';id='Uxtheme'}
    Invoke-WebRequest -Uri https://mhoefs.eu/software_count.php -OutFile "$($env:USERPROFILE)\Downloads\UltraUXThemePatcher.exe" -Method POST -Body $postParams
    write-host "Downloaded to $($env:USERPROFILE)\Downloads\UltraUXThemePatcher.exe"
    write-host "Patch OS to apply themes"
}

# Update windows theme
# start-process -filepath "C:\Windows\Resources\Themes\dark.theme"; timeout /t 3; taskkill /im "systemsettings.exe" /f

./windows/taskbar_customization.ps1