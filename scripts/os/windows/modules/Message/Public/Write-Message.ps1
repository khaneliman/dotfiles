function Write-Message
{
    param (
        [Parameter(Mandatory=$true)] [string]$Message,
        [Parameter(Mandatory=$false)] [string]$Type
    )

    if ($Type -eq 'SUCCESS')
    {
        $PREFIX = "[>>]"
        $Color =  "green"
    } elseif ($Type -eq 'WARNING')
    {
        $PREFIX = "[>>]"
        $Color = "yellow"
    } elseif ($Type -eq 'ERROR')
    {
        $PREFIX = "[!!]"
        $Color = "red"
    } else
    {
        $PREFIX = "[>>]"
    }

    if ([boolean](get-variable "Color" -ErrorAction SilentlyContinue)) {
        Write-Host -Foreground $Color (-join($PREFIX, " ", $Message))
    } else {
        Write-Host (-join($PREFIX, " ", $Message))
    }
}
