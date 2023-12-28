# CustomPowershell

This repository contains a PowerShell script named `run.ps1` designed to customize your Powershell.

![winfetch_command](/assets/winfetch.png)
![ls_command](/assets/ls.png)

## How to use it

### Download the repository

* Clone this repository on your local machine using the following command :
```bash
git clone https://github.com/Lindwen/CustomPowershell.git
```

or by downloading the code as a ZIP file and extracting it on your machine.

### Run the script

* Make sure you have [PowerShell](https://github.com/PowerShell/PowerShell/releases) installed on your system.

#### Important ! Before running the script :

Before running this script, you need to change the execution policy of PowerShell.

To do so, run the following commands in PowerShell as an administrator.
```powershell
Get-ExecutionPolicy # Remember the result, it's your current script execution policy
Set-ExecutionPolicy unrestricted # Allow the execution of unsigned scripts, since this one is not signed.
# Run the script, as indicated below.
Set-ExecutionPolicy <result of Get-ExecutionPolicy> # Return to the old script execution policy.
```

* Navigate to the directory where you cloned or extracted this repository.
* Run the run.ps1 script using the following command :
```powershell
.\run.ps1
```