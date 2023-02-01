$env:PSModulePath = "$PSHOME/Modules\";

## 
# Install scoop
##
if (!(Test-Path -Path "$($env:USERPROFILE)/scoop/shims/scoop" -PathType Leaf)) {
    irm get.scoop.sh | iex
} else {
    write-host ""
    write-host "Scoop already installed. skipping..."
}

if (Test-CommandExists scoop) {

    # buckets
    scoop bucket add main
    scoop bucket add extras
    scoop bucket add versions

    # scoops
    scoop install sudo
    scoop install msys2
    scoop install secureuxtheme
    scoop install fastfetch
    scoop install oh-my-posh
    scoop install git
    scoop install github
    scoop install git-crypt
    scoop install micaforeveryone
    sudo scoop install windowsdesktop-runtime-lts
    scoop install dotnet-sdk
    scoop install vcredist
    scoop install pshazz
    scoop install 7tsp
}

##
# Install winget
# https://github.com/microsoft/winget-cli/
##
if ( !(Test-CommandExists winget)) {
    write-host ""
    write-host "Installing winget"
    $download_url = "https://github.com/microsoft/winget-cli/releases/download/v1.4.10173/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
    $download_save_file = "$($env:USERPROFILE)\Downloads\MicrosoftDesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
    $wc.Downloadfile($download_url, $download_save_file)
    Add-AppXPackage -Path $($env:USERPROFILE)\Downloads\MicrosoftDesktopAppInstaller_8wekyb3d8bbwe.msixbundle
} else {
    write-host ""
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
} else {
    write-host ""
    write-host "MicaForEveryone already downloaded. Skipping..."
}