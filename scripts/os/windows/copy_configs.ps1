# .$CONFIG_MAP_CLASS
using module ConfigMap

# # Variables
$CONFIGS = "${env:USERPROFILE}"
$objShell = New-Object -ComObject Shell.Application

# Loop through provided input directories
# for ( $i = 0; $i -lt $args.count; $i++ ) {
#     write-host "    Checking $($args[$i]) for files that need to be installed..."
    
#     # Current directory being checked
#     $Path=$($args[$i])
#     $Config = Get-Item -Path $Path
#     $ConfigList = Get-ChildItem -Force -Path "$Config\*"

#     foreach($File in $ConfigList) {
#         $try = $true
#         $objFolder = $objShell.Namespace($CONFIGS)
#         $installedItems = @(Get-ChildItem $CONFIGS | Where-Object {$_.PSIsContainer -eq $false} | Select-Object name)

#         if ($File -match "\\.config$") {
#             $objFolder = $objShell.Namespace("$CONFIGS\.config\")
            
#             If(!(test-path -PathType container "$CONFIGS\.config\")) {
#                 New-Item -ItemType Directory -Path "$CONFIGS\.config\"
#             }
            
#             $installedItems = @(Get-ChildItem "$CONFIGS\.config" | Select-Object name)
            
#             write-host $installedItems
#         }

#         foreach($item in $installedItems)
#         {
#             if ($item -match $File.name)
#             {
#                 write-host $File already exists 
#                 $try = $false
#             }
#         }
#         if ($try)
#         {
#             write-host "    Installing $name from $File"
#             # $objFolder.CopyHere($File.fullname)
#             # New-Item -ItemType SymbolicLink -Path "${env:USERPATH}\.config\" -Target $File.fullname
#         }
#     }
# }

$test = Get-ConfigMap
ConvertTo-Json $test