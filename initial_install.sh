#!/usr/bin/env bash

set -euo pipefail

NODE_VERSION="${NODE_VERSION:-25.7.0}"
PYTHON_VERSION="${PYTHON_VERSION:-3.12}"
RUBY_VERSION="${RUBY_VERSION:-3.3}"

BREW_FORMULAE=(
  ghq
  peco
  fzf
  neovim
  awscli
  aws-vault
  tfenv
  mise
  terraform-ls
  tflint
  actionlint
  lua-language-server
  zsh-autosuggestions
  olets/tap/zsh-abbr
  olets/tap/zsh-autosuggestions-abbreviations-strategy
)

BREW_CASKS=(
  font-hack-nerd-font
)

log() {
  printf '\n[%s] %s\n' "$(date '+%H:%M:%S')" "$*"
}

ensure_homebrew() {
  if ! command -v brew >/dev/null 2>&1; then
    log "installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  else
    echo "brew not found after installation" >&2
    exit 1
  fi
}

install_brew_packages() {
  log "updating Homebrew"
  brew update

  log "installing Homebrew formulae"
  brew install "${BREW_FORMULAE[@]}"

  log "installing Homebrew casks"
  brew install --cask "${BREW_CASKS[@]}"
}

setup_mise() {
  log "activating mise for bash"
  eval "$(mise activate bash)"

  log "installing global runtimes"
  mise use --global "node@${NODE_VERSION}"
  mise use --global "python@${PYTHON_VERSION}"
  mise use --global "ruby@${RUBY_VERSION}"
  hash -r
}

install_global_packages() {
  log "installing npm packages"
  npm install -g \
    typescript \
    typescript-language-server \
    yaml-language-server \
    jsonlint \
    htmlhint \
    eslint

  log "installing Ruby gems"
  gem install ruby-lsp rubocop
}

main() {
  log "start initial settings"
  ensure_homebrew
  install_brew_packages
  # Persistent zsh activation is managed in dotfiles zshrc.
  setup_mise
  install_global_packages
  log "initial settings completed"
}

main "$@"
