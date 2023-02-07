Function Request-ElevateCommand {  
    param (
	    [Parameter(Mandatory=$true)] [string]$Command
    ) 

    # Self-elevate the script if required
    if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
        if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
            $CommandLine = "-Command & { " + $Command + "}"
            Start-Process PowerShell -Verb Runas -ArgumentList $CommandLine
        }
    }
}

