# Installer-Download-Skript für Windows
# Führe als Admin aus: Right-Click > Run with PowerShell

$installDir = "$PSScriptRoot\Downloads"
New-Item -ItemType Directory -Force -Path $installDir | Out-Null

# Offizielle Download-URLs (direkte Links aus Quellen)
$downloads = @(
    @{
        Name = "EpicGamesLauncher"
        Url = "https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/installer/download/EpicInstaller-17.2.0-26105720.msi"  # Aktuelle MSI von Epic [web:11]
        File = "$installDir\EpicGamesLauncher.msi"
    },
    @{
        Name = "ProtonPass"
        Url = "https://proton.me/download/pass/windows/ProtonPass_Setup.exe"  # Aus Proton-Downloads [web:33][web:36]
        File = "$installDir\ProtonPass_Setup.exe"
    },
    @{
        Name = "Spotify"
        Url = "https://download.scdn.spotify.com/SpotifySetup.exe"  # Automatischer Download-Link [web:21]
        File = "$installDir\SpotifySetup.exe"
    }
)

Write-Host "Starte Downloads..." -ForegroundColor Green

foreach ($dl in $downloads) {
    try {
        Invoke-WebRequest -Uri $dl.Url -OutFile $dl.File
        Write-Host "$($dl.Name) erfolgreich heruntergeladen: $($dl.File)" -ForegroundColor Green
        
        # Optional: Automatisch installieren (entkommentiere die Zeile)
        # Start-Process -FilePath $dl.File -ArgumentList "/S", "/quiet" -Wait  # Für MSI/EXE mit silent-Flags
        
    } catch {
        Write-Host "Fehler bei $($dl.Name): $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "Fertig! Installationsdateien in: $installDir" -ForegroundColor Yellow

