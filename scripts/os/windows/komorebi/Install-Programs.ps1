using module RegistryEntry
using module TestCommandExists

$env:PSModulePath = "$PSHOME/Modules\"+";$SCRIPTS_DIR/os/windows/modules";

##
# Winget installations
##
if (Test-CommandExists winget)
{
    $winget_apps = @(
        'JanDeDobbeleer.OhMyPosh',
        'MicaForEveryone.MicaForEveryone',
        'Rainmeter.Rainmeter',
        'StartIsBack.StartAllBack',
        'LGUG2Z.komorebi',
        'AutoHotkey.AutoHotkey',
        'Lexikos.AutoHotkey'
    )

    foreach ($app in $winget_apps)
    {
        write-host "    Installing $app..."
        winget install --accept-package-agreements --accept-source-agreements --silent --no-upgrade --id $app
    }
} else
{
    write-host -Foreground yellow "    Winget not installed. Skipping winget installs..."
}

##
# Win 11 Theme Patcher
# https://mhoefs.eu/software_count.php
##
if (!(Test-Path -Path "$($env:USERPROFILE)\Downloads\UltraUXThemePatcher.exe" -PathType Leaf))
{
    write-host "Downloading UltraUXThemePatcher..."
    $postParams = @{Uxtheme='UltraUXThemePatcher';id='Uxtheme'}
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri https://mhoefs.eu/software_count.php -OutFile "$($env:USERPROFILE)\Downloads\UltraUXThemePatcher.exe" -Method POST -Body $postParams
    write-host "Downloaded to $($env:USERPROFILE)\Downloads\UltraUXThemePatcher.exe"
    write-host -Foreground yellow "Patch OS to apply themes"
} else
{
    write-host ""
    write-host -Foreground yellow"UltraUXThemePatcher already downloaded. skipping..."
    write-host -Foreground yellow "Patch OS to apply custom themes"
}

## Set komorebi to run on startup
$RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" 
Set-RegistryEntry -Key 'KomorebicOnLogin' -Type "String" -Value 'C:\Program Files\komorebi\bin\komorebic.exe start --await-configuration' -Path $RegPath

Set-RegistryEntry -Key 'KomorebicConfigOnLogin' -Type "String" -Value "$($env:USERPROFILE)\.config\komorebi\komorebi.ahk" -Path $RegPath
