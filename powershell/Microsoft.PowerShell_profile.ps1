<#
    This file shoud be copied here: "$PROFILE"
#>

# If it is not an interactive prompt, useless to load the profile
if (!([Environment]::UserInteractive -and -not $([Environment]::GetCommandLineArgs() | Where-Object { $_ -like '-NonI*' }))) {
    return
}

###############################################################################
## FONCTIONS
###############################################################################
$prj = "D:\Projects"

###############################################################################
## FONCTIONS
###############################################################################
function Test-Administrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}
function Invoke-DcHere {
    dc -C --no-splash -T $(Get-Location)
}
function Edit-Profile {
    code $PROFILE
}
function Invoke-LogOff {
    shutdown /l
}
function Invoke-Halt {
    shutdown -s -t 0
}
function Invoke-Aws {
	$pem = "C:\Users\jibedoubleve\Documents\Lanceur2\oss_key.pem"
	ssh -i $pem ubuntu@ec2-15-237-113-93.eu-west-3.compute.amazonaws.com
}
function Get-Colors {
    Write-Host ""
    [System.Enum]::GetValues("consolecolor") | % {
        Write-Host "          " -BackgroundColor $_ -NoNewline
        Write-Host " $_" 
    }
    Write-Host ""
}
function Invoke-Projects {
    fd --type f .sln D:\Projects\ --follow --hidden --exclude .git | fzf --bind "enter:execute(rider64.exe {})"
}
function Search-Projects {
    Push-Location
    Set-Location $p.prj

    $sln = fd --type f .sln D:\Projects\ --follow --hidden --exclude .git --exclude _BACKUPS | fzf --prompt 'Solution files> '  --header-first
    
    if ($null -eq $sln) {
        Write-Host "No solution file selected" -ForegroundColor Red
        return;
    }
    $sln = Resolve-Path $sln
    Set-Location $([System.IO.Path]::GetDirectoryName($sln))    
}

###############################################################################
## IMPORTS
###############################################################################
Write-Host "Configuring Terminal-Icons...`t`t" -NoNewline 
    Import-Module Terminal-Icons
Write-Host "OK" -ForegroundColor Green
###############################################################################
## MODULE CONFIGURATION
###############################################################################
Write-Host "Configuring Oh my posh...`t`t" -NoNewline 
    $theme = "C:\Users\jibedoubleve\AppData\Local\Programs\oh-my-posh\themes\hunk.modified.omp.json"
    # $theme = "C:\Users\jibedoubleve\AppData\Local\Programs\oh-my-posh\themes\jibedoubleve.json"
    # $theme = "C:\Users\jibedoubleve\AppData\Local\Programs\oh-my-posh\themes\ys.omp.json"
    oh-my-posh init pwsh --config $theme | Invoke-Expression
Write-Host "OK" -ForegroundColor Green

Write-Host "Configuring PSReadline...`t`t" -NoNewline
    Import-Module PSReadLine
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle ListView
    Set-PSReadLineOption -EditMode Windows
Write-Host "OK" -ForegroundColor Green

Write-Host "Configuring F7History...`t`t" -NoNewline 
    Import-Module -Name "F7History"
    Write-Host "OK" -ForegroundColor Green

#####
# Chocolatey
#####
# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
try {
    $totalTime = (
        Measure-Command {
            $ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
            if (Test-Path($ChocolateyProfile)) {
                Write-Host "Importing Chocolatey profile...`t`t" -NoNewline
                Import-Module "$ChocolateyProfile"
                Write-Host "Done!" -ForegroundColor Green -NoNewLine
            }
        }).TotalMilliseconds
    Write-Host " ($totalTime ms)"
}
catch {
    Write-Host "ERROR: $($_)" -ForegroundColor Red -BackgroundColor Yellow
}
###############################################################################
## ALIASES
###############################################################################
Set-Alias dc     "C:\Program Files\Double Commander\doublecmd.exe"
Set-Alias dch    Invoke-DcHere
Set-Alias logoff Invoke-LogOff
Set-Alias halt   Invoke-Halt
Set-Alias npp    "C:\Program Files\Notepad++\notepad++.exe"
Set-Alias c      code
Set-Alias g      git
Set-Alias dn     dotnet
Set-Alias rider  rider64.exe
Set-Alias rr     rider64.exe
Set-Alias m      micro.exe
Set-Alias lg     lazygit.exe
Set-Alias aws    Invoke-Aws
Set-Alias btop   "C:\_Tools\btop4win\btop4win.exe"
Set-Alias csr    csharprepl
Set-Alias lpr    Invoke-Projects
Set-Alias lsp    Search-Projects 
Set-Alias far    "C:\Program Files\Far Manager\Far.exe"

# Alias Functions
function fnd($query) {
    fd $query `
        --type file `
        --follow --hidden `
        --exclude .git 
    | fzf --prompt 'Search file: ' `
        --header-first `
        --preview 'bat --color=always {} --style=plain'    
}
function notepad($file) {
    &"$env:ProgramFiles\Notepad++\notepad++.exe" $file
}

###############################################################################
## CONFIGURATION
###############################################################################
# if ($env:WT_SESSION) {
#     Set-Theme Paradox
# }
