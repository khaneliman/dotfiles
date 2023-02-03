using module ConfigMap

# Variables
$objShell = New-Object -ComObject Shell.Application
$timestamp = Get-Date -Format o | ForEach-Object { $_ -replace ":", "." }
$backupFolderPath = "${env:USERPROFILE}\.config\dotfiles-backup\$timestamp"
$ConfigMap = Get-ConfigMap

# Loop through provided input directories
foreach ( $config in $ConfigMap ) {
    # ConvertTo-Json $config
    $destinationExists = Test-Path -Path $config.Destination

    if ($destinationExists -eq $true) {
        
        if (!(Test-Path -Path $backupFolderPath)) {
            write-host "Creating $backupFolderPath"
            New-Item $backupFolderPath -ItemType Directory -Force
            $backupFolder = $objShell.Namespace($backupFolderPath)
        }

        write-host "    " $config.Destination "already exists. Backing up existing files..."
        $backupFolder.CopyHere($config.Destination, 0x14)
        
        if ($config.ReplaceExisting) {
            write-host "    Deleting " $config.Destination
            Remove-Item -Path $config.Destination -Force

            if ($config.CreateSymbolicLink -eq $true) {
            write-host "    Creating link to " $config.Source "from" $config.Destination
            sudo New-Item -ItemType SymbolicLink -Path $config.Destination -Target $config.Source
            } else {
                write-host "    Copying files from to" $config.Destination
            }

        } else {
            write-host "    Config already exists. Skipping..."
            continue
        }

    } else {
        if ($config.CreateSymbolicLink -eq $true) {
            write-host "    Creating link to " $config.Source "from" $config.Destination
            sudo New-Item -ItemType SymbolicLink -Path $config.Destination -Target $config.Source
        } else {
            write-host "    Copying files from to" $config.Destination
        }
    }
}
