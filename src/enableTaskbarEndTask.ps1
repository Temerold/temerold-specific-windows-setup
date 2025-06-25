### Enable taskbar end task

$registryPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings'
if (-not (Test-Path $registryPath)) { New-Item -Path $registryPath -Force | Out-Null }
Set-ItemProperty -Path $registryPath -Name "TaskbarEndTask" -Value 1
Write-Host '✅ Enabled taskbar end task' -ForegroundColor 'green'
