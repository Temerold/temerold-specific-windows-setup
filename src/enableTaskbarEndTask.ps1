### Enable taskbar end task

Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings' -Name 'TaskbarEndTask' -Value 1 -Force
Write-Host '✅ Enabled taskbar end task' -Foregroundcolor Green
