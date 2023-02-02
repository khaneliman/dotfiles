# Self-elevate the script if required
.$ELEVATE_SCRIPT
.$REGISTRY_ENTRY_CLASS
.$UPSERT_REGISTRY_ENTRY

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

##
# Explorer Accent Reg Path
# [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent]
##
$RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent"

#Accent Palette Key
# "AccentPalette"=hex:51,58,84,ff,43,49,6e,ff,3a,3f,5e,ff,30,34,4e,ff,26,2a,3f,\
#   ff,1d,1f,2f,ff,0f,10,19,ff,88,17,98,00
$binary = '51,58,84,ff,43,49,6e,ff,3a,3f,5e,ff,30,34,4e,ff,26,2a,3f,ff,1d,1f,2f,ff,0f,10,19,ff,88,17,98,00'
$hexified = $binary.Split(',') | ForEach-Object { "0x$_" }

$RegistryEntry = [RegistryEntry]::new('AccentPalette', "BINARY", $hexified, $RegPath)
Upsert-RegistryEntry -RegistryParameter $RegistryEntry

#Accent Color Menu Key
# "AccentColorMenu"=dword:ff4e3430
$RegistryEntry = [RegistryEntry]::new('AccentColorMenu', "DWORD", '0xff4e3430', $RegPath)
Upsert-RegistryEntry -RegistryParameter $RegistryEntry

#MotionAccentId_v1.00 Key
# "MotionAccentId_v1.00"=dword:000000db
$RegistryEntry = [RegistryEntry]::new('MotionAccentId_v1.00', "DWORD", '0x000000db', $RegPath)
Upsert-RegistryEntry -RegistryParameter $RegistryEntry

#Start Color Menu Key
# "StartColorMenu"=dword:ff3f2a26
$RegistryEntry = [RegistryEntry]::new('StartColorMenu', "DWORD", '0xff3f2a26', $RegPath)
Upsert-RegistryEntry -RegistryParameter $RegistryEntry

##
# DWM Reg Path
# [HKEY_CURRENT_USER\Software\Microsoft\Windows\DWM]
##
$RegPath = "HKCU:\Software\Microsoft\Windows\DWM"

## Composition
# "Composition"=dword:00000001
$RegistryEntry = [RegistryEntry]::new('Composition', "DWORD", '0x00000001', $RegPath)
Upsert-RegistryEntry -RegistryParameter $RegistryEntry

## ColorizationGlassAttribute
# "ColorizationGlassAttribute"=dword:00000001
$RegistryEntry = [RegistryEntry]::new('ColorizationGlassAttribute', "DWORD", '0x00000001', $RegPath)
Upsert-RegistryEntry -RegistryParameter $RegistryEntry

## AccentColor
# "AccentColor"=dword:ff4e3430
$RegistryEntry = [RegistryEntry]::new('AccentColor', "DWORD", '0xff4e3430', $RegPath)
Upsert-RegistryEntry -RegistryParameter $RegistryEntry

## ColorPrevalence
# "ColorPrevalence"=dword:00000001
$RegistryEntry = [RegistryEntry]::new('ColorPrevalence', "DWORD", '0x00000001', $RegPath)
Upsert-RegistryEntry -RegistryParameter $RegistryEntry

## EnableAeroPeek
# "EnableAeroPeek"=dword:00000001
$RegistryEntry = [RegistryEntry]::new('EnableAeroPeek', "DWORD", '0x00000001', $RegPath)
Upsert-RegistryEntry -RegistryParameter $RegistryEntry

## ColorizationColor
# "ColorizationColor"=dword:c430344e
$RegistryEntry = [RegistryEntry]::new('ColorizationColor', "DWORD", '0xc430344e', $RegPath)
Upsert-RegistryEntry -RegistryParameter $RegistryEntry

## ColorizationColorBalance
# "ColorizationColorBalance"=dword:00000059
$RegistryEntry = [RegistryEntry]::new('ColorizationColorBalance', "DWORD", '0x00000059', $RegPath)
Upsert-RegistryEntry -RegistryParameter $RegistryEntry

## ColorizationAfterglow
# "ColorizationAfterglow"=dword:c430344e
$RegistryEntry = [RegistryEntry]::new('ColorizationAfterglow', "DWORD", '0xc430344e', $RegPath)
Upsert-RegistryEntry -RegistryParameter $RegistryEntry

## ColorizationAfterglowBalance
# "ColorizationAfterglowBalance"=dword:0000000a
$RegistryEntry = [RegistryEntry]::new('ColorizationAfterglowBalance', "DWORD", '0x0000000a', $RegPath)
Upsert-RegistryEntry -RegistryParameter $RegistryEntry

## ColorizationBlurBalance
# "ColorizationBlurBalance"=dword:00000001
$RegistryEntry = [RegistryEntry]::new('ColorizationBlurBalance', "DWORD", '0x00000001', $RegPath)
Upsert-RegistryEntry -RegistryParameter $RegistryEntry

## EnableWindowColorization
# "EnableWindowColorization"=dword:00000001
$RegistryEntry = [RegistryEntry]::new('EnableWindowColorization', "DWORD", '0x00000001', $RegPath)
Upsert-RegistryEntry -RegistryParameter $RegistryEntry

##
# Themes Personalize Reg Path
##
$RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"

# Enable transparency
$RegistryEntry = [RegistryEntry]::new('EnableTransparency', "DWORD", '0x00000001', $RegPath)
Upsert-RegistryEntry -RegistryParameter $RegistryEntry

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

# Restart explorer
Stop-Process -ProcessName explorer -Force -ErrorAction SilentlyContinue