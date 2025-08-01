### Disable hibernation

powercfg.exe -Hibernate 'off'
if ( Test-Path 'C:\hiberfil.sys' ) {
    Write-Error 'Could not disable hibernation'
    exit 1
}
Write-Host '✅ Successfully disabled hibernation' -ForegroundColor Green
