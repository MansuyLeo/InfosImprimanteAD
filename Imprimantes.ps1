# Script par Mansuy Léo - Alternant TAM PSL - DSNU ASU IDF - e.SNCF Solutions
# Script PowerShell permettant d'obtenir des informations sur les imprimantes en entrant le nom ou l'adresse IP
# Se rappeler d'encoder en UTF-8 with BOM

# Prompt de l'utilisateur pour qu'il rentre soit le nom de l'imprimante soit l'adresse IP de l'imprimante
$userInput = Read-Host "Entrez le nom ou l'adresse IP de l'imprimante"

Write-Host "Recherche avec $userInput..." -ForegroundColor Yellow

try {
    # On recherche si l'imprimante existe dans les propriétés location, description, portName et printerName
    $printer = Get-ADObject -Filter "ObjectClass -eq 'printQueue'" -Properties printerName, serverName, uNCName, description, location, portName |
        Where-Object { 
            $_.printerName -ilike "*$userInput*" -or
            $_.location -ilike "*$userInput*" -or 
            $_.description -ilike "*$userInput*" -or 
            $_.portName -ilike "*$userInput*"
        } |
        Select-Object -First 1  # On sélectionne que le premier parce qu'on peut avoir plusieurs matchs

    # Si l'imprimante est trouvée, on affiche les propriétés
    if ($printer) {
        Write-Host "Imprimante trouvée !" -ForegroundColor Green
        Write-Host "------------------------------------------------------------------------------------" -ForegroundColor Cyan
        Write-Host "Nom:          " -ForegroundColor Cyan -NoNewline; Write-Host "$($printer.printerName)"
        Write-Host "Serveur:      " -ForegroundColor Cyan -NoNewline; Write-Host "$($printer.serverName)"
        Write-Host "Lien:         " -ForegroundColor Cyan -NoNewline; Write-Host "$($printer.uNCName)"
        Write-Host "Description:  " -ForegroundColor Cyan -NoNewline; Write-Host "$($printer.description)"
        Write-Host "Localisation: " -ForegroundColor Cyan -NoNewline; Write-Host "$($printer.location)"
        Write-Host "Port:         " -ForegroundColor Cyan -NoNewline; Write-Host "$($printer.portName)"
        Write-Host "------------------------------------------------------------------------------------" -ForegroundColor Cyan
    } else {
        Write-Host "Imprimante introuvable avec $userInput" -ForegroundColor Red
    }
} catch {
    Write-Error "Erreur lors de la recherche de l'imprimante: $_"
}
