if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-File", "$PSCommandPath" -Verb RunAs
    exit
}

function sendMessage($message, $type) {
    if($type -eq "error") {
        Write-Host "[ERROR] $message" -ForegroundColor Red
    } elseif($type -eq "warn") {
        Write-Host "[WARNING] $message" -ForegroundColor Yellow
    } elseif($type -eq "note") {
        Write-Host "[NOTE] $message" -ForegroundColor Green
    } elseif($type -eq "instruct") {
        Write-Host "[INSTRUCT] $message" -ForegroundColor Cyan
    } else {
        Write-Host "[INFO] $message" -ForegroundColor White
    }
}

cls
sendMessage "Installation de Winget..." "note"
Write-Host ""
sendMessage "Veuillez installer Microsoft Winget depuis le Microsoft Store." "instruct"
sendMessage "Vous devrez peut-être cliquer sur le bouton 'Installer' manuellement dans le Microsoft Store." "instruct"
Start-Process "ms-windows-store://pdp/?ProductId=9NBLGGH4NNS1"
Write-Host ""
pause

sendMessage "Désactivation temporaire de la politique d'installation des modules" "note"
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

sendMessage "Installation de Winfetch..." "note"
Install-Script -Name winfetch -Force -Confirm:$false

sendMessage "Installation de Terminal-Icons..." "note"
Install-Module -Name Terminal-Icons -Force -Confirm:$false

sendMessage "Réactivation de la politique d'installation des modules" "note"
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Default

sendMessage "Installation de OhMyPosh..." "note"
winget install JanDeDobbeleer.OhMyPosh -s winget

sendMessage "Configuration de la police" "note"
Write-Host ""
sendMessage "Choisissez une police à télécharger" "instruct"
Write-Host ""
oh-my-posh font install --user

sendMessage "Désactivation temporaire de la politique d'installation des modules" "note"
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

sendMessage "Lancement de Winfetch" "note"
winfetch
$pathConfigWinfetch = Join-Path -Path $env:UserProfile -ChildPath ".config\winfetch\config.ps1"
Write-Host ""
sendMessage "Pour modifier la configuration de Winfetch, modifier le fichier dans : $pathConfigWinfetch" "instruct"
Write-Host ""

sendMessage "Réactivation de la politique d'installation des modules" "note"
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Default

sendMessage "Configuration du profil Powershell" "note"
Write-Host ""
sendMessage "Le fichier de configuration existant va être supprimé" "warn"
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
sendMessage "Si vous souhaitez enlever le temps de chargement ajouter -nologo à la commande de lancement de votre terminal." "instruct"
sendMessage 'Par exemple : "C:\Program Files\PowerShell\7\pwsh.exe" -nologo' "instruct"
Write-Host ""
sendMessage "N'oubliez pas de changer la police du terminal par celle que vous avez télécharger (elle fini par 'Nerd Font')" "instruct"
Write-Host ""

pause