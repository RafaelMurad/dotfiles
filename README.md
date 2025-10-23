# Dotfiles

My development environment configuration.

## Fresh Machine Setup

### 1. Install Xcode Command Line Tools
```bash
xcode-select --install
```

### 2. Clone this repo
```bash
cd ~
git clone <your-repo-url> dotfiles
cd dotfiles
```

### 3. Install Homebrew and essential tools
```bash
./install-homebrew.sh
```

### 4. Setup dotfiles
```bash
./setup-dotfiles.sh
```

### 5. Install oh-my-zsh (if you use it)
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### 6. Generate new SSH keys
```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
# Add to GitHub/GitLab
cat ~/.ssh/id_ed25519.pub | pbcopy
```

### 7. Authenticate GitHub CLI (if you use it)
```bash
brew install gh
gh auth login
```

### 8. Restart terminal
```bash
exec zsh
```

## Essential Tools (Jesse's recommendations)
- **Homebrew**: Package manager
- **Volta**: Node version manager (replaces nvm)
- **Git**: Version control
- **fzf**: Fuzzy finder
- **btop**: System monitor
- **Podman**: Container runtime
- **Starship**: Cross-shell prompt

## Copying Projects

If you want to transfer your projects folder:
```bash
# On old machine
rsync -av --progress ~/jet your-new-machine:~/

# Or use external drive
cp -r ~/jet /Volumes/ExternalDrive/
```

## VS Code Settings Sync

VS Code settings sync to your GitHub account automatically.
Just sign in to VS Code on the new machine.

## What's NOT in this repo
- SSH private keys (regenerate on new machine)
- NPM tokens (.npmrc) - set these up fresh
- Any secrets or API keys
- node_modules or project builds
