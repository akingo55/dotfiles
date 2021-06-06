#!/bin/bash

echo "start initial settings..."
brew update

# symbolic link
ln -sf .vimrc ~/.vimrc
ln -sf .gitconfig ~/.gitconfig

# vim
brew install go
echo 'export GOPATH=$HOME' >> ~/.bash_profile
echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bash_profile

source ~/.bash_profile

brew install ghq peco
cat peco.conf >> ~/.bash_profile

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# python
brew install pyenv

# aws
brew install awscli aws-vault
