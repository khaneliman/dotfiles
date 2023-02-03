using module UserPreferencesMask
using module ElevateScript

# Self-elevate the script if required
Request-ElevateScript

# Check what the current cursor is set to
$current_cursor = Get-ItemPropertyValue "HKCU:\Control Panel\Cursors" -Name "(Default)"

if ($current_cursor -eq "Catppuccin-Mocha-Blue-Cursors")
{
    write-host 'Cursor already set. Skipping...'
} else
{
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

    Update-UserPreferencesMask
}
