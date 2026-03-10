<#
    This file shoud be copied here: "$PROFILE"
#>

###############################################################################
## IMPORTS
###############################################################################
."$PSScriptRoot\helpers.ps1"
."$PSScriptRoot\aliases.ps1"

###############################################################################
## HEADER
###############################################################################
# If it is not an interactive prompt, useless to load the profile
if (!([Environment]::UserInteractive -and -not $([Environment]::GetCommandLineArgs() | Where-Object { $_ -like '-NonI*' }))) {
    return
}

###############################################################################
## FONCTIONS
###############################################################################
$prj = "D:\Projects"

#####
###############################################################################
## IMPORTS
###############################################################################
Measure-Execution  {
    Import-Module Terminal-Icons
} -Title "Configuring Terminal-Icons"
###############################################################################
## MODULE CONFIGURATION
###############################################################################

Measure-Execution {
   Invoke-Expression (&starship init powershell)    
} -Title "Configuring Starship"

Measure-Execution {
    Import-Module PSReadLine
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle ListView
    Set-PSReadLineOption -EditMode Windows
} -Title "Configuring PSReadline"

Measure-Execution {
    Import-Module -Name "F7History"
} -Title "Configuring F7History"

Measure-Execution {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
} -Title "Configuring Zoxide"

#####
# Chocolatey
#####
# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
Measure-Execution {
    $ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
    if (Test-Path($ChocolateyProfile)) {
        Import-Module "$ChocolateyProfile"
    }
} -Title "Importing Chocolatey profile"

###############################################################################
## CONFIGURATION
###############################################################################
# if ($env:WT_SESSION) {
#     Set-Theme Paradox
# }
