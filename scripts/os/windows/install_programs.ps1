using module RegistryEntry
using module TestCommandExists

# $env:PSModulePath = "$PSHOME/Modules\";

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
    $scoop_buckets = @(
        'main', 'extras', 'versions'
    )

    foreach ($bucket in $scoop_buckets) {
        scoop bucket add $bucket
    }

    # scoops
    $scoop_apps = @(
        'sudo', 'fastfetch', 'pshazz', 'git-crypt', 'vcredist', '1password-cli', 'secureuxtheme', '7tsp', 'archwsl'
    )

    foreach ($app in $scoop_apps) {
        scoop install $app
    }

    # elevated installs
    sudo scoop install windowsdesktop-runtime-lts
} else {
    write-host "    Scoop not installed. Skipping scoop installs..."
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

##
# Winget installations
##
if (Test-CommandExists winget) {
    $winget_apps = @(
        'MSYS2.MSYS2',
        'JanDeDobbeleer.OhMyPosh',
        'Microsoft.Powershell.Preview',
        'Microsoft.WindowsTerminalPreview',
        'Bitsum.ProcessLasso',
        'Git.Git',
        'GitHub.GitHubDesktop',
        'Microsoft.VisualStudioCode',
        'Neovim.Neovim',
        'Microsoft.DotNet.SDK.7',
        'Mozilla.Firefox.DeveloperEdition',
        'AgileBits.1Password',
        'Microsoft.Teams',
        'MicaForEveryone.MicaForEveryone',
        'Rainmeter.Rainmeter',
        'AntibodySoftware.WizTree',
        'Notepad++.Notepad++',
        'Microsoft.Sysinternals.Autoruns',
        'Valve.Steam',
        'HeroicGamesLauncher.HeroicGamesLauncher',
        'StartIsBack.StartAllBack',
        'LGUG2Z.komorebi',
        'AutoHotkey.AutoHotkey'
    )

    foreach ($app in $winget_apps) {
        write-host "    Installing $app..."
        winget install --accept-package-agreements --accept-source-agreements --silent --no-upgrade --id $app
    }
} else {
    write-host "    Winget not installed. Skipping winget installs..."
}

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

## Set komorebi to run on startup
$RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" 
Set-RegistryEntry -Key 'KomorebicOnLogin' -Type "SZ" -Value 'C:\Program Files\komorebi\bin\komorebic.exe start' -Path $RegPath