#!/bin/bash

echo "start initial settings..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew update

MAIN_SHELL=".zshrc"

# peco
brew install ghq peco
cat peco.conf >> ~/.zshrc

# tree icon
# https://github.com/ryanoasis/nerd-fonts
brew install font-hack-nerd-font

#curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
#    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# neovim
brew install neovim

# aws
brew install awscli aws-vault

# terraform
brew install tfenv

# fzf
brew install fzf

# mise (Python / Ruby / Node.js version management)
brew install mise
echo 'eval "$(mise activate zsh)"' >> ~/.zshrc
eval "$(mise activate zsh)"
mise use --global node@latest
mise use --global python@latest
mise use --global ruby@latest

# npm global packages (LSP servers / linters)
npm install -g typescript typescript-language-server
npm install -g yaml-language-server
npm install -g jsonlint htmlhint eslint

# Terraform LSP + linter
brew install terraform-ls tflint

# Lua LSP (for ALE)
brew install lua-language-server

# Ruby gems
gem install ruby-lsp rubocop
