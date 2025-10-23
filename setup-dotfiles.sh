#!/usr/bin/env zsh
# Setup dotfiles on new machine

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "▶ Setting up dotfiles from: $DOTFILES_DIR"

# Backup existing files
backup_and_link() {
  local file=$1
  if [[ -f "$HOME/$file" ]] && [[ ! -L "$HOME/$file" ]]; then
    echo "  Backing up existing $file to ${file}.bak"
    mv "$HOME/$file" "$HOME/${file}.bak"
  fi
  ln -sf "$DOTFILES_DIR/$file" "$HOME/$file"
  echo "  ✓ Linked $file"
}

# Link dotfiles
echo "▶ Linking dotfiles..."
backup_and_link .zshrc
backup_and_link .zprofile
backup_and_link .zshenv
backup_and_link .gitconfig
backup_and_link .gitignore_global

# SSH config
if [[ -f "$DOTFILES_DIR/.ssh/config" ]]; then
  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"
  ln -sf "$DOTFILES_DIR/.ssh/config" "$HOME/.ssh/config"
  echo "  ✓ Linked SSH config"
fi

# Oh My Zsh custom
if [[ -d "$DOTFILES_DIR/oh-my-zsh-custom" ]] && [[ -d "$HOME/.oh-my-zsh" ]]; then
  cp -r "$DOTFILES_DIR/oh-my-zsh-custom/"* "$HOME/.oh-my-zsh/custom/"
  echo "  ✓ Copied oh-my-zsh custom configs"
fi

# VS Code settings
if [[ -d "$DOTFILES_DIR/vscode" ]]; then
  VSCODE_USER="$HOME/Library/Application Support/Code/User"
  mkdir -p "$VSCODE_USER"
  [[ -f "$DOTFILES_DIR/vscode/settings.json" ]] && ln -sf "$DOTFILES_DIR/vscode/settings.json" "$VSCODE_USER/settings.json"
  [[ -f "$DOTFILES_DIR/vscode/keybindings.json" ]] && ln -sf "$DOTFILES_DIR/vscode/keybindings.json" "$VSCODE_USER/keybindings.json"
  [[ -d "$DOTFILES_DIR/vscode/snippets" ]] && ln -sf "$DOTFILES_DIR/vscode/snippets" "$VSCODE_USER/snippets"
  echo "  ✓ Linked VS Code settings"
  
  # Install extensions
  if [[ -f "$DOTFILES_DIR/vscode/extensions.txt" ]] && command -v code &>/dev/null; then
    echo "▶ Installing VS Code extensions..."
    while IFS= read -r ext; do
      code --install-extension "$ext" --force 2>/dev/null || true
    done < "$DOTFILES_DIR/vscode/extensions.txt"
    echo "  ✓ VS Code extensions installed"
  fi
fi

echo ""
echo "✓ Dotfiles setup complete!"
echo ""
echo "Restart your terminal or run: source ~/.zshrc"
