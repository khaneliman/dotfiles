.$REGISTRY_ENTRY_CLASS

function Upsert-RegistryEntry {
    param (
        [RegistryEntry]$RegistryParameter
    )
    
    write-host "
    Setting" $RegistryParameter.Path $RegistryParameter.Key "to" $RegistryParameter.Value

    If ($Null -eq (Get-ItemProperty -Path $RegistryParameter.Path -Name $RegistryParameter.Key -ErrorAction SilentlyContinue))
    {
    	New-ItemProperty -Path $RegistryParameter.Path -Name $RegistryParameter.Key -Value $RegistryParameter.Value -PropertyType $RegistryParameter.Type -Force
    }
    Else
    {
    	Set-ItemProperty -Path $RegistryParameter.Path -Name $RegistryParameter.Key -Value $RegistryParameter.Value -Force
    }
}