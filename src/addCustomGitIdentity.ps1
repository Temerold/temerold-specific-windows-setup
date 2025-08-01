### Add custom Git identity

if (-not (Get-Command 'git' -ErrorAction SilentlyContinue)) {
    Write-Error 'Git not found. Git identity not changed.'
    exit 1
}

$username = ''
$email = ''

git config --global user.name $username
Write-Host "✅ Set Git user.name to '$username'" -ForegroundColor Green

git config --global user.email $email
Write-Host "✅ Set Git user.email to '$email'" -ForegroundColor Green
# TODO: Add Git user.signingkey
