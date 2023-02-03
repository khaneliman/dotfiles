function Set-RegistryEntry {
    param (
        [Parameter(Mandatory=$true)] [string]$Key,
	    [Parameter(Mandatory=$true)] [string]$Type,
	    [Parameter(Mandatory=$true)] [string]$Value,
        [Parameter(Mandatory=$true)] [string]$Path
    )
    
    write-host "
    Setting" $Path $Key "to" $Value

    if ($Type -eq 'BINARY') {
        [byte[]]$Value= $Value.Split(',')
    }

    If ($Null -eq (Get-ItemProperty -Path $Path -Name $Key -ErrorAction SilentlyContinue))
    {
    	New-ItemProperty -Path $Path -Name $Key -Value $Value -PropertyType $Type -Force
    }
    Else
    {
    	Set-ItemProperty -Path $Path -Name $Key -Value $Value -Force
    }
}