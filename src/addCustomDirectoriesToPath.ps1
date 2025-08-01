### Add custom directories to path

$dirs = @()

if ($dirs.length -eq 0) { Write-Host "✅ Nothing to add to path" -ForegroundColor Green }
foreach ($dir in $dirs) {
    if ($dir -in $env:Path.split(';')) {
        Write-Host "✅ $dir already in path" -ForegroundColor Green
        continue
    }
    [System.Environment]::SetEnvironmentVariable("Path", $env:Path + ";$dir", [System.EnvironmentVariableTarget]::User)
    Write-Host "✅ Added $dir to path" -ForegroundColor Green
}
