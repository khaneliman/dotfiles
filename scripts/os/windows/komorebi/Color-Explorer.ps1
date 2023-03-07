using module Message
using module RegistryEntry

#
# ░▀█▀░█░█░█▀▀░█▄█░▀█▀░█▀█░█▀▀
# ░░█░░█▀█░█▀▀░█░█░░█░░█░█░█░█
# ░░▀░░▀░▀░▀▀▀░▀░▀░▀▀▀░▀░▀░▀▀▀
#
##
# Explorer Accent Reg Path
# [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent]
##
$RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent"

Write-Message -Message 'Setting Explorer accent colors...'

# #AccentPalette
# "AccentPalette"=hex:51,58,84,ff,43,49,6e,ff,3a,3f,5e,ff,30,34,4e,ff,26,2a,3f,\
#   ff,1d,1f,2f,ff,0f,10,19,ff,88,17,98,00
$binary = '51,58,84,ff,43,49,6e,ff,3a,3f,5e,ff,30,34,4e,ff,26,2a,3f,ff,1d,1f,2f,ff,0f,10,19,ff,88,17,98,00'
$hexified = $binary.Split(',') | ForEach-Object { "0x$_" }
[string]$hexified = $hexified -join ','
Set-RegistryEntry -Key 'AccentPalette' -Type "BINARY" -Value $hexified -Path $RegPath

#AccenColor Menu Key
# "AccentColorMenu"=dword:ff4e3430
Set-RegistryEntry -Key 'AccentColorMenu' -Type "DWORD" -Value '0xff4e3430' -Path $RegPath

#MotionAccentId_v1.00 Key
# "MotionAccentId_v1.00"=dword:000000db
Set-RegistryEntry -Key 'MotionAccentId_v1.00' -Type "DWORD" -Value '0x000000db' -Path $RegPath

#Start Color Menu Key
# "StartColorMenu"=dword:ff3f2a26
Set-RegistryEntry -Key 'StartColorMenu' -Type "DWORD" -Value '0xff3f2a26' -Path $RegPath

##
# DWM Reg Path
# [HKEY_CURRENT_USER\Software\Microsoft\Windows\DWM]
##
$RegPath = "HKCU:\Software\Microsoft\Windows\DWM"

## Composition
# "Composition"=dword:00000001
Set-RegistryEntry -Key 'Composition' -Type "DWORD" -Value '0x00000001' -Path $RegPath

## ColorizationGlassAttribute
# "ColorizationGlassAttribute"=dword:00000001
Set-RegistryEntry -Key 'ColorizationGlassAttribute' -Type "DWORD" -Value '0x00000001' -Path $RegPath

## AccentColor
# "AccentColor"=dword:ff4e3430
Set-RegistryEntry -Key 'AccentColor' -Type "DWORD" -Value '0xff4e3430' -Path $RegPath

## ColorPrevalence
# "ColorPrevalence"=dword:00000001
Set-RegistryEntry -Key 'ColorPrevalence' -Type "DWORD" -Value '0x00000001' -Path $RegPath

## EnableAeroPeek
# "EnableAeroPeek"=dword:00000001
Set-RegistryEntry -Key 'EnableAeroPeek' -Type "DWORD" -Value '0x00000001' -Path $RegPath

## ColorizationColor
# "ColorizationColor"=dword:c430344e
Set-RegistryEntry -Key 'ColorizationColor' -Type "DWORD" -Value '0xc430344e' -Path $RegPath

## ColorizationColorBalance
# "ColorizationColorBalance"=dword:00000059
Set-RegistryEntry -Key 'ColorizationColorBalance' -Type "DWORD" -Value '0x00000059' -Path $RegPath

## ColorizationAfterglow
# "ColorizationAfterglow"=dword:c430344e
Set-RegistryEntry -Key 'ColorizationAfterglow' -Type "DWORD" -Value '0xc430344e' -Path $RegPath

## ColorizationAfterglowBalance
# "ColorizationAfterglowBalance"=dword:0000000a
Set-RegistryEntry -Key 'ColorizationAfterglowBalance' -Type "DWORD" -Value '0x0000000a' -Path $RegPath

## ColorizationBlurBalance
# "ColorizationBlurBalance"=dword:00000001
Set-RegistryEntry -Key 'ColorizationBlurBalance' -Type "DWORD" -Value '0x00000001' -Path $RegPath

## EnableWindowColorization
# "EnableWindowColorization"=dword:00000001
Set-RegistryEntry -Key 'EnableWindowColorization' -Type "DWORD" -Value '0x00000001' -Path $RegPath

##
# Themes Personalize Reg Path
##
$RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"

# Enable transparency
# "EnableTransparency"=dword:00000001
Write-Message  -Message 'Enabling transparency...'
Set-RegistryEntry -Key 'EnableTransparency' -Type "DWORD" -Value '0x00000001' -Path $RegPath

# Enable colors on start and taskbar
# "ColorPrevalance"=dword:00000001
Write-Message  -Message 'Enabling color on start and taskbar...'
Set-RegistryEntry -Key 'ColorPrevalence' -Type "DWORD" -Value '0x00000001' -Path $RegPath

# Restart explorer
Write-Message -Type WARNING  -Message 'Restarting explorer to apply changes...'
Stop-Process -ProcessName explorer -Force -ErrorAction SilentlyContinue
