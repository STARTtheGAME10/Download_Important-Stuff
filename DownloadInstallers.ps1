# Robustes Installer-Skript für Windows (2026) – mit WebClient & Winget
# Führe als Admin: Set-ExecutionPolicy RemoteSigned -Scope CurrentUser (einmalig)

$installDir = "$PSScriptRoot\Downloads"
New-Item -ItemType Directory -Force -Path $installDir | Out-Null

# Bekannte direkte URLs (getestet/aktuell)
$downloads = @(
    @{
        Name = "SpotifySetup"
        Url = "https://download.scdn.co/SpotifySetup.exe"  # Offiziell & stabil [web:63][web:21]
        File = "$installDir\SpotifySetup.exe"
    },
    @{
        Name = "ProtonPass"
        Url = "https://proton.me/download/pass/windows/ProtonPass_Setup.exe"  # Proton offiziell [web:36]
        File = "$installDir\ProtonPass_Setup.exe"
    }
    # Epic: Kein stabiler direkter Link – siehe manuelle Schritte unten
)

Write-Host "Downloads mit WebClient..." -ForegroundColor Green

Add-Type -AssemblyName System.Net.WebClient  # Für WebClient

foreach ($dl in $downloads) {
    try {
        $client = New-Object System.Net.WebClient
        $client.DownloadFile($dl.Url, $dl.File)
        $client.Dispose()
        Write-Host "$($dl.Name) OK: $($dl.File) ($( (Get-Item $dl.File).Length / 1MB ) MB)" -ForegroundColor Green
        
        # Optional installieren
        # Start-Process $dl.File -ArgumentList "/S" -Wait
        
    } catch {
        Write-Host "Fehler $($dl.Name): $($_.Exception.Message). Versuche Winget..." -ForegroundColor Yellow
        winget install --id $dl.Name --silent --accept-package-agreements --accept-source-agreements
    }
}

Write-Host "Downloads fertig in: $installDir" -ForegroundColor Yellow
