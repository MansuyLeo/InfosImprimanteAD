@echo off
:: Dossier actuel du script .bat
set scriptDir=%~dp0

:: Lancement du script Imprimantes.ps1
powershell.exe -NoProfile -NoLogo -ExecutionPolicy Bypass -File "%scriptDir%Imprimantes.ps1"

:: Pause pour laisser la fenêtre ouverte après l'execution
pause
