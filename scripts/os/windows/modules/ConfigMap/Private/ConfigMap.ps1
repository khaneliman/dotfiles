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
            (-join($global:DOTS_DIR,"/windows/komorebi/home/.config/komorebi")),
            (-join($env:USERPROFILE,"\.config\komorebi")),
            $true,
            $true)
        
        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/windows/komorebi/home/.config/ohmyposh")),
            (-join($env:USERPROFILE,"\.config\ohmyposh")),
            $true,
            $true)

        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/windows/komorebi/home/AppData/Local/Packages/MicaForEveryone_pfhyqtmn5ksmy/LocalState/MicaForEveryone.conf")),
            (-join($env:USERPROFILE,"\AppData\Local\Packages\MicaForEveryone_pfhyqtmn5ksmy\LocalState\MicaForEveryone.conf")),
            $false,
            $true)

        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/windows/komorebi/home/AppData/Local/Packages/Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe/LocalState/settings.json")),
            (-join($env:USERPROFILE,"\AppData\Local\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json")),
            $true,
            $true)

        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/windows/komorebi/home/Documents/PowerShell/Microsoft.PowerShell_profile.ps1")),
            (-join($DOCUMENTS_PATH,"\PowerShell\Microsoft.PowerShell_profile.ps1")),
            $true,
            $true)
        
        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/windows/komorebi/home/Documents/PowerShell/powershell.config.json")),
            (-join($DOCUMENTS_PATH,"\PowerShell\powershell.config.json")),
            $true,
            $true)

        ##
        # Shared Configs
        ##
        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/shared/home/.config/nvim")),
            (-join($env:USERPROFILE,"\AppData\Local\nvim")),
            $true,
            $true)

        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/shared/home/.config/astronvim/lua/user")),
            (-join($env:USERPROFILE,"\AppData\Local\nvim/lua/user")),
            $true,
            $true)

        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/shared/home/.config/alacritty")),
            (-join($env:USERPROFILE,"\.config\alacritty")),
            $true,
            $true)
        
        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/shared/home/.config/bat")),
            (-join($env:USERPROFILE,"\.config\bat")),
            $true,
            $true)
        
        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/shared/home/.config/fish")),
            (-join($env:USERPROFILE,"\.config\fish")),
            $true,
            $true)

        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/shared/home/.config/fastfetch")),
            (-join($env:USERPROFILE,"\.config\fastfetch")),
            $true,
            $true)

        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/shared/home/.config/btop/themes")),
            (-join($env:USERPROFILE,"\scoop\persist\btop")),
            $false,
            $true)
        
        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/shared/home/.config/btop/btop.conf")),
            (-join($env:USERPROFILE,"\scoop\apps\btop\current\btop.conf")),
            $false,
            $true)
        
        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/shared/home/.config/topgrade.toml")),
            (-join($env:USERPROFILE,"\.config\topgrade.toml")),
            $true,
            $true)
        
        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/shared/home/.gitconfig")),
            (-join($env:USERPROFILE,"\.gitconfig")),
            $true,
            $true)
        
        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/shared/home/.gitconfig.functions")),
            (-join($env:USERPROFILE,"\.gitconfig.functions")),
            $true,
            $true)
        
        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/shared/home/.gitconfig.signing")),
            (-join($env:USERPROFILE,"\.gitconfig.signing")),
            $true,
            $false,
            $true)

        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/shared/home/.wakatime.cfg")),
            (-join($env:USERPROFILE,"\.wakatime.cfg")),
            $true,
            $true)
        
        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/shared/home/.wegorc")),
            (-join($env:USERPROFILE,"\.wegorc")),
            $true,
            $true)
        
        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/shared/home/.config/ranger")),
            (-join($env:USERPROFILE,"\.config\ranger")),
            $true,
            $true)
        
        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/shared/home/.config/spicetify")),
            (-join($env:USERPROFILE,"\.config\spicetify")),
            $true,
            $true)
        
        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/shared/home/.config/BetterDiscord")),
            (-join($env:USERPROFILE,"\.config\BetterDiscord")),
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

