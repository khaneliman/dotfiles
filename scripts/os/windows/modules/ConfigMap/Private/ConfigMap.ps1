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
            (-join($global:DOTS_DIR,"/windows/komorebi/home/.config/komorebi").Replace("/","\")),
            (-join($env:USERPROFILE,"\.config\komorebi").Replace("/","\")),
            $true,
            $true)
        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/windows/komorebi/home/.config/whkdrc").Replace("/","\")),
            (-join($env:USERPROFILE,"\.config\whkdrc").Replace("/","\")),
            $true,
            $true)

        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/windows/komorebi/home/.config/ohmyposh").Replace("/","\")),
            (-join($env:USERPROFILE,"\.config\ohmyposh").Replace("/","\")),
            $true,
            $true)

        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/windows/komorebi/home/AppData/Local/Packages/MicaForEveryone_pfhyqtmn5ksmy/LocalState/MicaForEveryone.conf").Replace("/","\")),
            (-join($env:USERPROFILE,"\AppData\Local\Packages\MicaForEveryone_pfhyqtmn5ksmy\LocalState\MicaForEveryone.conf").Replace("/","\")),
            $false,
            $true)

        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/windows/komorebi/home/AppData/Local/Packages/Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe/LocalState/settings.json").Replace("/","\")),
            (-join($env:USERPROFILE,"\AppData\Local\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json").Replace("/","\")),
            $true,
            $true)

        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/windows/komorebi/home/Documents/PowerShell/Microsoft.PowerShell_profile.ps1").Replace("/","\")),
            (-join($DOCUMENTS_PATH,"\PowerShell\Microsoft.PowerShell_profile.ps1").Replace("/","\")),
            $true,
            $true)

        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/windows/komorebi/home/Documents/PowerShell/Microsoft.PowerShell_profile.ps1").Replace("/","\")),
            (-join($DOCUMENTS_PATH,"\WindowsPowerShell\Microsoft.PowerShell_profile.ps1").Replace("/","\")),
            $true,
            $true)
        
        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/windows/komorebi/home/Documents/PowerShell/powershell.config.json").Replace("/","\")),
            (-join($DOCUMENTS_PATH,"\PowerShell\powershell.config.json").Replace("/","\")),
            $true,
            $true)

        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/windows/komorebi/home/AppData/Local/fastfetch/").Replace("/","\")),
            (-join($env:USERPROFILE,"\AppData\Local\fastfetch\").Replace("/","\")),
            $true,
            $true)

        ##
        # Shared Configs
        ##
        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/shared/home/.config/nvim").Replace("/","\")),
            (-join($env:USERPROFILE,"\AppData\Local\nvim").Replace("/","\")),
            $true,
            $true)

        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/shared/home/.config/astronvim/lua/user").Replace("/","\")),
            (-join($env:USERPROFILE,"\AppData\Local\nvim/lua/user").Replace("/","\")),
            $true,
            $true)

        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/shared/home/.config/alacritty").Replace("/","\")),
            (-join($env:USERPROFILE,"\.config\alacritty").Replace("/","\")),
            $true,
            $true)
        
        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/shared/home/.config/bat").Replace("/","\")),
            (-join($env:USERPROFILE,"\.config\bat").Replace("/","\")),
            $true,
            $true)
        
        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/shared/home/.config/fish").Replace("/","\")),
            (-join($env:USERPROFILE,"\.config\fish").Replace("/","\")),
            $true,
            $true)

        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/shared/home/.config/fastfetch").Replace("/","\")),
            (-join($env:USERPROFILE,"\.config\fastfetch").Replace("/","\")),
            $true,
            $true)

        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/shared/home/.config/btop/themes").Replace("/","\")),
            (-join($env:USERPROFILE,"\scoop\persist\btop").Replace("/","\")),
            $false,
            $true)
        
        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/shared/home/.config/btop/btop.conf").Replace("/","\")),
            (-join($env:USERPROFILE,"\scoop\apps\btop\current\btop.conf").Replace("/","\")),
            $false,
            $true)
        
        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/shared/home/.config/topgrade.toml").Replace("/","\")),
            (-join($env:USERPROFILE,"\.config\topgrade.toml").Replace("/","\")),
            $true,
            $true)
        
        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/shared/home/.gitconfig").Replace("/","\")),
            (-join($env:USERPROFILE,"\.gitconfig").Replace("/","\")),
            $true,
            $true)
        
        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/shared/home/.gitconfig.functions").Replace("/","\")),
            (-join($env:USERPROFILE,"\.gitconfig.functions").Replace("/","\")),
            $true,
            $true)
        
        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/shared/home/.gitconfig.signing").Replace("/","\")),
            (-join($env:USERPROFILE,"\.gitconfig.signing").Replace("/","\")),
            $true,
            $false,
            $true)

        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/shared/home/.wakatime.cfg").Replace("/","\")),
            (-join($env:USERPROFILE,"\.wakatime.cfg").Replace("/","\")),
            $true,
            $true)
        
        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/shared/home/.wegorc").Replace("/","\")),
            (-join($env:USERPROFILE,"\.wegorc").Replace("/","\")),
            $true,
            $true)
        
        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/shared/home/.config/ranger").Replace("/","\")),
            (-join($env:USERPROFILE,"\.config\ranger").Replace("/","\")),
            $true,
            $true)
        
        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/shared/home/.config/spicetify").Replace("/","\")),
            (-join($env:USERPROFILE,"\.config\spicetify").Replace("/","\")),
            $true,
            $true)
        
        $this.ConfigMap += [ConfigMapEntry]::new(
            (-join($global:DOTS_DIR,"/shared/home/.config/BetterDiscord").Replace("/","\")),
            (-join($env:USERPROFILE,"\.config\BetterDiscord").Replace("/","\")),
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

