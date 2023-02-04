class ConfigMapEntry
{
    [string]$Source
    [string]$Destination
    [boolean]$CreateSymbolicLink
    [boolean]$ReplaceExisting
    [boolean]$RequiresUnlock

    ConfigMapEntry([string]$source, [string]$destination, [boolean]$createSymbolicLink, [boolean]$replaceExisting)
    {
        $this.Source = $source
        $this.Destination = $destination
        $this.CreateSymbolicLink = $createSymbolicLink
        $this.ReplaceExisting = $replaceExisting
    }

    ConfigMapEntry([string]$source, [string]$destination, [boolean]$createSymbolicLink, [boolean]$replaceExisting, [boolean]$requiresUnlock)
    {
        $this.Source = $source
        $this.Destination = $destination
        $this.CreateSymbolicLink = $createSymbolicLink
        $this.ReplaceExisting = $replaceExisting
        $this.RequiresUnlock = $requiresUnlock
    }
}

class ConfigMap
{
    [ConfigMapEntry[]]$ConfigMap

    ConfigMap()
    {

        $Path = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders'
        $DOCUMENTS_PATH = Get-ItemPropertyValue -Path $Path -Name "Personal" -ErrorAction SilentlyContinue
        
        ##
        # Windows Configs
        ##
        $this.ConfigMap += [ConfigMapEntry]::new(
            $global:DOTS_DIR+"/windows/home/.config/komorebi",
            ${env:USERPROFILE}+"\.config\komorebi",
            $true,
            $true)
        
        $this.ConfigMap += [ConfigMapEntry]::new(
            $global:DOTS_DIR+"/windows/home/.config/ohmyposh",
            ${env:USERPROFILE}+"\.config\ohmyposh",
            $true,
            $true)

        $this.ConfigMap += [ConfigMapEntry]::new(
            $global:DOTS_DIR+"/windows/home/AppData/Local/Packages/MicaForEveryone_pfhyqtmn5ksmy/LocalState/MicaForEveryone.conf",
            ${env:USERPROFILE}+"\AppData\Local\Packages\MicaForEveryone_pfhyqtmn5ksmy\LocalState\MicaForEveryone.conf",
            $false,
            $true)

        $this.ConfigMap += [ConfigMapEntry]::new(
            $global:DOTS_DIR+"/windows/home/AppData/Local/Packages/Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe/LocalState/settings.json",
            ${env:USERPROFILE}+"\AppData\Local\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json",
            $true,
            $true)

        $this.ConfigMap += [ConfigMapEntry]::new(
            $global:DOTS_DIR+"/windows/home/Documents/PowerShell/Microsoft.PowerShell_profile.ps1",
            $DOCUMENTS_PATH+"\PowerShell\Microsoft.PowerShell_profile.ps1",
            $true,
            $true)
        
        $this.ConfigMap += [ConfigMapEntry]::new(
            $global:DOTS_DIR+"/windows/home/Documents/PowerShell/powershell.config.json",
            $DOCUMENTS_PATH+"\PowerShell\powershell.config.json",
            $true,
            $true)

        ##
        # Shared Configs
        ##
        $this.ConfigMap += [ConfigMapEntry]::new(
            $global:DOTS_DIR+"/shared/home/.config/nvim",
            ${env:USERPROFILE}+"\AppData\Local\nvim",
            $true,
            $true)

        $this.ConfigMap += [ConfigMapEntry]::new(
            $global:DOTS_DIR+"/shared/home/.config/astronvim/lua/user",
            ${env:USERPROFILE}+"\AppData\Local\nvim/lua/user",
            $true,
            $true)

        $this.ConfigMap += [ConfigMapEntry]::new(
            $global:DOTS_DIR+"/shared/home/.config/alacritty",
            ${env:USERPROFILE}+"\.config\alacritty",
            $true,
            $true)
        
        $this.ConfigMap += [ConfigMapEntry]::new(
            $global:DOTS_DIR+"/shared/home/.config/bat",
            ${env:USERPROFILE}+"\.config\bat",
            $true,
            $true)
        
        $this.ConfigMap += [ConfigMapEntry]::new(
            $global:DOTS_DIR+"/shared/home/.config/fish",
            ${env:USERPROFILE}+"\.config\fish",
            $true,
            $true)

        $this.ConfigMap += [ConfigMapEntry]::new(
            $global:DOTS_DIR+"/shared/home/.config/fastfetch",
            ${env:USERPROFILE}+"\.config\fastfetch",
            $true,
            $true)

        $this.ConfigMap += [ConfigMapEntry]::new(
            $global:DOTS_DIR+"/shared/home/.config/btop/themes",
            ${env:USERPROFILE}+"\scoop\persist\btop",
            $false,
            $true)
        
        $this.ConfigMap += [ConfigMapEntry]::new(
            $global:DOTS_DIR+"/shared/home/.config/btop/btop.conf",
            ${env:USERPROFILE}+"\scoop\apps\btop\current\btop.conf",
            $false,
            $true)
        
        $this.ConfigMap += [ConfigMapEntry]::new(
            $global:DOTS_DIR+"/shared/home/.config/topgrade.toml",
            ${env:USERPROFILE}+"\.config\topgrade.toml",
            $true,
            $true)
        
        $this.ConfigMap += [ConfigMapEntry]::new(
            $global:DOTS_DIR+"/shared/home/.gitconfig",
            ${env:USERPROFILE}+"\.gitconfig",
            $true,
            $true)
        
        $this.ConfigMap += [ConfigMapEntry]::new(
            $global:DOTS_DIR+"/shared/home/.gitconfig.functions",
            ${env:USERPROFILE}+"\.gitconfig.functions",
            $true,
            $true)
        
        $this.ConfigMap += [ConfigMapEntry]::new(
            $global:DOTS_DIR+"/shared/home/.gitconfig.signing",
            ${env:USERPROFILE}+"\.gitconfig.signing",
            $true,
            $false,
            $true)

        $this.ConfigMap += [ConfigMapEntry]::new(
            $global:DOTS_DIR+"/shared/home/.wakatime.cfg",
            ${env:USERPROFILE}+"\.wakatime.cfg",
            $true,
            $true)
        
        $this.ConfigMap += [ConfigMapEntry]::new(
            $global:DOTS_DIR+"/shared/home/.wegorc",
            ${env:USERPROFILE}+"\.wegorc",
            $true,
            $true)
        
        $this.ConfigMap += [ConfigMapEntry]::new(
            $global:DOTS_DIR+"/shared/home/.config/ranger",
            ${env:USERPROFILE}+"\.config\ranger",
            $true,
            $true)
        
        $this.ConfigMap += [ConfigMapEntry]::new(
            $global:DOTS_DIR+"/shared/home/.config/spicetify",
            ${env:USERPROFILE}+"\.config\spicetify",
            $true,
            $true)
        
        $this.ConfigMap += [ConfigMapEntry]::new(
            $global:DOTS_DIR+"/shared/home/.config/BetterDiscord",
            ${env:USERPROFILE}+"\.config\BetterDiscord",
            $true,
            $true)
    }

    ConfigMap([ConfigMapEntry[]]$configMap)
    {
        $this.ConfigMap = $configMap
    }

    [ConfigMapEntry[]]GetConfigMap()
    {    
        return $this.ConfigMap
    }
}

