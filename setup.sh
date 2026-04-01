#!/usr/bin/env zsh
# setup.sh - Symlink dotfiles and configure environment
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== Dotfiles Setup ==="
echo "Source: $DOTFILES_DIR"
echo ""

# -------------------------------------------------------
# Helper: backup existing file and create symlink
# -------------------------------------------------------
backup_and_link() {
  local src="$1"
  local dest="$2"

  if [[ -L "$dest" ]]; then
    rm "$dest"
  elif [[ -f "$dest" ]]; then
    echo "   Backing up $(basename "$dest") -> $(basename "$dest").bak"
    mv "$dest" "${dest}.bak"
  fi

  ln -sf "$src" "$dest"
  echo "   Linked $(basename "$dest")"
}

# -------------------------------------------------------
# 1. Shell configs
# -------------------------------------------------------
echo ">> Linking shell configs..."
backup_and_link "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
backup_and_link "$DOTFILES_DIR/.zprofile" "$HOME/.zprofile"
backup_and_link "$DOTFILES_DIR/.zshenv" "$HOME/.zshenv"
echo ""

# -------------------------------------------------------
# 2. Git configs
# -------------------------------------------------------
echo ">> Linking git configs..."
backup_and_link "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
backup_and_link "$DOTFILES_DIR/.gitignore" "$HOME/.gitignore_global"
git config --global core.excludesfile "$HOME/.gitignore_global"
echo ""

# -------------------------------------------------------
# 3. SSH config
# -------------------------------------------------------
echo ">> Linking SSH config..."
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
backup_and_link "$DOTFILES_DIR/.ssh/config" "$HOME/.ssh/config"
echo ""

# -------------------------------------------------------
# 4. GitHub CLI config
# -------------------------------------------------------
echo ">> Linking GitHub CLI config..."
mkdir -p "$HOME/.config/gh"
backup_and_link "$DOTFILES_DIR/gh/config.yml" "$HOME/.config/gh/config.yml"
echo ""

# -------------------------------------------------------
# 5. VS Code settings
# -------------------------------------------------------
echo ">> Linking VS Code settings..."
VSCODE_USER="$HOME/Library/Application Support/Code/User"
mkdir -p "$VSCODE_USER"
backup_and_link "$DOTFILES_DIR/vscode/settings.json" "$VSCODE_USER/settings.json"
backup_and_link "$DOTFILES_DIR/vscode/keybindings.json" "$VSCODE_USER/keybindings.json"
echo ""

# -------------------------------------------------------
# 6. Cursor settings
# -------------------------------------------------------
echo ">> Linking Cursor settings..."
CURSOR_USER="$HOME/Library/Application Support/Cursor/User"
mkdir -p "$CURSOR_USER"
backup_and_link "$DOTFILES_DIR/cursor/settings.json" "$CURSOR_USER/settings.json"
echo ""

# -------------------------------------------------------
# 7. SSH key generation (personal)
# -------------------------------------------------------
if [[ ! -f "$HOME/.ssh/id_ed25519" ]]; then
  echo ">> Generating personal SSH key..."
  ssh-keygen -t ed25519 -C "rflmurad@gmail.com" -f "$HOME/.ssh/id_ed25519" -N ""
  echo ""

  # Copy public key to clipboard
  if command -v pbcopy &>/dev/null; then
    pbcopy < "$HOME/.ssh/id_ed25519.pub"
    echo "   Public key copied to clipboard!"
  else
    echo "   Public key:"
    cat "$HOME/.ssh/id_ed25519.pub"
  fi
  echo "   Add it to: https://github.com/settings/keys"
  echo ""
else
  echo ">> Personal SSH key already exists. Skipping."
  echo ""
fi

# -------------------------------------------------------
# 8. GitHub CLI auth
# -------------------------------------------------------
if ! gh auth status &>/dev/null 2>&1; then
  echo ">> Authenticate GitHub CLI with your personal account:"
  gh auth login
  echo ""
else
  echo ">> GitHub CLI already authenticated."
  echo ""
fi

# -------------------------------------------------------
# 9. Prompt for work profile setup
# -------------------------------------------------------
echo ""
read -q "REPLY?>> Set up a work profile? (y/n) "
echo ""
if [[ "$REPLY" == "y" ]]; then
  "$DOTFILES_DIR/setup-work-profile.sh"
else
  echo "   Skipped. Run ./setup-work-profile.sh anytime to set up later."
fi

echo ""
echo "=== Setup complete! ==="
echo "Restart your terminal: exec zsh"
