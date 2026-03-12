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

function Install-Copy {
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

    if ((Test-Path -Path $Dst) -and (Get-Item $Dst -Force).LinkType) {
        Remove-Item -Path $Dst -Force
    }

    if (Backup-Dotfile -Dst $Dst) {
        Copy-Item -Path $Src -Destination $Dst -Force:$Force
        Write-Host "  Copied: $Src -> $Dst" -ForegroundColor Cyan
    }
}

# Dotfiles: each entry is @(Source, Destination)
$Dotfiles = @(
    @("$DotfilesDir\common\gitconfig"      , "$HOME\.gitconfig"),
    @("$DotfilesDir\common\starship.toml"  , "$HOME\.config\starship.toml"),
    @("$DotfilesDir\common\vimrc"          , "$HOME\_vimrc"),
    @("$DotfilesDir\common\lazygit.yml"    , "$env:APPDATA\lazygit\config.yml"),
    @("$DotfilesDir\powershell\profile.ps1", "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1")
)

Write-Host "Configure Dotfiles..." -ForegroundColor Cyan
foreach ($Entry in $Dotfiles) {
    $FileName = Split-Path $Entry[0] -Leaf
    Write-Host "  Configuring $FileName..." -ForegroundColor White
    Install-Copy -Src $Entry[0] -Dst $Entry[1]
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

Write-Host "Configure Vim Lightline..." -ForegroundColor Cyan
$lightlinePath = "$HOME\vimfiles\pack\plugins\start\lightline"
$lightlineUrl = "https://github.com/itchyny/lightline.vim"

if (-not (Test-Path $lightlinePath)) {
    git clone $lightlineUrl $lightlinePath
    Remove-Item -Recurse -Force "$lightlinePath\.git"
    Write-Host "  Installed: $lightlinePath" -ForegroundColor Cyan
} else {
    Write-Host "  SKIPPED: already configured" -ForegroundColor Yellow
}

Write-Host "Configure Vim Catppuccin theme..." -ForegroundColor Cyan
$vimColorsPath = "$HOME\vimfiles\colors\catppuccin_mocha.vim"
$vimThemeUrl = "https://raw.githubusercontent.com/catppuccin/vim/main/colors/catppuccin_mocha.vim"

if (-not (Test-Path $vimColorsPath)) {
    New-Item -ItemType Directory -Force -Path (Split-Path $vimColorsPath) | Out-Null
    curl.exe -L $vimThemeUrl -o $vimColorsPath
    Write-Host "  Theme installed: $vimColorsPath" -ForegroundColor Cyan
} else {
    Write-Host "  SKIPPED: already configured" -ForegroundColor Yellow
}
