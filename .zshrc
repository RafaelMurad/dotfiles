# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# Dotfiles bin
export PATH="$HOME/dotfiles/bin:$PATH"

# Shell config
[ -f "$HOME/.aliases" ] && source "$HOME/.aliases"
[ -f "$HOME/.functions" ] && source "$HOME/.functions"
[ -f "$HOME/.extra" ] && source "$HOME/.extra"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Google Cloud SDK (lazy-loaded)
if [ -d "/opt/homebrew/Caskroom/gcloud-cli" ]; then
  _load_gcloud() {
    unfunction gcloud gsutil bq 2>/dev/null
    _gcloud_sdk=$(ls -d /opt/homebrew/Caskroom/gcloud-cli/*/google-cloud-sdk 2>/dev/null | tail -1)
    if [ -n "$_gcloud_sdk" ]; then
      source "$_gcloud_sdk/path.zsh.inc"
      source "$_gcloud_sdk/completion.zsh.inc"
    fi
    unset _gcloud_sdk
  }
  gcloud() { _load_gcloud; gcloud "$@" }
  gsutil() { _load_gcloud; gsutil "$@" }
  bq()     { _load_gcloud; bq "$@" }
fi

# Local binaries
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
