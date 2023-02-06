Function Test-CommandExists {
 Param ($command)

 $oldPreference = $ErrorActionPreference
 $ErrorActionPreference = 'stop'

 try {
    if (Get-Command $command) {
        RETURN $true
    }
    } Catch {
        write-host -Foreground red “$command does not exist”; RETURN $false
    }

 Finally {$ErrorActionPreference=$oldPreference}
} #end function test-CommandExists

Export-ModuleMember -Function Test-CommandExists
