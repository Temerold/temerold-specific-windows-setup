### Apply custom desktop wallpaper

$wallpaperPath = ""
Add-Type @'
using System.Runtime.InteropServices;
using Microsoft.Win32;
public class Wallpaper {
    public const uint SPI_SETDESKWALLPAPER = 0x0014;
    public const uint SPIF_UPDATEINIFILE = 0x01;
    public const uint SPIF_SENDWININICHANGE = 0x02;
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    static extern int SystemParametersInfo(uint uAction, uint uParam,
                                           string lpvParam, uint fuWinIni);

    public static void SetWallpaper(string path) {
        SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, path,
                             SPIF_UPDATEINIFILE | SPIF_SENDWININICHANGE);
    }
}
'@

if (-not (Test-Path $wallpaperPath -ErrorAction SilentlyContinue)) {
    Write-Error "Path does not exist: '$wallpaperPath'"
    exit 1
}

[Wallpaper]::SetWallpaper($wallpaperPath)
Write-Host "✅ Set file to wallpaper: '$wallpaperPath'" -ForegroundColor Green
