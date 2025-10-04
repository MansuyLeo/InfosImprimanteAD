# InfosImprimanteAD
Script pour obtenir des informations selon le nom ou l'IP de l'imprimante dans l'AD (Serveur de la file d'impression, localisation, port,...)

## Pré-requis:

- Le script doit être éxécuté par une machine joint au domaine Active Directory pour fonctionner
- La v2 cherche déjà l'imprimante sur les files d'impressions qui sont à compléter selon les files d'impressions de votre SI. Puis il va chercher les infos dans l'AD

## Instructions:

1. Télécharger "Imprimantes.bat" et "Imprimantes.ps1" dans un même dossier
2. Lancer "Imprimantes.bat" (compte Administrateur non requis car simple requête dans l'AD)
3. Entrez un nom ou une adresse IP de l'imprimante
