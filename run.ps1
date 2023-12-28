function DisplayMessage($message, $type) {
    $colors = @{
        "error" = "Red"
        "warn" = "Yellow"
        "note" = "Green"
        "instruct" = "Cyan"
        "default" = "White"
    }
    $color = $colors[$type] -as [System.ConsoleColor]
    Write-Host "[$type] $message" -ForegroundColor $color
}

function ManageModulePolicy($action) {
    switch ($action) {
        "disable" {
            DisplayMessage "Désactivation temporaire de la politique d'installation des modules" "note"
            Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
        }
        "enable" {
            DisplayMessage "Réactivation de la politique d'installation des modules" "note"
            Set-ExecutionPolicy -Scope Process -ExecutionPolicy Default
        }
    }
}

if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-File", "$PSCommandPath" -Verb RunAs
    exit
}

cls
DisplayMessage "Installation de Winget..." "note"
Write-Host ""
DisplayMessage "Veuillez installer Microsoft Winget depuis le Microsoft Store." "instruct"
DisplayMessage "Vous devrez peut-être cliquer sur le bouton 'Installer' manuellement dans le Microsoft Store." "instruct"
Start-Process "ms-windows-store://pdp/?ProductId=9NBLGGH4NNS1"
Write-Host ""
pause

DisplayMessage "Désactivation temporaire de la politique d'installation des modules" "note"
ManageModulePolicy "disable"

DisplayMessage "Installation de Winfetch..." "note"
Install-Script -Name winfetch -Force -Confirm:$false

DisplayMessage "Installation de Terminal-Icons..." "note"
Install-Module -Name Terminal-Icons -Force -Confirm:$false

DisplayMessage "Réactivation de la politique d'installation des modules" "note"
ManageModulePolicy "enable"

DisplayMessage "Installation de OhMyPosh..." "note"
winget install JanDeDobbeleer.OhMyPosh -s winget

DisplayMessage "Configuration de la police" "note"
Write-Host ""
DisplayMessage "Choisissez une police à télécharger" "instruct"
Write-Host ""
oh-my-posh font install --user

DisplayMessage "Désactivation temporaire de la politique d'installation des modules" "note"
ManageModulePolicy "disable"

DisplayMessage "Lancement de Winfetch" "note"
winfetch
$pathConfigWinfetch = Join-Path -Path $env:UserProfile -ChildPath ".config\winfetch\config.ps1"
Write-Host ""
DisplayMessage "Pour modifier la configuration de Winfetch, modifier le fichier dans : $pathConfigWinfetch" "instruct"
Write-Host ""

DisplayMessage "Réactivation de la politique d'installation des modules" "note"
ManageModulePolicy "enable"

DisplayMessage "Configuration du profil Powershell" "note"
Write-Host ""
DisplayMessage "Le fichier de configuration existant va être supprimé" "warn"
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
DisplayMessage "Si vous souhaitez enlever le temps de chargement ajouter -nologo à la commande de lancement de votre terminal." "instruct"
DisplayMessage 'Par exemple : "C:\Program Files\PowerShell\7\pwsh.exe" -nologo' "instruct"
Write-Host ""
DisplayMessage "N'oubliez pas de changer la police du terminal par celle que vous avez télécharger (elle fini par 'Nerd Font')" "instruct"
Write-Host ""

pause