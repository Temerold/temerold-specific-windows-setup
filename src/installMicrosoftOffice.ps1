### Install Microsoft Office

# Check if PowerShell version 7 or higher is being used
if ($PSVersionTable.PSVersion.Major -lt 7) {
    Write-Error 'This script requires PowerShell version 7 or higher'
    exit 1
}

Start-Process 'S:\Övrigt\OfficeSetup.exe'
Write-Host "✅ Installed Microsoft Office"
