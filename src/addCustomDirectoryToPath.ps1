### Add custom directory to path

$dir = 'S:\Program\PATH'

[System.Environment]::SetEnvironmentVariable("Path", $env:Path + ";$dir", [System.EnvironmentVariableTarget]::User)
$env:Path
Write-Host "Added $dir to path"
