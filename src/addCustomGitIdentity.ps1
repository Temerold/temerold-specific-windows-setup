### Add custom Git identity

$username = ''
$email = ''

git config --global user.name $username
Write-Host "✅ Set Git user.name to '$username'" -ForegroundColor 'green'

git config --global user.email $email
Write-Host "✅ Set Git user.email to '$email'" -ForegroundColor 'green'
# TODO: Add Git user.signingkey
