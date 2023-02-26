using module Message

function Backup-Files {
    param (
	    [Parameter(Mandatory=$true)] [string]$BackupFolderPath,
        [Parameter(Mandatory=$true)] [string]$Target
    )

    $backupRelativeFolderPath = $Target.Replace("${env:USERPROFILE}","")
    $BackupFolderPath = $BackupFolderPath + $backupRelativeFolderPath
    $BackupFolderPath = Split-Path -parent $BackupFolderPath
    
    New-Item $BackupFolderPath -ItemType Directory -Force

    Write-Message -Message (-join("Backing up existing files found at: ", $Target))

    Copy-Item -Path $Target -Destination $BackupFolderPath -Recurse -Force

    Write-Message -Type SUCCESS -Message (-join("Successfully backed up  to: ", $BackupFolderPath))
}