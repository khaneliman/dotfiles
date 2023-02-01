# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
        Exit
    }
}

# # Windows themes variables
$RESOURCES = "C:\Windows\Resources\Themes"
$objShell = New-Object -ComObject Shell.Application

# # Loop through provided input directories
for ( $i = 0; $i -lt $args.count; $i++ ) {
    write-host "    Checking $($args[$i]) for themes that need to be installed..."
    
    # Current directory being checked
    $Path=$($args[$i])
    $Theme = Get-Item -Path $Path
    
    $ThemeList = Get-ChildItem -Path "$Theme\*" -Include ('*.theme', '*.msstyles')
    $Fontdir = dir $Path

    foreach($File in $ThemeList) {
        $name = $File.baseName
        $extension = $File.extension

        $try = $true
        $objFolder = $objShell.Namespace($RESOURCES)
        $installedThemes = @(Get-ChildItem $RESOURCES | Where-Object {$_.PSIsContainer -eq $false} | Select-Object basename)

        if ($extension -eq ".msstyles") {
            $objFolder = $objShell.Namespace("$RESOURCES\catppuccin")
            
            If(!(test-path -PathType container "$RESOURCES\catppuccin")) {
                New-Item -ItemType Directory -Path "$RESOURCES\catppuccin"
            }
            
            $installedThemes = @(Get-ChildItem "$RESOURCES\catppuccin" | Where-Object {$_.PSIsContainer -eq $false} | Select-Object basename)
        }
    
        foreach($theme in $installedThemes)
        {
            $theme = $theme -replace "_", ""
            $name = $name -replace "_", ""

            if ($theme -match $name)
            {
                $try = $false
            }
        }
        if ($try)
        {
            write-host "    Installing $name"
            $objFolder.CopyHere($File.fullname)
        }
    }
}

# if needed
# $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
# New-Item $regPath -Force | Out-Null
# New-ItemProperty $regPath -Name NoThemesTab -Value 0 -Force | Out-Null

if (Test-Path -Path "C:\Windows\Resources\Themes\catppuccin Mocha Win.theme" -PathType Leaf) {
    write-host "Setting theme to Catppuccin Mocha"
    start-process -filepath "C:\Windows\Resources\Themes\catppuccin Mocha Win.theme" -Wait; timeout /t 3; taskkill /im "systemsettings.exe" /f
} else {
    write-host "Catppuccin Mocha not found in C:\Windows\Resources\Themes\. Skipping..."
}