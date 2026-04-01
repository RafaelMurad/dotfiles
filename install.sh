#!/usr/bin/env zsh
# install.sh - Install Homebrew, dev tools, and runtimes
set -e

echo "=== Development Environment Installer ==="
echo ""

# -------------------------------------------------------
# 1. Homebrew
# -------------------------------------------------------
if ! command -v brew &>/dev/null; then
  echo ">> Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add to PATH for Apple Silicon
  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  echo "   Done."
else
  echo ">> Homebrew already installed. Updating..."
  brew update
fi
echo ""

# -------------------------------------------------------
# 2. Brewfile (formulae, casks, VS Code extensions)
# -------------------------------------------------------
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo ">> Installing packages from Brewfile..."
brew bundle --file="$DOTFILES_DIR/Brewfile"
echo "   Done."
echo ""

# -------------------------------------------------------
# 3. Volta (Node version manager)
# -------------------------------------------------------
if ! command -v volta &>/dev/null; then
  echo ">> Installing Volta..."
  curl https://get.volta.sh | bash -s -- --skip-setup
  export VOLTA_HOME="$HOME/.volta"
  export PATH="$VOLTA_HOME/bin:$PATH"
  echo "   Done."
else
  echo ">> Volta already installed."
fi
echo ""

# -------------------------------------------------------
# 4. Node LTS + global packages via Volta
# -------------------------------------------------------
echo ">> Installing Node LTS via Volta..."
volta install node@lts
echo ""

echo ">> Installing Volta global packages..."
volta install pnpm
volta install yarn
volta install vercel
volta install playwright-mcp
volta install confluence-cli
echo "   Done."
echo ""

# -------------------------------------------------------
# 5. Oh My Zsh
# -------------------------------------------------------
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  echo ">> Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  echo "   Done."
else
  echo ">> Oh My Zsh already installed."
fi
echo ""

# -------------------------------------------------------
# Done
# -------------------------------------------------------
echo "=== Installation complete! ==="
echo ""
echo "Next steps:"
echo "  1. Run ./setup.sh to link dotfiles"
echo "  2. Restart your terminal: exec zsh"
