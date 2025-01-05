##########################################################################
## ALIASES
###############################################################################
Set-Alias dc     "C:\Program Files\Double Commander\doublecmd.exe"
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

##########################################################################
## ALIASES FUNCTIONS
###############################################################################
function ghb { gh browse }
function halt { shutdown -s -t 0 }
function logoff { shutdown /l }
function dch { dc -C --no-splash -T $(Get-Location) }
function ghb { gh browse }
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