using module ElevateScript
using module Message

function New-SymbolicLink {
    param (
	    [Parameter(Mandatory=$true)] [string]$Target,
        [Parameter(Mandatory=$true)] [string]$Path
    )

    Write-Message  -Message (-join("Creating link to ", $Target, " at ", $Path))

    $destinationFolderPath = Split-Path -parent $Path

    New-Item -ItemType Directory -Force -Path $destinationFolderPath
    
    Request-ElevateCommand -Command "New-Item -ItemType SymbolicLink -Path $Path -Target $Target"
}