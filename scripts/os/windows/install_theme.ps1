using module ElevateScript

# Self-elevate the script if required
Request-ElevateScript

# # Windows themes variables
$RESOURCES = "C:\Windows\Resources\Themes"
$objShell = New-Object -ComObject Shell.Application

# Loop through provided input directories
for ( $i = 0; $i -lt $args.count; $i++ ) {
    write-host "    Checking $($args[$i]) for files that need to be installed..."
    
    # Current directory being checked
    $Path=$($args[$i])
    $Theme = Get-Item -Path $Path
    
    $ThemeList = Get-ChildItem -Path "$Theme\*" -Include ('*.theme', '*.msstyles', '*.dll', '*.png')

    foreach($File in $ThemeList) {
        $name = $File.baseName
        $extension = $File.extension

        $try = $true
        $objFolder = $objShell.Namespace($RESOURCES)
        $installedItems = @(Get-ChildItem $RESOURCES | Where-Object {$_.PSIsContainer -eq $false} | Select-Object basename)

        if ($extension -eq ".msstyles") {
            $objFolder = $objShell.Namespace("$RESOURCES\catppuccin")
            
            If(!(test-path -PathType container "$RESOURCES\catppuccin")) {
                New-Item -ItemType Directory -Path "$RESOURCES\catppuccin"
            }
            
            $installedItems = @(Get-ChildItem "$RESOURCES\catppuccin" | Where-Object {$_.PSIsContainer -eq $false} | Select-Object basename)
        }

		if ($extension -eq ".dll") {
            $objFolder = $objShell.Namespace("$RESOURCES\catppuccin\Shell\NormalColor")
            
            If(!(test-path -PathType container "$RESOURCES\catppuccin\Shell\NormalColor")) {
                New-Item -ItemType Directory -Path "$RESOURCES\catppuccin\Shell\NormalColor"
            }
            
            $installedItems = @(Get-ChildItem "$RESOURCES\catppuccin\Shell\NormalColor" | Where-Object {$_.PSIsContainer -eq $false} | Select-Object basename)
        }
    
		if ($extension -eq ".png") {
            $objFolder = $objShell.Namespace("$RESOURCES\catppuccin\wallpapers")
            
            If(!(test-path -PathType container "$RESOURCES\catppuccin\wallpapers")) {
                New-Item -ItemType Directory -Path "$RESOURCES\catppuccin\wallpapers"
            }
            
            $installedItems = @(Get-ChildItem "$RESOURCES\catppuccin\wallpapers" | Where-Object {$_.PSIsContainer -eq $false} | Select-Object basename)
        }

        foreach($item in $installedItems)
        {
            $item = $item -replace "_", ""
            $name = $name -replace "_", ""

            if ($item -match $name)
            {
                $try = $false
            }
        }
        if ($try)
        {
            write-host "    Installing $name from $File"
            $objFolder.CopyHere($File.fullname)
        }
    }
}

# # if needed
# $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
# New-Item $regPath -Force | Out-Null
# New-ItemProperty $regPath -Name NoThemesTab -Value 0 -Force | Out-Null

if (Test-Path -Path "$RESOURCES\Catppuccin-Mocha.theme" -PathType Leaf) {
    $currentTheme=(Get-ItemProperty -path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\ -Name "CurrentTheme").CurrentTheme
    if ($currentTheme -eq "$RESOURCES\Catppuccin-Mocha.theme") {
        write-host "Theme already set to Catppuccin Mocha. Skipping..."
    } else {
        write-host "Setting theme to Catppuccin Mocha"
        start-process -filepath "$RESOURCES\Catppuccin-Mocha.theme"; timeout /t 3; taskkill /im "systemsettings.exe" /f
    }
} else {
    write-host "Catppuccin Mocha not found in $RESOURCES\. Skipping..."
}
