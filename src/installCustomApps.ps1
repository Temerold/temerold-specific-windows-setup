### Install custom apps with WinGet

$silent = $true  # Set to `$false` to disable silent mode

# Check if WinGet is installed
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Error 'WinGet is not installed. Please install it first.'
    exit 1
}

$apps = @(
    '7zip.7zip',
    'Audacity.Audacity',
    'AudioRangerIT.AudioRanger',
    @(  'Blizzard.BattleNet',
        '--location',
        'C:\Program Files (x86)\Battle.net'),
    'BoanAnbo.ZoteroCitationPicker',
    'calibre.calibre',
    'CrystalDewWorld.CrystalDiskInfo',
    'CrystalDewWorld.CrystalDiskMark',
    'Discord.Discord',
    'dotPDN.PaintDotNet',
    'Duplicati.Duplicati',
    'EpicGames.EpicGamesLauncher',
    'Git.Git',
    'GNU.Wget2',
    'Google.Chrome',
    'Gyan.FFmpeg',
    'KDE.Kdenlive',
    'KeePassXCTeam.KeePassXC',
    'Klocman.BulkCrapUninstaller',
    'LibreWolf.LibreWolf',
    'Microsoft.Powershell',
    'Microsoft.Sysinternals',
    @(  'Microsoft.VisualStudioCode',
        '--override',
        '/mergetasks=!runcode,addcontextmenufiles,addcontextmenufolders /verysilent'),
    'MiniTool.PartitionWizard.Free',
    'Modrinth.ModrinthApp',
    'Mojang.MinecraftLauncher',
    'Mozilla.Firefox',
    'OBSProject.OBSStudio',
    'OpenJS.NodeJS',
    'Oracle.VirtualBox',
    'Python.Python.3.13',
    'qBittorrent.qBittorrent',
    'RARLab.WinRAR',
    'Spotify.Spotify',
    'undergroundwires.privacy.sexy',
    'Valve.Steam',
    'VideoLAN.VLC',
    'WinDirStat.WinDirStat',
    'yt-dlp.yt-dlp'
)

foreach ($app in $apps) {
    if ($app -is [array]) {
        $appId = $app[0]
        $additionalWinGetArgs = $app[1..$app.Length]
    }
    else {
        $appId = $app
        $additionalWinGetArgs = @()
    }
    Write-Host "Installing: $appId..."

    $winGetArgs = @(
        'install',
        '--id', $appId,
        '--exact',
        '--accept-source-agreements',
        '--accept-package-agreements',
        '--verbose-logs'
    ) + $additionalWinGetArgs
    if ($silent) { $winGetArgs += '--silent' }

    winget @winGetArgs

    if ($LASTEXITCODE -ne 0) { Write-Error "Failed to install: $appId" }
    else { Write-Host "Successfully installed: $appId" }
}
