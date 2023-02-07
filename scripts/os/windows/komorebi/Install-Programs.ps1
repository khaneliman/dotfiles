using module Message
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
        Write-Message  -Message "    Installing $app..."
        winget install --accept-package-agreements --accept-source-agreements --silent --no-upgrade --id $app
    }
} else
{
    Write-Message -Type WARNING  -Message "    Winget not installed. Skipping winget installs..."
}

##
# Win 11 Theme Patcher
# https://mhoefs.eu/software_count.php
##
if (!(Test-Path -Path "$($env:USERPROFILE)\Downloads\UltraUXThemePatcher.exe" -PathType Leaf))
{
    Write-Message "Downloading UltraUXThemePatcher..."
    $postParams = @{Uxtheme='UltraUXThemePatcher';id='Uxtheme'}
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri https://mhoefs.eu/software_count.php -OutFile "$($env:USERPROFILE)\Downloads\UltraUXThemePatcher.exe" -Method POST -Body $postParams
    Write-Message  -Message "Downloaded to $($env:USERPROFILE)\Downloads\UltraUXThemePatcher.exe"
    Write-Message -Type WARNING  -Message "Patch OS to apply themes"
} else
{
    Write-Host ""
    Write-Message -Type WARNING  -Message "UltraUXThemePatcher already downloaded. skipping..."
    Write-Message -Type WARNING  -Message "Patch OS to apply custom themes"
}

## Set komorebi to run on startup
$RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" 

Write-Message -Message "Setting komorebi to start on login"
Set-RegistryEntry -Key 'KomorebicOnLogin' -Type "String" -Value 'C:\Program Files\komorebi\bin\komorebic.exe start --await-configuration' -Path $RegPath

Write-Message -Message "Setting komorebi config to load on login"
Set-RegistryEntry -Key 'KomorebicConfigOnLogin' -Type "String" -Value "$($env:USERPROFILE)\.config\komorebi\komorebi.ahk" -Path $RegPath
