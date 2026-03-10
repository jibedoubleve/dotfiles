#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

FORCE=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        -f|--force) FORCE=true ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
    shift
done

cyan()   { echo -e "\033[0;36m$*\033[0m"; }
yellow() { echo -e "\033[0;33m$*\033[0m"; }
red()    { echo -e "\033[0;31m$*\033[0m"; }
white()  { echo -e "\033[0;37m$*\033[0m"; }

backup() {
    local dst="$1"
    local bkp="${dst}_backup"

    if [[ ! -e "$dst" || -L "$dst" ]]; then
        return 0
    fi

    if mv "$dst" "$bkp"; then
        cyan "  Backup: $dst -> $bkp"
    else
        red "  FAILED: Backup $dst -> $bkp"
        return 1
    fi
}

link() {
    local src="$1"
    local dst="$2"

    if $FORCE; then
        ln -sf "$src" "$dst"
    else
        ln -s "$src" "$dst"
    fi
    cyan "  Linked: $src -> $dst"
}

install() {
    local src="$1"
    local dst="$2"
    local parent_dir="$(dirname "$dst")"

    if [[ ! -d "$parent_dir" ]]; then
        yellow "  SKIPPED: $src — directory $parent_dir does not exist"
        return 0
    fi

    if [[ ! -e "$src" ]]; then
        yellow "  SKIPPED: $src — source does not exist"
        return 0
    fi

    if backup "$dst"; then
        link "$src" "$dst"
    fi
}

DOTFILES=(
    "$DOTFILES_DIR/git/gitconfig:$HOME/.gitconfig"
    "$DOTFILES_DIR/starship.toml:$HOME/.config/starship.toml"
    "$DOTFILES_DIR/macos/zshrc:$HOME/.zshrc"
    "$DOTFILES_DIR/macos/tmux.conf:$HOME/.tmux.conf"
    "$DOTFILES_DIR/vimrc:$HOME/.vimrc"
)

cyan "Configure Dotfiles..."
for entry in "${DOTFILES[@]}"; do
    src="${entry%%:*}"
    white "  Configuring $(basename "$src")..."
    install "$src" "${entry##*:}"
done

cyan "Configure Delta..."
delta_path="$HOME/.config/delta/themes/catppuccin.gitconfig"
delta_url="https://raw.githubusercontent.com/catppuccin/delta/main/catppuccin.gitconfig"

if [[ ! -f "$delta_path" ]]; then
    mkdir -p "$(dirname "$delta_path")"
    curl -L "$delta_url" -o "$delta_path"
    git config --global include.path "$delta_path"
    cyan "  Linked: $delta_path"
else
    yellow "  SKIPPED: already configured"
fi

cyan "Configure Bat..."
bat_themes_path="$(bat --config-dir)/themes"
bat_url="https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin%20Mocha.tmTheme"

if [[ ! -d "$bat_themes_path" ]]; then
    mkdir -p "$bat_themes_path"
    curl -L "$bat_url" -o "$bat_themes_path/Catppuccin Mocha.tmTheme"
    bat cache --build
    cyan "  Theme installed: Catppuccin Mocha"
else
    yellow "  SKIPPED: already configured"
fi
