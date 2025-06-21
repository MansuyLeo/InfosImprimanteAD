:: Script par MANSUY Léo - Alternant TAM PSL

@echo off

echo.
echo ##############################################
echo #                                            #
echo #            INFOS IMPRIMANTES AD            #
echo #   Auteur: MANSUY Leo - Alternant TAM PSL   #
echo #              e.SNCF Solutions              #
echo #                                            #
echo ##############################################
echo.
:loop
:: Dossier actuel du script .bat
set scriptDir=%~dp0

:: Lancement du script Imprimantes.ps1
powershell.exe -NoProfile -NoLogo -ExecutionPolicy Bypass -File "%scriptDir%Imprimantes_v2.ps1"

:: Pause pour laisser la fenêtre ouverte après l'execution
echo.
:prompt
set /p choice="Voulez-vous rechercher une autre imprimante ? (y/n): "
if /i "%choice%"=="y" goto loop
if /i "%choice%"=="n" exit

:: Message d'erreur pour une entrée non valide
echo Choix invalide. Veuillez entrer 'y' ou 'n'.
goto prompt
