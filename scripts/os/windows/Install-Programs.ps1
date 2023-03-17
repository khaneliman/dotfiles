using module RegistryEntry
using module TestCommandExists
using module Message

$env:PSModulePath = "$PSHOME/Modules\"+";$SCRIPTS_DIR/os/windows/modules";

#
# ░█▀▀░█▀▀░█▀█░█▀█░█▀█░░░█▀█░█▀█░█▀█░█▀▀
# ░▀▀█░█░░░█░█░█░█░█▀▀░░░█▀█░█▀▀░█▀▀░▀▀█
# ░▀▀▀░▀▀▀░▀▀▀░▀▀▀░▀░░░░░▀░▀░▀░░░▀░░░▀▀▀
#
## 
# Install scoop
##
if (!(Test-Path -Path "$($env:USERPROFILE)/scoop/shims/scoop" -PathType Leaf))
{
    Invoke-RestMethod get.scoop.sh | Invoke-Expression
} else
{
    Write-Host ""
    Write-Message -Type WARNING -Message "Scoop already installed. skipping..."
}

if (Test-CommandExists scoop)
{
    
    # buckets
    $scoop_buckets = @(
        'main', 'extras', 'versions'
    )

    foreach ($bucket in $scoop_buckets)
    {
        scoop bucket add $bucket
    }

    # scoops
    $scoop_apps = @(
        'sudo', 'bat', 'btop', 'fastfetch', 'pshazz', 'git-crypt', 'vcredist', '1password-cli',
        'secureuxtheme', '7tsp', 'archwsl', 'spicetify-cli', 'topgrade'
    )

    foreach ($app in $scoop_apps)
    {
        scoop install $app
    }

    # elevated installs
    sudo scoop install windowsdesktop-runtime-lts
} else
{
    Write-Message -Type WARNING  -Message "    Scoop not installed. Skipping scoop installs..."
}

#
# ░█░█░▀█▀░█▀█░█▀▀░█▀▀░▀█▀░░░█▀█░█▀█░█▀█░█▀▀
# ░█▄█░░█░░█░█░█░█░█▀▀░░█░░░░█▀█░█▀▀░█▀▀░▀▀█
# ░▀░▀░▀▀▀░▀░▀░▀▀▀░▀▀▀░░▀░░░░▀░▀░▀░░░▀░░░▀▀▀
#
##
# Install winget
# https://github.com/microsoft/winget-cli/
##
if ( !(Test-CommandExists winget))
{
    Write-Host ""
    Write-Message  -Message "Installing winget"
    $download_url = "https://github.com/microsoft/winget-cli/releases/download/v1.4.10173/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
    $download_save_file = "$($env:USERPROFILE)\Downloads\MicrosoftDesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
    $wc.Downloadfile($download_url, $download_save_file)
    Add-AppXPackage -Path $($env:USERPROFILE)\Downloads\MicrosoftDesktopAppInstaller_8wekyb3d8bbwe.msixbundle
} else
{
    Write-Host ""
    Write-Message -Type WARNING  -Message "Winget already installed. Skipping..."
}

##
# Winget installations
##
if (Test-CommandExists winget)
{
    $winget_apps = @(
        'MSYS2.MSYS2',
        'Microsoft.Powershell.Preview',
        'Microsoft.WindowsTerminal.Preview',
        'Bitsum.ProcessLasso',
        'Git.Git',
        'GitHub.GitHubDesktop',
        'Microsoft.VisualStudioCode',
        'Neovim.Neovim',
        'Microsoft.DotNet.SDK.7',
        'Microsoft.DotNet.Runtime.7',
        'Microsoft.DotNet.DesktopRuntime.7',
        'Mozilla.Firefox.DeveloperEdition',
        'AgileBits.1Password',
        'Microsoft.Teams',
        'AntibodySoftware.WizTree',
        'Notepad++.Notepad++',
        'Microsoft.Sysinternals.Autoruns',
        'Valve.Steam',
        'HeroicGamesLauncher.HeroicGamesLauncher',
        'Alacritty.Alacritty',
        'Rustlang.Rustup',
        'LLVM.LLVM',
        'CoreyButler.NVMforWindows',
        'JesseDuffield.lazygit'
    )

    foreach ($app in $winget_apps)
    {
        Write-Message -Message "    Installing $app..."
        winget install --accept-package-agreements --accept-source-agreements --silent --no-upgrade --id $app
    }
} else
{
    Write-Message -Type WARNING -Message "    Winget not installed. Skipping winget installs..."
}

