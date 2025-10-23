#!/usr/bin/env zsh
# Install Homebrew and essential packages

set -e

# Install Homebrew if not present
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  
  # Add to PATH for Apple Silicon
  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi

# Essential packages (as per Jesse's recommendations)
echo "Installing essential packages..."
brew install git
brew install fzf
brew install btop

# Volta (Node version manager)
if ! command -v volta &>/dev/null; then
  echo "Installing Volta..."
  curl https://get.volta.sh | bash
fi

# Podman (Docker alternative)
brew install podman

# Starship prompt
brew install starship

echo "✓ Essential packages installed!"
echo ""
echo "Next: Run ./setup-dotfiles.sh to link dotfiles"
