# Script par MANSUY Léo - Alternant TAM PSL - DSNU ASU IDF - e.SNCF Solutions
# Recherche une imprimante sur les serveurs d'impressions du secteur PSL
# Si modification du script, se rappeler d'encoder en UTF-8 avec BOM

<# Version 2.0
    - Au lieu de rechercher les imprimantes dans l'AD, sollicitation directe sur les serveurs d'impression de PSL
    - Compatibilité de l'éxecution du script avec les postes propulses (OPW)
#>

# Liste des serveurs d'impressions de PSL

$printServers = @(
 # à compléter selon les files d'impressions de votre SI
)

$userInput = Read-Host "Entrez le nom ou l'adresse IP de l'imprimante"
Write-Host "Recherche de l'imprimante '$userInput' sur les serveurs d'impressions de PSL..." -ForegroundColor Yellow

$found = $false

foreach ($server in $printServers) {
    try {
        $printers = Get-Printer -ComputerName $server -ErrorAction Stop

        $printer = $printers | Where-Object {
            ($_.Name -and $_.Name.ToLower().Contains($userInput.ToLower())) -or
            ($_.PortName -and $_.PortName.ToLower().Contains($userInput.ToLower()))
        } | Select-Object -First 1



        if ($printer) {
            $found = $true
            Write-Host "Imprimante trouvée sur '$server' !" -ForegroundColor Green
            Write-Host "------------------------------------------------------------------------------------" -ForegroundColor Cyan
            Write-Host "Nom:" -ForegroundColor Cyan -NoNewline; Write-Host "$($printer.Name)"
            Write-Host "Serveur:" -ForegroundColor Cyan -NoNewline; Write-Host "$($printer.ComputerName)"
            Write-Host "Port:" -ForegroundColor Cyan -NoNewline; Write-Host "$($printer.PortName)"
            Write-Host "------------------------------------------------------------------------------------" -ForegroundColor Cyan
        }
    } catch {
        Write-Warning "Erreur de connexion au serveur '$server' : $_"
    }
}

if (-not $found) {
    Write-Host "Aucune imprimante trouvée avec '$userInput' sur les serveurs listés." -ForegroundColor Red
}

# Recherche dans l'AD

Write-Host "Recherche de l'imprimante '$userInput' dans l'AD..." -ForegroundColor Yellow

# Si le poste est un POCO on cherche aussi dans l'AD
$domain = (Get-WmiObject Win32_ComputerSystem).PartOfDomain

if ($domain) {
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
            Write-Host "Imprimante trouvée dans l'AD !" -ForegroundColor Green
            Write-Host "------------------------------------------------------------------------------------" -ForegroundColor Cyan
            Write-Host "Nom:          " -ForegroundColor Cyan -NoNewline; Write-Host "$($printer.printerName)"
            Write-Host "Serveur:      " -ForegroundColor Cyan -NoNewline; Write-Host "$($printer.serverName)"
            Write-Host "Lien:         " -ForegroundColor Cyan -NoNewline; Write-Host "$($printer.uNCName)"
            Write-Host "Description:  " -ForegroundColor Cyan -NoNewline; Write-Host "$($printer.description)"
            Write-Host "Localisation: " -ForegroundColor Cyan -NoNewline; Write-Host "$($printer.location)"
            Write-Host "Port:         " -ForegroundColor Cyan -NoNewline; Write-Host "$($printer.portName)"
            Write-Host "------------------------------------------------------------------------------------" -ForegroundColor Cyan
        } else {
            Write-Host "Imprimante introuvable dans l'AD avec $userInput" -ForegroundColor Red
        }
    } catch {
    Write-Error "Erreur lors de la recherche de l'imprimante dans l'AD: $_"
    }
} else {
    Write-Host "Vous utilisez un poste OPW, recherche dans l'AD impossible" -ForegroundColor Red
}
