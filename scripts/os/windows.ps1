# Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser

# Check path and Update path if needed
$PATH = [Environment]::GetEnvironmentVariable("PATH", "User")
$local_bin = "$($env:USERPROFILE)\.local\bin\"
if( $PATH -notlike "*"+$local_bin+"*" ){
    echo 'Adding ~/.local/bin to path'
    ./windows/append_user_path.cmd %USERPROFILE%\.local\bin\
}

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

# Update windows theme
# start-process -filepath "C:\Windows\Resources\Themes\dark.theme"; timeout /t 3; taskkill /im "systemsettings.exe" /f