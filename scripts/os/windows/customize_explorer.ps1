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

# Loop through provided input directories
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

##
# Explorer Accent Reg Path
##
$RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent"

#Accent Color Menu Key
$AccentColorMenuKey = @{
	Key   = 'AccentColorMenu';
	Type  = "DWORD";
	Value = '0xff4e3430'
}

write-host "
Setting AccentColorMenu" $AccentColorMenuKey.Value

If ($Null -eq (Get-ItemProperty -Path $RegPath -Name $AccentColorMenuKey.Key -ErrorAction SilentlyContinue))
{
	New-ItemProperty -Path $RegPath -Name $AccentColorMenuKey.Key -Value $AccentColorMenuKey.Value -PropertyType $AccentColorMenuKey.Type -Force
}
Else
{
	Set-ItemProperty -Path $RegPath -Name $AccentColorMenuKey.Key -Value $AccentColorMenuKey.Value -Force
}

#Accent Palette Key
$AccentPaletteKey = @{
	Key   = 'AccentPalette';
	Type  = "BINARY";
	Value = '51,58,84,ff,43,49,6e,ff,3a,3f,5e,ff,30,34,4e,ff,26,2a,3f,ff,1d,1f,2f,ff,0f,10,19,ff,88,17,98,00'
}
$hexified = $AccentPaletteKey.Value.Split(',') | ForEach-Object { "0x$_" }

write-host "
Setting AccentPalette" $AccentPaletteKey.Value
write-host "
hexified: $hexified".Value

If ($Null -eq (Get-ItemProperty -Path $RegPath -Name $AccentPaletteKey.Key -ErrorAction SilentlyContinue))
{
	New-ItemProperty -Path $RegPath -Name $AccentPaletteKey.Key -PropertyType Binary -Value ([byte[]]$hexified)
}
Else
{
	Set-ItemProperty -Path $RegPath -Name $AccentPaletteKey.Key -Value ([byte[]]$hexified) -Force
}

#MotionAccentId_v1.00 Key
$MotionAccentIdKey = @{
	Key   = 'MotionAccentId_v1.00';
	Type  = "DWORD";
	Value = '0x000000db'
}

write-host "
Setting MotionAccentId_v1" $MotionAccentIdKey.Value


If ($Null -eq (Get-ItemProperty -Path $RegPath -Name $MotionAccentIdKey.Key -ErrorAction SilentlyContinue))
{
	New-ItemProperty -Path $RegPath -Name $MotionAccentIdKey.Key -Value $MotionAccentIdKey.Value -PropertyType $MotionAccentIdKey.Type -Force
}
Else
{
	Set-ItemProperty -Path $RegPath -Name $MotionAccentIdKey.Key -Value $MotionAccentIdKey.Value -Force
}

#Start Color Menu Key
$StartMenuKey = @{
	Key   = 'StartColorMenu';
	Type  = "DWORD";
	Value = '0xff3f2a26'
}

write-host "
Setting StartColorMenu" $StartMenuKey.Value

If ($Null -eq (Get-ItemProperty -Path $RegPath -Name $StartMenuKey.Key -ErrorAction SilentlyContinue))
{
	New-ItemProperty -Path $RegPath -Name $StartMenuKey.Key -Value $StartMenuKey.Value -PropertyType $StartMenuKey.Type -Force
}
Else
{
	Set-ItemProperty -Path $RegPath -Name $StartMenuKey.Key -Value $StartMenuKey.Value -Force
}

##
# DWM Reg Path
##
$RegPath = "HKCU:\Software\Microsoft\Windows\DWM"

# Disable automatic color management
$ColorizationColorBalance = @{
	Key   = 'ColorizationColorBalance';
	Type  = "DWORD";
	Value = '0x00000059'
}

write-host "
Setting ColorizationColorBalance" $ColorizationColorBalance.Value

If ($Null -eq (Get-ItemProperty -Path $RegPath -Name $ColorizationColorBalance.Key -ErrorAction SilentlyContinue))
{
	New-ItemProperty -Path $RegPath -Name $ColorizationColorBalance.Key -Value $ColorizationColorBalance.Value -PropertyType $ColorizationColorBalance.Type -Force
}
Else
{
	Set-ItemProperty -Path $RegPath -Name $ColorizationColorBalance.Key -Value $ColorizationColorBalance.Value -Force
}

# Disable automatic color management
$ColorizationBlurBalance = @{
	Key   = 'ColorizationBlurBalance';
	Type  = "DWORD";
	Value = '0x00000001'
}

write-host "
Setting ColorizationBlurBalance" $ColorizationBlurBalance.Value

If ($Null -eq (Get-ItemProperty -Path $RegPath -Name $ColorizationBlurBalance.Key -ErrorAction SilentlyContinue))
{
	New-ItemProperty -Path $RegPath -Name $ColorizationBlurBalance.Key -Value $ColorizationBlurBalance.Value -PropertyType $ColorizationBlurBalance.Type -Force
}
Else
{
	Set-ItemProperty -Path $RegPath -Name $ColorizationBlurBalance.Key -Value $ColorizationBlurBalance.Value -Force
}


##
# Themes Personalize Reg Path
##
$RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"

# Enable transparency
$EnableTransparency = @{
	Key   = 'EnableTransparency';
	Type  = "DWORD";
	Value = '0x00000001'
}

write-host "
Setting EnableTransparency" $EnableTransparency.Value

If ($Null -eq (Get-ItemProperty -Path $RegPath -Name $EnableTransparency.Key -ErrorAction SilentlyContinue))
{
	New-ItemProperty -Path $RegPath -Name $EnableTransparency.Key -Value $EnableTransparency.Value -PropertyType $EnableTransparency.Type -Force
}
Else
{
	Set-ItemProperty -Path $RegPath -Name $EnableTransparency.Key -Value $EnableTransparency.Value -Force
}

# # if needed
# $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
# New-Item $regPath -Force | Out-Null
# New-ItemProperty $regPath -Name NoThemesTab -Value 0 -Force | Out-Null

if (Test-Path -Path "C:\Windows\Resources\Themes\catppuccin Mocha Win.theme" -PathType Leaf) {
    write-host "Setting theme to Catppuccin Mocha"
    start-process -filepath "C:\Windows\Resources\Themes\catppuccin Mocha Win.theme"; timeout /t 3; taskkill /im "systemsettings.exe" /f
} else {
    write-host "Catppuccin Mocha not found in C:\Windows\Resources\Themes\. Skipping..."
}

# Restart explorer
Stop-Process -ProcessName explorer -Force -ErrorAction SilentlyContinue