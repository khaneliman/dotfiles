# Source Classes
.$REGISTRY_ENTRY_CLASS
.$UPSERT_REGISTRY_ENTRY

##
# Update Windows Taskbar
##

$RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

# # Removes Task View from the Taskbar
$RegistryEntry = [RegistryEntry]::new('ShowTaskViewButton', "DWORD", '0', $RegPath)
Upsert-RegistryEntry -RegistryParameter $RegistryEntry

# # Removes Widgets from the Taskbar
$RegistryEntry = [RegistryEntry]::new('TaskbarDa', "DWORD", '0', $RegPath)
Upsert-RegistryEntry -RegistryParameter $RegistryEntry

# # Removes Chat from the Taskbar
$RegistryEntry = [RegistryEntry]::new('TaskbarMn', "DWORD", '0', $RegPath)
Upsert-RegistryEntry -RegistryParameter $RegistryEntry

# # Default StartMenu alignment 0=Left
$RegistryEntry = [RegistryEntry]::new('TaskbarAl', "DWORD", '0', $RegPath)
Upsert-RegistryEntry -RegistryParameter $RegistryEntry

# # Removes search from the Taskbar
$RegistryEntry = [RegistryEntry]::new('SearchboxTaskbarMode', "DWORD", '0', "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search")
Upsert-RegistryEntry -RegistryParameter $RegistryEntry
