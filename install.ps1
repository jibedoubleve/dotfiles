#Requires -Version 5.1
$ErrorActionPreference = "Stop"

$DotfilesDir = $PSScriptRoot
$Force = $false

foreach ($arg in $args) {
    if ($arg -eq "-f" -or $arg -eq "--force") {
        $Force = $true
    } else {
        Write-Error "Unknown option: $arg"
        exit 1
    }
}

function Backup-Dotfile {
    param ([string]$Dst)
    $Bkp = "${Dst}_backup"

    if (-not (Test-Path -Path $Dst) -or (Get-Item $Dst -Force).LinkType) {
        return $true
    }

    try {
        Move-Item -Path $Dst -Destination $Bkp -Force
        Write-Host "  Backup: $Dst -> $Bkp" -ForegroundColor Cyan
        return $true
    } catch {
        Write-Host "  FAILED: Backup $Dst -> $Bkp — $_" -ForegroundColor Red
        return $false
    }
}

function Install-Link {
    param (
        [string]$Src,
        [string]$Dst
    )

    $ParentDir = Split-Path -Path $Dst -Parent

    if (-not (Test-Path -Path $ParentDir)) {
        Write-Host "  SKIPPED: $Src — directory $ParentDir does not exist" -ForegroundColor Yellow
        return
    }

    if (-not (Test-Path -Path $Src)) {
        Write-Host "  SKIPPED: $Src — source does not exist" -ForegroundColor Yellow
        return
    }

    if (Backup-Dotfile -Dst $Dst) {
        if ($Force -and (Test-Path -Path $Dst)) {
            Remove-Item -Path $Dst -Force
        }

        $ItemType = if (Test-Path -Path $Src -PathType Container) { "Directory" } else { "Junction" }
        if ($ItemType -eq "Junction") { $ItemType = "SymbolicLink" }

        New-Item -ItemType SymbolicLink -Path $Dst -Target $Src | Out-Null
        Write-Host "  Linked: $Src -> $Dst" -ForegroundColor Cyan
    }
}

# Dotfiles: each entry is @(Source, Destination)
$Dotfiles = @(
    @("$DotfilesDir\git\gitconfig"         , "$HOME\.gitconfig"),
    @("$DotfilesDir\starship.toml"         , "$HOME\.config\starship.toml"),
    @("$DotfilesDir\powershell\profile.ps1", "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"),
    @("$DotfilesDir\vimrc"                 , "$HOME\_vimrc")
)

Write-Host "Configure Dotfiles..." -ForegroundColor Cyan
foreach ($Entry in $Dotfiles) {
    $FileName = Split-Path $Entry[0] -Leaf
    Write-Host "  Configuring $FileName..." -ForegroundColor White
    Install-Link -Src $Entry[0] -Dst $Entry[1]
}

Write-Host "Configure Delta..." -ForegroundColor Cyan
$deltaPath = "$HOME/.config/delta/themes/catppuccin.gitconfig"
$deltaUrl = "https://raw.githubusercontent.com/catppuccin/delta/main/catppuccin.gitconfig"

if (-not (Test-Path $deltaPath)) {
    New-Item -ItemType Directory -Force -Path (Split-Path $deltaPath) | Out-Null
    curl.exe -L $deltaUrl -o $deltaPath
    git config --global include.path $deltaPath
    Write-Host "  Linked: $deltaPath" -ForegroundColor Cyan
} else {
    Write-Host "  SKIPPED: already configured" -ForegroundColor Yellow
}

Write-Host "Configure Bat..." -ForegroundColor Cyan
$batThemesPath = "$(bat --config-dir)/themes"
$batUrl = "https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin%20Mocha.tmTheme"

if (-not (Test-Path $batThemesPath)) {
    New-Item -ItemType Directory -Force -Path $batThemesPath | Out-Null
    curl.exe -L $batUrl -o "$batThemesPath/Catppuccin Mocha.tmTheme"
    bat cache --build
    Write-Host "  Theme installed: Catppuccin Mocha" -ForegroundColor Cyan
} else {
    Write-Host "  SKIPPED: already configured" -ForegroundColor Yellow
}
