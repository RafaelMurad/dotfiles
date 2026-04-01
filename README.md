# Dotfiles

Personal development environment configuration.

## Fresh Machine Setup

```bash
# 1. Install Xcode CLI tools
xcode-select --install

# 2. Clone this repo
git clone git@github.com:RafaelMurad/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 3. Install tools (Homebrew, packages, Volta, Oh My Zsh)
./install.sh

# 4. Link dotfiles, generate SSH key, configure environment
./setup.sh

# 5. Restart terminal
exec zsh
```

## What's Included

- **Shell**: zsh + Oh My Zsh, pnpm, Google Cloud SDK
- **Node**: Volta (node, pnpm, yarn, vercel, playwright-mcp, confluence-cli)
- **Git**: sensible defaults, useful aliases, LFS support
- **Editors**: VS Code + Cursor (settings, keybindings, extensions)
- **Tools**: Homebrew Brewfile with all formulae, casks, and extensions
- **AI**: OpenCode, Ollama, Claude Code, GitHub Copilot
- **SSH**: ed25519 key generation + GitHub config

## Work Profile

Run `./setup-work-profile.sh` anytime to add a work identity:

- Separate git identity (auto-applied by project directory via `includeIf`)
- Separate SSH key for work Git host
- Handles same-host (github.com) and enterprise host scenarios
- Optional: GitHub CLI auth, VS Code profile alias

## Repo Structure

```
dotfiles/
├── .gitconfig              # Git config (personal identity default)
├── .gitignore              # Global gitignore rules
├── .ssh/config             # SSH host configuration
├── .zprofile               # Homebrew env init
├── .zshenv                 # Volta PATH setup
├── .zshrc                  # Shell config (Oh My Zsh, aliases, tools)
├── Brewfile                # Homebrew packages, casks, and VS Code extensions
├── cursor/settings.json    # Cursor editor settings
├── gh/config.yml           # GitHub CLI preferences
├── install.sh              # Install Homebrew + all tools
├── setup.sh                # Symlink dotfiles + SSH key + work profile prompt
├── setup-work-profile.sh   # Interactive work profile wizard
└── vscode/
    ├── keybindings.json    # VS Code keybindings
    └── settings.json       # VS Code settings
```

## What's NOT in this repo

- SSH private keys (generated during setup)
- Auth tokens / API keys
- node_modules or project builds
