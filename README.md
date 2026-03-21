# dotfiles
## Install rcm
rcm is a tool to manage dotfiles, it allows you to keep your dotfiles in a separate repository and symlink them to the appropriate locations in your home directory.

https://github.com/thoughtbot/rcm
```bash
brew install rcm
```
## Setup dotfiles
dry run
```bash
lsrc
```
Synchronize
```bash
env RCRC=$(pwd)/rcrc rcup
```
