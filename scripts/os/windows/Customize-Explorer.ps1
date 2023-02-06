using module Message
using module RegistryEntry

##
# Update Windows Taskbar
##
$RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

# Removes Task View from the Taskbar
Set-RegistryEntry -Key 'HideFileExt' -Type "DWORD" -Value '0' -Path $RegPath