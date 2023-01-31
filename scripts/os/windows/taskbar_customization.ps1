# Self-elevate the script if required
# if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
#     if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
#         $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
#         Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
#         # Exit
#     }
# }

write-host "
Customizing the taskbar"
##
# Update Windows Taskbar
##
# REG LOAD HKU\$($env:USERPROFILE) C:\Users\$env:USERPROFILE\NTUSER.DAT
 
# Removes Task View from the Taskbar
Set-itemproperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value "0"
 
# Removes Widgets from the Taskbar
Set-itemproperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarDa" -Value "0"
 
# Removes Chat from the Taskbar
Set-itemproperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarMn" -Value "0"
 
# Default StartMenu alignment 0=Left
Set-itemproperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAl" -Value "0"
 
# Removes search from the Taskbar
Set-itemproperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value "0"
 
# REG UNLOAD HKU\$($env:USERPROFILE)