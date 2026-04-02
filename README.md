# Dotfiles

Personal development environment configuration.

## Setup

On a fresh machine:

```bash
xcode-select --install
curl -fsSL https://raw.githubusercontent.com/RafaelMurad/dotfiles/main/setup | zsh
```

Or clone manually (requires SSH keys already configured):

```bash
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
7. Optionally applies macOS system preferences
8. Optionally sets up a work profile

## Updating

Run `dot` to update everything at once:

```bash
dot            # Pull dotfiles, upgrade Homebrew, update Volta globals, update Oh My Zsh
dot --macos    # Also re-apply macOS defaults
```

## Work Profile

Run `./setup-work-profile` anytime to add a work identity:

- Separate git config auto-applied by project directory (`includeIf`)
- Separate SSH key routed to work Git host
- Handles same-host (github.com) and enterprise host scenarios
- Optional GitHub CLI auth and VS Code profile alias

## Clone Repos

After setup, clone all personal GitHub repos into `~/code`:

```bash
./clone-repos
```

## What's Included

| Category | Tools |
|----------|-------|
| Shell | zsh + Oh My Zsh, aliases, functions, pnpm, lazy-loaded Google Cloud SDK |
| Node | Volta (node, pnpm, yarn, vercel, playwright-mcp) |
| Git | Sensible defaults, aliases, LFS |
| Editors | VS Code + Cursor (settings, keybindings, 25 extensions) |
| AI | OpenCode, Ollama, Claude Code, GitHub Copilot |
| macOS | Opinionated system defaults (Finder, Dock, keyboard, screenshots) |
| CI | ShellCheck linting on push/PR |

## Customization

- **`~/.extra`** — Source for secrets, tokens, or machine-local overrides (not committed):
  ```bash
  export GITHUB_TOKEN="..."
  export PATH="/custom/path:$PATH"
  ```
- **`.aliases`** / **`.functions`** — Shell aliases and utility functions
- **`.macos`** — macOS system preferences (run standalone anytime)

## What's NOT Here

- SSH private keys (generated during setup)
- Auth tokens / API keys
- `~/.extra` (machine-local, gitignored)
- node_modules or builds
