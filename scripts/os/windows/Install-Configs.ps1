using module ConfigMap

# Powershell Variables
$objShell = New-Object -ComObject Shell.Application
$timestamp = Get-Date -Format o | ForEach-Object { $_ -replace ":", "." }
$ConfigMap = Get-ConfigMap

# WSL Variables
$WSL_HOME = ${env:USERPROFILE}.Replace("\","/").Replace("C:/","/mnt/c/")
$backupFolderPath = "$WSL_HOME\.config\dotfiles-backup\$timestamp"
$WSL_BACKUP_FOLDER_PATH = $backupFolderPath.Replace("\","/")
$WSL_DOTS_DIR = $DOTS_DIR.Replace("C:/","/mnt/c/")

# Loop through provided input directories
foreach ( $config in $ConfigMap )
{   
    $backupFolderPath = "${env:USERPROFILE}\.config\dotfiles-backup\$timestamp"
    $destinationExists = Test-Path -Path $config.Destination

    if ($destinationExists -eq $true)
    {
        if ((get-item $config.Destination).Attributes.ToString() -match "ReparsePoint") {
            write-host $config.Destination "is already a symbolic link. Skipping..."
            write-host "If you'd like to replace this location... delete your existing link and run again."
            continue
        } 

        $backupRelativeFolderPath = $config.Destination.Replace("${env:USERPROFILE}","")
        $backupFolderPath = $backupFolderPath + $backupRelativeFolderPath
        $backupFolderPath = Split-Path -parent $backupFolderPath
        New-Item $backupFolderPath -ItemType Directory -Force
        $backupFolder = $objShell.Namespace($backupFolderPath)

        write-host "    " $config.Destination "already exists. Backing up existing files..."
        $backupFolder.CopyHere($config.Destination, 0x14)
        
        if ($config.ReplaceExisting)
        {
            if ($config.CreateSymbolicLink -eq $true) 
            {
                write-host "    Deleting " $config.Destination
                Remove-Item -Path $config.Destination -Recurse -Force
            }
        } else
        {
            write-host "    Config already exists. Skipping..."
            continue
        }

    } 
    
    if ($config.CreateSymbolicLink -eq $true)
    {
        write-host "    Creating link to " $config.Source "at" $config.Destination
        sudo New-Item -ItemType SymbolicLink -Path $config.Destination -Target $config.Source
    } else
    {
        write-host "    Copying files to" $config.Destination
        $destinationFolderPath = Split-Path -parent $config.Destination
        $destinationFolderPath = $destinationFolderPath.Replace("\","/").Replace("C:/","/mnt/c/")
        $WSL_DESTINATION = $config.Destination.Replace("\","/").Replace("C:/","/mnt/c/")
        $WSL_SOURCE = $config.Source.Replace("\","/").Replace("C:/","/mnt/c/")

        wsl bash -c "mkdir -p $destinationFolderPath"
        wsl bash -c "cp -rv $WSL_SOURCE $WSL_DESTINATION"

        if ($config.Source -match "btop.conf") {
            $btop_theme_path = "${env:USERPROFILE}\scoop\apps\btop\current\themes\catppuccin_macchiato.theme".Replace("\","\\\\")
            wsl -- sed -i "s/color_theme = .*/color_theme = $btop_theme_path/" $WSL_DESTINATION
        }
    }
}

##
# Use existing shared.sh script for config.
##
# wsl bash -c "BACKUP_LOCATION=$WSL_BACKUP_FOLDER_PATH; DOTS_DIR=$WSL_DOTS_DIR; HOME=$WSL_HOME; source ./scripts/utils/installer-helper.sh; source ./scripts/shared.sh; shared_theme_install;"