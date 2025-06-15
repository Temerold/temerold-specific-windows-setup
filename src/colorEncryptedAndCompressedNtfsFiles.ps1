### Color encrypted and compressed NTFS files

Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowEncryptCompressedColor' -Value 1 -Force
Write-Host '✅ Enabled coloring of encrypted and compressed NTFS files' -ForegroundColor 'green'
