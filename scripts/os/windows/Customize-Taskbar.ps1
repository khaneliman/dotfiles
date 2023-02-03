using module RegistryEntry

##
# Update Windows Taskbar
##
$RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

# Removes Task View from the Taskbar
Set-RegistryEntry -Key 'ShowTaskViewButton' -Type "DWORD" -Value '0' -Path $RegPath

# Removes Widgets from the Taskbar
Set-RegistryEntry -Key 'TaskbarDa' -Type "DWORD" -Value '0' -Path $RegPath

# Removes Chat from the Taskbar
Set-RegistryEntry -Key 'TaskbarMn' -Type "DWORD" -Value '0' -Path $RegPath

# Default StartMenu alignment 0=Left
Set-RegistryEntry -Key 'TaskbarAl' -Type "DWORD" -Value '0' -Path $RegPath

$RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"

# Removes search from the Taskbar
Set-RegistryEntry -Key 'SearchboxTaskbarMode' -Type "DWORD" -Value '0' -Path $RegPath
