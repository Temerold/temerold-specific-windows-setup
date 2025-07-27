### Add custom directories to path

$dirs = @()

if ($dirs.length -eq 0) { Write-Host "✅ Nothing to add to path" -ForegroundColor 'green' }
foreach ($dir in $dirs) {
    if ($dir -in $env:Path.split(';')) {
        Write-Host "✅ $dir already in path" -ForegroundColor 'green'
        continue
    }
    [System.Environment]::SetEnvironmentVariable("Path", $env:Path + ";$dir", [System.EnvironmentVariableTarget]::User)
    Write-Host "✅ Added $dir to path" -ForegroundColor 'green'
}
