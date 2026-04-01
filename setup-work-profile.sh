#!/usr/bin/env zsh
# setup-work-profile.sh - Interactive work profile setup wizard
# Can be run standalone at any time: ./setup-work-profile.sh
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo ""
echo "========================================="
echo "       Work Profile Setup Wizard"
echo "========================================="
echo ""

# -------------------------------------------------------
# 1. Work identity
# -------------------------------------------------------
echo "--- Step 1: Work Identity ---"
echo ""

# Get current git user.name as default
DEFAULT_NAME=$(git config --global user.name 2>/dev/null || echo "Rafael Murad")

read "work_name?   Full name [$DEFAULT_NAME]: "
work_name="${work_name:-$DEFAULT_NAME}"

read "work_email?   Work email (required): "
if [[ -z "$work_email" ]]; then
  echo "   Error: Work email is required."
  exit 1
fi

read "work_dir?   Work projects directory [~/work]: "
work_dir="${work_dir:-$HOME/work}"
# Expand ~ if used
work_dir="${work_dir/#\~/$HOME}"

mkdir -p "$work_dir"
echo ""
echo "   Name:      $work_name"
echo "   Email:     $work_email"
echo "   Directory: $work_dir"
echo ""

# -------------------------------------------------------
# 2. SSH key generation
# -------------------------------------------------------
echo "--- Step 2: SSH Key ---"
echo ""

WORK_KEY="$HOME/.ssh/id_ed25519_work"

if [[ -f "$WORK_KEY" ]]; then
  echo "   Work SSH key already exists at $WORK_KEY"
  read -q "REPLY?   Regenerate it? (y/n) "
  echo ""
  if [[ "$REPLY" == "y" ]]; then
    rm -f "$WORK_KEY" "${WORK_KEY}.pub"
  else
    echo "   Keeping existing key."
    SKIP_KEYGEN=true
  fi
fi

if [[ "$SKIP_KEYGEN" != "true" ]]; then
  read -q "REPLY?   Generate a work SSH key? (y/n) "
  echo ""
  if [[ "$REPLY" == "y" ]]; then
    ssh-keygen -t ed25519 -C "$work_email" -f "$WORK_KEY" -N ""
    echo ""

    if command -v pbcopy &>/dev/null; then
      pbcopy < "${WORK_KEY}.pub"
      echo "   Public key copied to clipboard!"
    else
      echo "   Public key:"
      cat "${WORK_KEY}.pub"
    fi
    echo "   Add this key to your work Git host before continuing."
    echo ""
    read "?   Press Enter when done..."
  else
    echo "   Skipped SSH key generation."
  fi
fi
echo ""

# -------------------------------------------------------
# 3. Git host configuration
# -------------------------------------------------------
echo "--- Step 3: Git Host ---"
echo ""

read "work_host?   Work Git host (e.g., github.com, gitlab.company.com) [github.com]: "
work_host="${work_host:-github.com}"

SSH_CONFIG="$HOME/.ssh/config"

if [[ "$work_host" == "github.com" ]]; then
  # Same host as personal -- use SSH alias
  SSH_HOST_ALIAS="github.com-work"
  echo ""
  echo "   Since your work also uses github.com, we'll create an SSH alias."
  echo "   Clone work repos as: git@github.com-work:org/repo.git"
  echo ""

  # Check if alias already exists
  if grep -q "Host $SSH_HOST_ALIAS" "$SSH_CONFIG" 2>/dev/null; then
    echo "   SSH alias '$SSH_HOST_ALIAS' already exists in ~/.ssh/config. Skipping."
  else
    cat >> "$SSH_CONFIG" << EOF

# Work profile (github.com via alias)
Host $SSH_HOST_ALIAS
  HostName github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile $WORK_KEY
EOF
    echo "   Added SSH alias '$SSH_HOST_ALIAS' to ~/.ssh/config"
  fi
