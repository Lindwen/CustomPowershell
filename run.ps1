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
            DisplayMessage "Temporary disabling module installation policy." "note"
            Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
        }
        "enable" {
            DisplayMessage "Enable module installation policy." "note"
            Set-ExecutionPolicy -Scope Process -ExecutionPolicy Default
        }
    }
}

if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-File", "$PSCommandPath" -Verb RunAs
    exit
}

cls
DisplayMessage "Installing winget..." "note"
Write-Host ""
DisplayMessage "Please install Microsoft Winget from the Microsoft Store." "instruct"
DisplayMessage "You may need to click manually on the 'Install' button in the Microsoft Store. " "instruct"
Start-Process "ms-windows-store://pdp/?ProductId=9NBLGGH4NNS1"
Write-Host ""
pause

ManageModulePolicy "disable"

DisplayMessage "Installing Winfetch..." "note"
Install-Script -Name winfetch -Force -Confirm:$false

DisplayMessage "Installing Terminal-Icons..." "note"
Install-Module -Name Terminal-Icons -Force -Confirm:$false

ManageModulePolicy "enable"

DisplayMessage "Installing OhMyPosh..." "note"
winget install JanDeDobbeleer.OhMyPosh -s winget
$env:POWERSHELL_MODULES_PATH = $env:PSModulePath -split ';'
Start-Sleep -Seconds 5

DisplayMessage "Font configuration" "note"
Write-Host ""
DisplayMessage "Please select a font to download :" "instruct"
Write-Host ""
oh-my-posh font install --user

ManageModulePolicy "disable"

DisplayMessage "Launching Winfetch" "note"
winfetch
$pathConfigWinfetch = Join-Path -Path $env:UserProfile -ChildPath ".config\winfetch\config.ps1"
Write-Host ""
DisplayMessage "To change the Winfetch configuration, you need to modify this file : $pathConfigWinfetch" "instruct"
Write-Host ""

ManageModulePolicy "enable"

DisplayMessage "Configuring PowerShell profile" "note"
Write-Host ""
DisplayMessage "The current PowerShell configuration will be erased, you may want to back it up." "warn"
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
DisplayMessage "Si vous souhaitez enlever le temps de chargement ajouter -nologo à la commande de lancement de votre terminal. You can add the -nologo to PowerShell's launching arguments if you want to make the loading time shorter." "instruct"
DisplayMessage 'E.g. : "C:\Program Files\PowerShell\7\pwsh.exe" -nologo' "instruct"
Write-Host ""
DisplayMessage "Don't forget to replace your current terminal's font by the one you installed with this script (Its name ends with 'Nerd Font')." "instruct"
Write-Host ""

pause