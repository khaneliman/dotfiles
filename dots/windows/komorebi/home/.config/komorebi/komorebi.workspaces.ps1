# create named workspaces on monitors
$Monitors = Get-CimInstance -Query "SELECT * FROM CIM_DesktopMonitor WHERE Availability = 3"

Write-Host "Number of connected monitors: $($Monitors.Count)"

if ($Monitors.Count -gt 1)
{

  Add-Type -AssemblyName System.Windows.Forms

  $AllScreens = [System.Windows.Forms.Screen]::AllScreens
  $PrimaryScreen = [System.Windows.Forms.Screen]::PrimaryScreen

  $PrimaryMonitorIndex = -1

  for ($i = 0; $i -lt $AllScreens.Length; $i++)
  {
    if ($AllScreens[$i] -eq $PrimaryScreen)
    {
      $PrimaryMonitorIndex = $i
      break
    }
  }

  Write-Host "Primary monitor display index: $PrimaryMonitorIndex"

  & komorebic ensure-named-workspaces $PrimaryMonitorIndex main code

  $Workspaces = @('comms', 'ref', 'productivity')
  $WorkspaceIndex = 0

  for ($i = 0; $i -lt $AllScreens.Length; $i++)
  {
    if ($i -ne $PrimaryMonitorIndex)
    {
      & komorebic ensure-named-workspaces $i $($Workspaces[$WorkspaceIndex])

      $WorkspaceIndex++
      if ($WorkspaceIndex -ge $Workspaces.Length)
      {
        $WorkspaceIndex = 0
      }
    }
  }
} else
{
  & komorebic ensure-named-workspaces 0 main comms code ref productivity
}

# assign layouts to workspaces, possible values: bsp, columns, rows, vertical-stack, horizontal-stack, ultrawide-vertical-stack
komorebic named-workspace-layout main vertical-stack
komorebic named-workspace-layout comms vertical-stack
komorebic named-workspace-layout code bsp
komorebic named-workspace-layout ref bsp
komorebic named-workspace-layout productivity bsp

# set the gaps around the edge of the screen for a workspace
komorebic named-workspace-padding main 10
komorebic named-workspace-padding comms 10
komorebic named-workspace-padding code 10
komorebic named-workspace-padding ref 10
komorebic named-workspace-padding productivity 10

# set the gaps between the containers for a workspace
komorebic named-workspace-container-padding main 10
komorebic named-workspace-container-padding comms 10
komorebic named-workspace-container-padding code 10
komorebic named-workspace-container-padding ref 10
komorebic named-workspace-container-padding productivity 10

# you can assign specific apps to named workspaces
komorebic named-workspace-rule exe "Firefox.exe" main
komorebic named-workspace-rule exe "msedge.exe" main
komorebic named-workspace-rule exe "Chrome.exe" main

komorebic named-workspace-rule exe "Teams.exe" comms
komorebic named-workspace-rule exe "OUTLOOK.exe" comms
komorebic named-workspace-rule exe "Slack.exe" comms
komorebic named-workspace-rule exe "Discord.exe" comms
komorebic named-workspace-rule exe "Skype.exe" comms
komorebic named-workspace-rule exe "Caprine.exe" comms
komorebic named-workspace-rule exe "Telegram.exe" comms
komorebic named-workspace-rule exe "WhatsApp.exe" comms
komorebic named-workspace-rule exe "Signal.exe" comms
komorebic named-workspace-rule exe "Messenger.exe" comms

komorebic named-workspace-rule exe "Code.exe" code
komorebic named-workspace-rule exe "VisualStudio.exe" code
komorebic named-workspace-rule exe "idea64.exe" code
komorebic named-workspace-rule exe "idea.exe" code
komorebic named-workspace-rule exe "AndroidStudio.exe" code

komorebic named-workspace-rule exe "OneNote.exe" ref
komorebic named-workspace-rule exe "Microsoft.OneNote.exe" ref
komorebic named-workspace-rule exe "Microsoft Word.exe" ref
komorebic named-workspace-rule exe "Microsoft Excel.exe" ref
komorebic named-workspace-rule exe "Microsoft PowerPoint.exe" ref
komorebic named-workspace-rule exe "GitHubDesktop.exe" ref
komorebic named-workspace-rule exe "GitKraken.exe" ref
komorebic named-workspace-rule exe "Sourcetree.exe" ref

komorebic named-workspace-rule exe "Microsoft To Do.exe" productivity
komorebic named-workspace-rule exe "notepad.exe" productivity
komorebic named-workspace-rule exe "notepad++.exe" productivity
