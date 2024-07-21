Function Await($WinRtTask, $ResultType) {
    $asTask = $asTaskGeneric.MakeGenericMethod($ResultType)
    $netTask = $asTask.Invoke($null, @($WinRtTask))
    $netTask.Wait(-1) | Out-Null
    $netTask.Result
}
Function Show-StatusAlert($BluetoothStatus) {
        $Texts = @{
        'On' = 'Up'
        'Off' = 'Down'
    }
    $Titles = @{
        'en' = @{
            'On' = 'Bluetooth is enabled'
            'Off' = 'Bluetooth is disabled'
        }
        'ru' = @{
            'On' = 'Сеть Bluetooth включена'
            'Off' = 'Сеть Bluetooth выключена'
        }
    }
    $tipText = $Texts[$BluetoothStatus]
    $tipTitle = $Titles[$lang][$BluetoothStatus]
    Add-Type -AssemblyName System.Windows.Forms
    $global:balmsg = New-Object System.Windows.Forms.NotifyIcon
    $path = (Get-Process -id $pid).Path
    $balmsg.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)
    $balmsg.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::None
    $balmsg.BalloonTipText = $tipText
    $balmsg.BalloonTipTitle = $tipTitle
    $balmsg.Visible = $true
    $balmsg.ShowBalloonTip(1000)
    Start-Sleep -Seconds 2
    $balmsg.Dispose()
}
Function Get-SystemLanguage {
    $lang = 'en'
    $culture = [System.Globalization.CultureInfo]::CurrentCulture
    if ($culture.Name -eq 'ru-RU') { $lang = 'ru' }
    $lang
}


If ((Get-Service bthserv).Status -eq 'Stopped') { Start-Service bthserv }
Add-Type -AssemblyName System.Runtime.WindowsRuntime
$asTaskGeneric = ([System.WindowsRuntimeSystemExtensions].GetMethods() | ? { $_.Name -eq 'AsTask' -and $_.GetParameters().Count -eq 1 -and $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1' })[0]

[Windows.Devices.Radios.Radio,Windows.System.Devices,ContentType=WindowsRuntime] | Out-Null
[Windows.Devices.Radios.RadioAccessStatus,Windows.System.Devices,ContentType=WindowsRuntime] | Out-Null
Await ([Windows.Devices.Radios.Radio]::RequestAccessAsync()) ([Windows.Devices.Radios.RadioAccessStatus]) | Out-Null
$radios = Await ([Windows.Devices.Radios.Radio]::GetRadiosAsync()) ([System.Collections.Generic.IReadOnlyList[Windows.Devices.Radios.Radio]])
$bluetooth = $radios | ? { $_.Kind -eq 'Bluetooth' }

$newBluetoothStatus = 'On'
if ($bluetooth.State -eq 'On') { $newBluetoothStatus = 'Off' }
[Windows.Devices.Radios.RadioState,Windows.System.Devices,ContentType=WindowsRuntime] | Out-Null
Await ($bluetooth.SetStateAsync($newBluetoothStatus)) ([Windows.Devices.Radios.RadioAccessStatus]) | Out-Null


$lang = Get-SystemLanguage
Show-StatusAlert($newBluetoothStatus, $lang)