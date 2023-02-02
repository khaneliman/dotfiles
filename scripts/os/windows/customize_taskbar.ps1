##
# Update Windows Taskbar
##

$RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

# Removes Task View from the Taskbar
$ShowTaskViewButton = @{
	Key   = 'ShowTaskViewButton';
	Type  = "DWORD";
	Value = '0'
}

write-host "
Setting ShowTaskViewButton" $ShowTaskViewButton.Value

If ($Null -eq (Get-ItemProperty -Path $RegPath -Name $ShowTaskViewButton.Key -ErrorAction SilentlyContinue))
{
	New-ItemProperty -Path $RegPath -Name $ShowTaskViewButton.Key -Value $ShowTaskViewButton.Value -PropertyType $ShowTaskViewButton.Type -Force
}
Else
{
	Set-ItemProperty -Path $RegPath -Name $ShowTaskViewButton.Key -Value $ShowTaskViewButton.Value -Force
}

# Removes Widgets from the Taskbar
$TaskbarDa = @{
	Key   = 'TaskbarDa';
	Type  = "DWORD";
	Value = '0'
}

write-host "
Setting TaskbarDa" $TaskbarDa.Value

If ($Null -eq (Get-ItemProperty -Path $RegPath -Name $TaskbarDa.Key -ErrorAction SilentlyContinue))
{
	New-ItemProperty -Path $RegPath -Name $TaskbarDa.Key -Value $TaskbarDa.Value -PropertyType $TaskbarDa.Type -Force
}
Else
{
	Set-ItemProperty -Path $RegPath -Name $TaskbarDa.Key -Value $TaskbarDa.Value -Force
}

# Removes Chat from the Taskbar
$TaskbarMn = @{
	Key   = 'TaskbarMn';
	Type  = "DWORD";
	Value = '0'
}

write-host "
Setting TaskbarMn" $TaskbarMn.Value

If ($Null -eq (Get-ItemProperty -Path $RegPath -Name $TaskbarMn.Key -ErrorAction SilentlyContinue))
{
	New-ItemProperty -Path $RegPath -Name $TaskbarMn.Key -Value $TaskbarMn.Value -PropertyType $TaskbarMn.Type -Force
}
Else
{
	Set-ItemProperty -Path $RegPath -Name $TaskbarMn.Key -Value $TaskbarMn.Value -Force
}

# Default StartMenu alignment 0=Left
$TaskbarAl = @{
	Key   = 'TaskbarAl';
	Type  = "DWORD";
	Value = '0'
}

write-host "
Setting TaskbarAl" $TaskbarAl.Value

If ($Null -eq (Get-ItemProperty -Path $RegPath -Name $TaskbarAl.Key -ErrorAction SilentlyContinue))
{
	New-ItemProperty -Path $RegPath -Name $TaskbarAl.Key -Value $TaskbarAl.Value -PropertyType $TaskbarAl.Type -Force
}
Else
{
	Set-ItemProperty -Path $RegPath -Name $TaskbarAl.Key -Value $TaskbarAl.Value -Force
}

$RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"

# Removes search from the Taskbar
$SearchboxTaskbarMode = @{
	Key   = 'SearchboxTaskbarMode';
	Type  = "DWORD";
	Value = '0'
}

write-host "
Setting SearchboxTaskbarMode" $SearchboxTaskbarMode.Value

If ($Null -eq (Get-ItemProperty -Path $RegPath -Name $SearchboxTaskbarMode.Key -ErrorAction SilentlyContinue))
{
	New-ItemProperty -Path $RegPath -Name $SearchboxTaskbarMode.Key -Value $SearchboxTaskbarMode.Value -PropertyType $SearchboxTaskbarMode.Type -Force
}
Else
{
	Set-ItemProperty -Path $RegPath -Name $SearchboxTaskbarMode.Key -Value $SearchboxTaskbarMode.Value -Force
}
