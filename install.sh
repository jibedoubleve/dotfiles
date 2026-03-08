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

backup() {
    local dst="$1"
    local bkp="${dst}_backup"

    if [[ ! -e "$dst" || -L "$dst" ]]; then
        echo "No backup needed, dotfile exists."
        return 0
    fi

    if mv "$dst" "$bkp" ;then
        echo "Backup $dst -> $bkp"
    else
        echo "FAILED: Backup $dst -> $bkp"
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
    echo "Linked: $src -> $dst"
}

install() {
    local src="$1"
    local dst="$2"
    local parent_dir="$(dirname "$dst")"

    if [[ ! -d "$parent_dir" ]]; then
        echo "SKIPPED: $src — directory $parent_dir does not exist"
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
    "$DOTFILES_DIR/macos/vimrc:$HOME/.vimrc"
)

for entry in "${DOTFILES[@]}"; do
    install "${entry%%:*}" "${entry##*:}"
done

