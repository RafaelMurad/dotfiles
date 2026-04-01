# Dotfiles

Personal development environment configuration.

## Setup

```bash
xcode-select --install
git clone git@github.com:RafaelMurad/dotfiles.git ~/dotfiles
~/dotfiles/setup
```

That's it. The `setup` script handles everything:
1. Installs Homebrew + all packages from `Brewfile`
2. Installs Volta, Node LTS, pnpm, yarn, vercel, playwright-mcp, confluence-cli
3. Installs Oh My Zsh
4. Symlinks all configs (shell, git, SSH, VS Code, Cursor, gh)
5. Generates SSH key and copies public key to clipboard
6. Authenticates GitHub CLI
7. Optionally sets up a work profile

## Work Profile

Run `./setup-work-profile` anytime to add a work identity:

- Separate git config auto-applied by project directory (`includeIf`)
- Separate SSH key routed to work Git host
- Handles same-host (github.com) and enterprise host scenarios
- Optional GitHub CLI auth and VS Code profile alias

## What's Included

| Category | Tools |
|----------|-------|
| Shell | zsh + Oh My Zsh, pnpm, Google Cloud SDK |
| Node | Volta (node, pnpm, yarn, vercel, playwright-mcp) |
| Git | Sensible defaults, aliases, LFS |
| Editors | VS Code + Cursor (settings, keybindings, 25 extensions) |
| AI | OpenCode, Ollama, Claude Code, GitHub Copilot |

## What's NOT Here

- SSH private keys (generated during setup)
- Auth tokens / API keys
- node_modules or builds
