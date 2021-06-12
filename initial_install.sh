#!/bin/bash

echo "start initial settings..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew update

# copy
cp .vimrc ~/.vimrc
cp .gitconfig ~/.gitconfig
cp .zshrc ~/.zshrc

MAIN_SHELL=".zshrc"

# vim
brew install go
echo 'export GOPATH=$HOME' >> ~/${MAIN_SHELL}
echo 'export PATH=$PATH:$GOPATH/bin' >> ~/${MAIN_SHELL}

source ~/${MAIN_SHELL}

brew install ghq peco
cat peco.conf >> ~/.zshrc

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# python
brew install pyenv

# aws
brew install awscli aws-vault

# terraform
brew install tfenv

# rbenv
brew install rbenv
