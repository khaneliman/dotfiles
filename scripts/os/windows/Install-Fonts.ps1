using module Message

# # Windows font variables
$FONTS = 0x14
$objShell = New-Object -ComObject Shell.Application
$objFolder = $objShell.Namespace($FONTS)
$username = $env:UserName

# # Loop through provided input directories
for ( $i = 0; $i -lt $args.count; $i++ )
{
    Write-Message  -Message "    Checking $($args[$i]) for fonts that need to be installed..."
    
    # Current directory being checked
    $Path=$($args[$i])
    $FontItem = Get-Item -Path $Path
    
    $FontList = Get-ChildItem -Recurse -Path "$FontItem\*" -Include ('*.fon','*.otf','*.ttc','*.ttf')
    $Fontdir = dir $Path

    foreach($File in $FontList)
    {
        $name = $File.baseName

        if(!($file.name -match "pfb$"))
        {
            $try = $true
            $installedFonts = @(Get-ChildItem C:\Users\$username\AppData\Local\Microsoft\Windows\Fonts | Where-Object {$_.PSIsContainer -eq $false} | Select-Object basename)
        
            foreach($font in $installedFonts)
            {
                $font = $font -replace "_", ""
                $name = $name -replace "_", ""

                if ($font -match $name)
                {
                    $try = $false
                }
            }
            if ($try)
            {
                Write-Message  -Message "    Installing $name"
                $objFolder.CopyHere($File.fullname)
                Write-Message -Type SUCCESS -Message "  Successfully installed $name"
            } else {
                Write-Message -Type WARNING -Message "    Font $name already installed. Skipping..."
            }
        }
    }
}

