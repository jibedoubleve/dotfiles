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

copy_file() {
    local src="$1"
    local dst="$2"

    if $FORCE; then
        cp -f "$src" "$dst"
    else
        cp "$src" "$dst"
    fi
    cyan "  Copied: $src -> $dst"
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

    if [[ -L "$dst" ]]; then
        rm "$dst"
    fi

    if backup "$dst"; then
        copy_file "$src" "$dst"
    fi
}

DOTFILES=(
    "$DOTFILES_DIR/common/gitconfig:$HOME/.gitconfig"
    "$DOTFILES_DIR/common/starship.toml:$HOME/.config/starship.toml"
    "$DOTFILES_DIR/common/vimrc:$HOME/.vimrc"
    "$DOTFILES_DIR/common/lazygit.yml:$HOME/Library/Application Support/lazygit/config.yml"
    "$DOTFILES_DIR/macos/zshrc:$HOME/.zshrc"
    "$DOTFILES_DIR/macos/tmux.conf:$HOME/.tmux.conf"
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

cyan "Configure Vim Lightline..."
lightline_path="$HOME/.vim/pack/plugins/start/lightline"
lightline_url="https://github.com/itchyny/lightline.vim"

if [[ ! -d "$lightline_path" ]]; then
    git clone "$lightline_url" "$lightline_path"
    rm -rf "$lightline_path/.git"
    cyan "  Installed: $lightline_path"
else
    yellow "  SKIPPED: already configured"
fi

cyan "Configure Vim Catppuccin theme..."
vim_colors_path="$HOME/.vim/colors/catppuccin_mocha.vim"
vim_theme_url="https://raw.githubusercontent.com/catppuccin/vim/main/colors/catppuccin_mocha.vim"

if [[ ! -f "$vim_colors_path" ]]; then
    mkdir -p "$(dirname "$vim_colors_path")"
    curl -L "$vim_theme_url" -o "$vim_colors_path"
    cyan "  Theme installed: $vim_colors_path"
else
    yellow "  SKIPPED: already configured"
fi
