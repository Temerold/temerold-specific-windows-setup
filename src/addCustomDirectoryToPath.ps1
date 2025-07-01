### Add custom directory to path

$dir = 'S:\Program\PATH'

[System.Environment]::SetEnvironmentVariable("Path", $env:Path + ";$dir", [System.EnvironmentVariableTarget]::User)
Write-Host "Added $dir to path" -ForegroundColor 'green'
