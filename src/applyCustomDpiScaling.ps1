### Apply custom DPI scaling

$scaling = 1.5
$dpi = [int](96 * $scaling)
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'Win8DpiScaling' -Type DWord -Value 1
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'LogPixels' -Type DWord -Value $dpi
Write-Host "✅ Applied custom DPI scaling: $dpi" -ForegroundColor Green
