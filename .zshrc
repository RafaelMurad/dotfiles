# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# VS Code profile alias
alias code-personal="code --profile \"personal\""

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Google Cloud SDK (dynamic version path)
if [ -d "/opt/homebrew/Caskroom/gcloud-cli" ]; then
  _gcloud_sdk=$(ls -d /opt/homebrew/Caskroom/gcloud-cli/*/google-cloud-sdk 2>/dev/null | tail -1)
  if [ -n "$_gcloud_sdk" ]; then
    source "$_gcloud_sdk/path.zsh.inc"
    source "$_gcloud_sdk/completion.zsh.inc"
  fi
  unset _gcloud_sdk
fi

# Local binaries
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# Aliases
alias oc="opencode"

# Work profile aliases (added by setup-work-profile.sh)
