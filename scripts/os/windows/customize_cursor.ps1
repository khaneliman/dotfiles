# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
        Exit
    }
}

infdefaultinstall.exe $args

Set-itemproperty "HKCU:\Control Panel\Cursors" -Name "(Default)" -Value "Catppuccin-Mocha-Blue-Cursors"

$RegConnect = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]"CurrentUser","$env:COMPUTERNAME")


$RegCursors = $RegConnect.OpenSubKey("Control Panel\Cursors",$true)

$RegCursors.SetValue("","Catppuccin-Mocha-Blue-Cursors")

$RegCursors.SetValue("Scheme Source","1")

# $RegCursors.SetValue("CursorBaseSize",0x20)

$RegCursors.SetValue("AppStarting","%SYSTEMROOT%\Cursors\Catppuccin-Mocha-Blue-Cursors\working-in-background.ani")

$RegCursors.SetValue("Arrow","%SYSTEMROOT%\Cursors\Catppuccin-Mocha-Blue-Cursors\normal-select.cur")

$RegCursors.SetValue("Crosshair","%SYSTEMROOT%\Cursors\Catppuccin-Mocha-Blue-Cursors\precision-select.cur")

$RegCursors.SetValue("Hand","%SYSTEMROOT%\Cursors\Catppuccin-Mocha-Blue-Cursors\link-select.cur")

$RegCursors.SetValue("Help","%SYSTEMROOT%\Cursors\Catppuccin-Mocha-Blue-Cursors\help-select.cur")

$RegCursors.SetValue("IBeam","%SYSTEMROOT%\Cursors\Catppuccin-Mocha-Blue-Cursors\text-select.cur")

$RegCursors.SetValue("No","%SYSTEMROOT%\Cursors\Catppuccin-Mocha-Blue-Cursors\unavailable.cur")

$RegCursors.SetValue("NWPen","%SYSTEMROOT%\Cursors\Catppuccin-Mocha-Blue-Cursors\handwriting.cur")

$RegCursors.SetValue("SizeAll","%SYSTEMROOT%\Cursors\Catppuccin-Mocha-Blue-Cursors\move.cur")

$RegCursors.SetValue("SizeNESW","%SYSTEMROOT%\Cursors\Catppuccin-Mocha-Blue-Cursors\diagonal-resize-2.cur")

$RegCursors.SetValue("SizeNS","%SYSTEMROOT%\Cursors\Catppuccin-Mocha-Blue-Cursors\vertical-resize.cur")

$RegCursors.SetValue("SizeNWSE","%SYSTEMROOT%\Cursors\Catppuccin-Mocha-Blue-Cursors\diagonal-resize-1.cur")

$RegCursors.SetValue("SizeWE","%SYSTEMROOT%\Cursors\Catppuccin-Mocha-Blue-Cursors\horizontal-resize.cur")

$RegCursors.SetValue("UpArrow","%SYSTEMROOT%\Cursors\Catppuccin-Mocha-Blue-Cursors\alt-select.cur")

$RegCursors.SetValue("Wait","%SYSTEMROOT%\Cursors\Catppuccin-Mocha-Blue-Cursors\busy.ani")

$RegCursors.Close()

$RegConnect.Close()

function Update-UserPreferencesMask {
$Signature = @"
[DllImport("user32.dll", EntryPoint = "SystemParametersInfo")]
public static extern bool SystemParametersInfo(uint uiAction, uint uiParam, uint pvParam, uint fWinIni);

const int SPI_SETCURSORS = 0x0057;
const int SPIF_UPDATEINIFILE = 0x01;
const int SPIF_SENDCHANGE = 0x02;

public static void UpdateUserPreferencesMask() {
    SystemParametersInfo(SPI_SETCURSORS, 0, 0, SPIF_UPDATEINIFILE | SPIF_SENDCHANGE);
}
"@
    Add-Type -MemberDefinition $Signature -Name UserPreferencesMaskSPI -Namespace User32
    [User32.UserPreferencesMaskSPI]::UpdateUserPreferencesMask()
}
Update-UserPreferencesMask
