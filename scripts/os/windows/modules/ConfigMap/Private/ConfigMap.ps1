class ConfigMapEntry {
	[string]$Source
	[string]$Destination
	[boolean]$CreateSymbolicLink
	[boolean]$ReplaceExisting

	ConfigMapEntry([string]$source, [string]$destination, [boolean]$createSymbolicLink, [boolean]$replaceExisting) {
		$this.Source = $source
		$this.Destination = $destination
		$this.CreateSymbolicLink = $createSymbolicLink
		$this.ReplaceExisting = $replaceExisting
	}
}

class ConfigMap {
	[ConfigMapEntry[]]$ConfigMap

    ConfigMap() {
            
        $this.ConfigMap += [ConfigMapEntry]::new(
            $global:DOTS_DIR+"/windows/home/.config/komorebi",
            ${env:USERPROFILE}+"\.config\komorebi",
            $true,
            $true)
        
        $this.ConfigMap += [ConfigMapEntry]::new(
            $global:DOTS_DIR+"/windows/home/.config//ohmyposh",
            ${env:USERPROFILE}+"\.config\ohmyposh",
            $true,
            $true)

        $this.ConfigMap += [ConfigMapEntry]::new(
            $global:DOTS_DIR+"/windows/home/AppData/Local/Packages/MicaForEveryone_pfhyqtmn5ksmy/LocalState/MicaForEveryone.conf",
            ${env:USERPROFILE}+"\AppData\Local\Packages\MicaForEveryone_pfhyqtmn5ksmy\LocalState\MicaForEveryone.conf",
            $true,
            $true)

        $this.ConfigMap += [ConfigMapEntry]::new(
            $global:DOTS_DIR+"/windows/home/AppData/Local/Packages/Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe/LocalState/settings.json",
            ${env:USERPROFILE}+"\AppData\Local\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json",
            $true,
            $true)

        $this.ConfigMap += [ConfigMapEntry]::new(
            $global:DOTS_DIR+"/windows/home/Documents\PowerShell\Microsoft.PowerShell_profile.ps1",
            ${env:USERPROFILE}+"\Documents\PowerShell\Microsoft.PowerShell_profile.ps1",
            $true,
            $true)
    }

	ConfigMap([ConfigMapEntry[]]$configMap) {
		$this.ConfigMap = $configMap
	}

    [ConfigMapEntry[]]GetConfigMap() {    
        return $this.ConfigMap
    }
}

