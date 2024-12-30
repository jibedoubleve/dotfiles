###############################################################################
## FONCTIONS
###############################################################################

function Test-Administrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}
function Edit-Profile {
    code $PROFILE
}
function Invoke-Aws {
	$pem = "C:\Users\jibedoubleve\Documents\Lanceur2\oss_key.pem"
	ssh -i $pem ubuntu@ec2-15-237-113-93.eu-west-3.compute.amazonaws.com
}
function Invoke-Projects {
    fd --type f .sln D:\Projects\ --follow --hidden --exclude .git | fzf --bind "enter:execute(rider64.exe {})"
}
function Get-Colors {
    Write-Host ""
    [System.Enum]::GetValues("consolecolor") | % {
        Write-Host "          " -BackgroundColor $_ -NoNewline
        Write-Host " $_" 
    }
    Write-Host ""
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
function Measure-Execution($action, $title) {
    Write-Host "$title ...`t`t" -NoNewline     
    try {
        $totalTime = (
            Measure-Command {                
                &$action
                Write-Host " Done" -ForegroundColor Green -NoNewline
            }).TotalMilliseconds
        Write-Host " in $([Math]::Round($totalTime)) ms"
    } catch {
        Write-Host "ERROR: $($_)" -ForegroundColor Red -BackgroundColor Yellow
    }  
}