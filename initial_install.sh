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

# python
brew install pyenv

# aws
brew install awscli aws-vault

# terraform
brew install tfenv

# rbenv
brew install rbenv
