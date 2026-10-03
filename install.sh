#!/bin/bash

DOTFILES_DIR="$PWD"

mkdir -p "$HOME/.config"

link_item() {
    local rel_path="$1"
    local target_path="$HOME/$rel_path"
    local source_path="$DOTFILES_DIR/$rel_path"

    if [ ! -e "$source_path" ]; then
        echo "[SKIP] Source file/directory does not exist: $source_path"
        return
    fi

    echo "Processing: $rel_path"

    if [ -e "$target_path" ] || [ -L "$target_path" ]; then
        echo "  -> Moving $target_path to ${target_path}_tmp"
        mv "$target_path" "${target_path}_tmp"
    fi

    echo "  -> Creating symlink: $target_path -> $source_path"
    ln -s "$source_path" "$target_path"

    if [ -e "${target_path}_tmp" ] || [ -L "${target_path}_tmp" ]; then
        echo "  -> Deleting temporary item: ${target_path}_tmp"
        rm -rf "${target_path}_tmp"
    fi

    echo "  -> Done!"
    echo "----------------------------------------"
}

config_items=(
    ".config/catppuccin-zsh"
    ".config/kitty"
    ".config/sway"
    ".config/waybar"
    ".config/wofi"
    ".config/Code/User/keybindings.json"
    ".config/Code/User/settings.json"
    ".config/systemd/user/waybar.service"
)

for item in "${config_items[@]}"; do
    link_item "$item"
done

home_files=(
    ".gitconfig"
    ".p10k.zsh"
    ".zshrc"
)

for file in "${home_files[@]}"; do
    link_item "$file"
done

echo "All symlinks configured successfully!"
