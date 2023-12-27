if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-File", "$PSCommandPath" -Verb RunAs
    exit
}
cls
Write-Host "[NOTE] Installation de Winget..."
Write-Host ""
Write-Host "[INSTRUCT] Veuillez installer Microsoft Winget depuis le Microsoft Store." -ForegroundColor Yellow
Write-Host "[INSTRUCT] Vous devrez peut-être cliquer sur le bouton 'Installer' manuellement dans le Microsoft Store." -ForegroundColor Yellow
Start-Process "ms-windows-store://pdp/?ProductId=9NBLGGH4NNS1"
Write-Host ""
pause

Write-Host "[NOTE] Désactivation temporaire de la politique d'installation des modules"
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

Write-Host "[NOTE] Installation de Winfetch..."
Install-Script -Name winfetch -Force -Confirm:$false

Write-Host "[NOTE] Installation de Terminal-Icons..."
Install-Module -Name Terminal-Icons -Force -Confirm:$false

Write-Host "[NOTE] Réactivation de la politique d'installation des modules"
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Default

Write-Host "[NOTE] Installation de OhMyPosh..."
winget install JanDeDobbeleer.OhMyPosh -s winget

Write-Host "[NOTE] Configuration de la police"
Write-Host ""
Write-Host "[INSTRUCT] Choisissez une police à télécharger" -ForegroundColor Yellow
Write-Host ""
oh-my-posh font install --user

Write-Host "[NOTE] Désactivation temporaire de la politique d'installation des modules"
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

Write-Host "[NOTE] Lancement de Winfetch"
winfetch
$pathConfigWinfetch = Join-Path -Path $env:UserProfile -ChildPath ".config\winfetch\config.ps1"
Write-Host ""
Write-Host "[INSTRUCT] Pour modifier la configuration de Winfetch, modifier le fichier dans : $pathConfigWinfetch" -ForegroundColor Yellow
Write-Host ""

Write-Host "[NOTE] Réactivation de la politique d'installation des modules"
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Default

Write-Host "[NOTE] Configuration du profil Powershell"
Write-Host ""
Write-Host "[NOTE] Le fichier de configuration existant va être supprimé" -ForegroundColor Red
Write-Host ""
pause
if (Test-Path $PROFILE) {
    Remove-Item -Path $PROFILE -Force 
}
New-Item -ItemType File -Path $PROFILE -Force > $null
Add-Content $PROFILE "Import-Module -Name Terminal-Icons"
Add-Content $PROFILE "cls"
Add-Content $PROFILE "winfetch"
Add-Content $PROFILE "oh-my-posh init pwsh --config '$env:POSH_THEMES_PATH/zash.omp.json' | Invoke-Expression"

Write-Host ""
Write-Host "[INSTRUCT] Si vous souhaitez enlever le temps de chargement ajouter -nologo à la commande de lancement de votre terminal." -ForegroundColor Yellow
Write-Host '[INSTRUCT] Par exemple : "C:\Program Files\PowerShell\7\pwsh.exe" -nologo"' -ForegroundColor Yellow
Write-Host ""
Write-Host "[INSTRUCT] N'oubliez pas de changer la police du terminal par celle que vous avez télécharger (elle fini par 'Nerd Font')" -ForegroundColor Yellow
Write-Host ""

pause