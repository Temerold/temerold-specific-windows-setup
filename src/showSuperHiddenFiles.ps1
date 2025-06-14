### Show super-hidden files

Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowSuperHidden' -Value 1 -Force
Write-Output 'Enabled showing super-hidden files'
