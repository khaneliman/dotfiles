using module Message
using module ConfigMap

# Powershell Variables
$objShell = New-Object -ComObject Shell.Application
$timestamp = Get-Date -Format o | ForEach-Object { $_ -replace ":", "." }
$ConfigMap = Get-ConfigMap

# Loop through provided input directories
foreach ( $config in $ConfigMap )
{   
    if ($config.RequiresUnlock -eq $true -and $GIT_CRYPT_LOCKED -eq $true)
    {
        Write-Message -Type WARNING -Message (-join($config.Source, "is encrypted. Skipping..."))
        continue
    } 

    $backupFolderPath = "${env:USERPROFILE}\.config\dotfiles-backup\$timestamp"
    $destinationExists = Test-Path -Path $config.Destination

    if ($destinationExists -eq $true)
    {
        if ((get-item $config.Destination).Attributes.ToString() -match "ReparsePoint")
        {
            Write-Message -Type WARNING -Message (-join($config.Destination, "is already a symbolic link. Skipping..."))
            Write-Message -Type WARNING -Message "If you'd like to replace this location... delete your existing link and run again."
            continue
        } 

        $backupRelativeFolderPath = $config.Destination.Replace("${env:USERPROFILE}","")
        $backupFolderPath = $backupFolderPath + $backupRelativeFolderPath
        $backupFolderPath = Split-Path -parent $backupFolderPath
        New-Item $backupFolderPath -ItemType Directory -Force
        $backupFolder = $objShell.Namespace($backupFolderPath)

        Write-Message -Message (-join("    ", $config.Destination, "already exists. Backing up existing files..."))
        $backupFolder.CopyHere($config.Destination, 0x14)
        
        if ($config.ReplaceExisting)
        {
            if ($config.CreateSymbolicLink -eq $true) 
            {
                Write-Message  -Message (-join("    Deleting ", $config.Destination))
                Remove-Item -Path $config.Destination -Recurse -Force
            }
        } else
        {
            Write-Message -Type WARNING  -Message "    Config already exists. Skipping..."
            continue
        }
    } 

    $destinationFolderPath = Split-Path -parent $config.Destination
    
    if ($config.CreateSymbolicLink -eq $true)
    {
        Write-Message  -Message (-join("    Creating link to ", $config.Source, "at", $config.Destination))
        
        New-Item -ItemType Directory -Force -Path $destinationFolderPath

        sudo New-Item -ItemType SymbolicLink -Path $config.Destination -Target $config.Source
    } else
    {
        Write-Message  -Message (-join("    Copying", $config.Source, "files to", $destinationFolderPath))

        New-Item -ItemType Directory -Force -Path $destinationFolderPath

        Copy-Item -Path $config.Source -Destination $config.Destination -Recurse -Force
        
        # TODO: Move to komorebi specific script 
        if ($config.Source -match "btop.conf")
        {
            $btop_theme_path = "${env:USERPROFILE}\scoop\apps\btop\current\themes\catppuccin_macchiato.theme"
            $regex = "color_theme = .*"
            $replacement = "color_theme = $btop_theme_path"

            (Get-Content $config.Destination) | 
                ForEach-Object { $_ -replace $regex, $replacement } |
                Set-Content $config.Destination
        }
    }
}