else
  # Different host
  SSH_HOST_ALIAS="$work_host"

  if grep -q "Host $work_host" "$SSH_CONFIG" 2>/dev/null; then
    echo "   Host '$work_host' already exists in ~/.ssh/config. Skipping."
  else
    # Fetch host keys
    echo "   Fetching SSH host keys for $work_host..."
    ssh-keyscan -H "$work_host" >> "$HOME/.ssh/known_hosts" 2>/dev/null || true

    cat >> "$SSH_CONFIG" << EOF

# Work profile
Host $work_host
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile $WORK_KEY
EOF
    echo "   Added host '$work_host' to ~/.ssh/config"
  fi
fi
echo ""

# -------------------------------------------------------
# 4. Git config (conditional identity)
# -------------------------------------------------------
echo "--- Step 4: Git Config ---"
echo ""

WORK_GITCONFIG="$HOME/.gitconfig-work"

# Create work gitconfig
cat > "$WORK_GITCONFIG" << EOF
[user]
    name = $work_name
    email = $work_email
EOF
echo "   Created $WORK_GITCONFIG"

# Add conditional include to main .gitconfig (if not already present)
# Normalize work_dir to use ~ for the gitdir pattern
work_dir_pattern="${work_dir/#$HOME/~}/"

if grep -q "gitdir:${work_dir_pattern}" "$HOME/.gitconfig" 2>/dev/null; then
  echo "   Conditional include for $work_dir_pattern already exists. Skipping."
else
  cat >> "$HOME/.gitconfig" << EOF

# Work profile
[includeIf "gitdir:${work_dir_pattern}"]
    path = ~/.gitconfig-work
EOF
  echo "   Added includeIf for $work_dir_pattern to ~/.gitconfig"
fi

echo "   All repos cloned under $work_dir/ will use your work identity."
echo ""

# -------------------------------------------------------
# 5. GitHub CLI auth (optional)
# -------------------------------------------------------
echo "--- Step 5: GitHub CLI (optional) ---"
echo ""

read -q "REPLY?   Authenticate gh CLI with work account on $work_host? (y/n) "
echo ""
if [[ "$REPLY" == "y" ]]; then
  if [[ "$work_host" == "github.com" ]]; then
    echo "   Note: This will add a second account to gh for github.com."
    gh auth login --hostname github.com
  else
    gh auth login --hostname "$work_host"
  fi
  echo ""
else
  echo "   Skipped."
fi
echo ""

# -------------------------------------------------------
# 6. VS Code profile alias (optional)
# -------------------------------------------------------
echo "--- Step 6: VS Code Work Alias (optional) ---"
echo ""

read -q "REPLY?   Create a VS Code alias for work? (y/n) "
echo ""
if [[ "$REPLY" == "y" ]]; then
  read "vscode_profile?   VS Code profile name [work]: "
  vscode_profile="${vscode_profile:-work}"

  ALIAS_LINE="alias codework=\"code --profile \\\"$vscode_profile\\\"\""

  # Add to .zshrc if not already present
  if grep -q "alias codework=" "$HOME/.zshrc" 2>/dev/null; then
    echo "   Alias 'codework' already exists in .zshrc. Skipping."
  else
    echo "$ALIAS_LINE" >> "$HOME/.zshrc"
    echo "   Added alias: codework -> code --profile \"$vscode_profile\""
  fi
  echo ""
else
  echo "   Skipped."
fi
echo ""

# -------------------------------------------------------
# Summary
# -------------------------------------------------------
echo "========================================="
echo "       Work Profile Setup Complete"
echo "========================================="
echo ""
echo "   Name:      $work_name"
echo "   Email:     $work_email"
echo "   Directory: $work_dir"
echo "   Git host:  $work_host"
echo "   SSH key:   $WORK_KEY"
echo ""
echo "   All repos cloned under $work_dir/ will"
echo "   automatically use your work identity."
echo ""
if [[ "$work_host" == "github.com" ]]; then
  echo "   Clone work repos with:"
  echo "     git clone git@github.com-work:org/repo.git $work_dir/repo"
  echo ""
fi
echo "   Restart your terminal: exec zsh"
