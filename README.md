# CustomPowershell

Ce dépôt contient un script PowerShell nommé `run.ps1` conçu pour customiser votre Powershell.

![winfetch_command](/assets/winfetch.png)
![ls_command](/assets/ls.png)

## Comment l'utiliser

### Téléchargement du dépôt

* Clonez ce dépôt sur votre machine locale en utilisant la commande suivante :
```bash
git clone https://github.com/Lindwen/CustomPowershell.git
```
ou en téléchargeant le code en tant que fichier ZIP et en l'extrayant sur votre machine.

### Exécution du script

* Assurez-vous d'avoir [PowerShell](https://github.com/PowerShell/PowerShell/releases) installé sur votre système (Atention, PowerShell != Windows PowerShell).

#### Important ! Avant d'exécuter le script :
Avant d'exécuter ce script, il faut changer la politique d'exécution des scripts de PowerShell.
Pour le faire, exécuter les commandes suivantes dans PowerShell (pas Windows PowerShell) en tant qu'administrateur.
```powershell
Get-ExecutionPolicy # Retenez bien le résultat, c'est votre politique d'exécution des scripts actuelle
Set-ExecutionPolicy unrestricted # Autorise l'exécution de scripts non signés, étant donné que celui là ne l'est pas.
# Exécuter le script, comme indiqué ci dessous.
Set-ExecutionPolicy <resultat du Get-ExecutionPolicy> # Retourne sur l'ancienne politique d'exécution des scripts.
``` 
* Naviguez jusqu'au répertoire où vous avez cloné ou extrait ce dépôt.
* Exécutez le script run.ps1 en utilisant la commande suivante :
```powershell
.\run.ps1
```
