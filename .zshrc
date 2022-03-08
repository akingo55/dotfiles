export GOPATH=$HOME
export PATH=$PATH:$GOPATH/bin
export LANG=ja_JP.UTF-8


# .zshrc
fpath+=$HOME/.zsh/pure
autoload -U promptinit; promptinit
prompt pure

function peco-src () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}

zle -N peco-src
bindkey '^]' peco-src

export PATH=$HOME/.nodenv/bin:$PATH
eval "$(nodenv init -)"

export PYENV_ROOT=${HOME}/.pyenv
export PATH="${PYENV_ROOT}/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
fi
eval "$(pyenv virtualenv-init -)"

eval "$(rbenv init -)"

# prompt
PROMPT="🍒%B%F{blue}%c%f%b$ "

# alias
alias ll='ls -l'
alias la='ls -a'
alias lt='ls -lt'
alias history='history -Di'
alias hs='history'
alias du='du -h'
alias df='df -h'
alias mybr='git br --contains'
alias g-ph='git push origin `mybr`'
alias logs='git log --oneline --color | emojify | less -r'
alias g=git
alias g-ph='git push origin mybr'

# history
HISTSIZE=100000
HISTFILE=~/.zsh_history
SAVEHIST=100000
setopt hist_ignore_all_dups # 重複するコマンドを削除
setopt hist_ignore_dups # 直前と同じコマンドは追加しない
setopt hist_no_store # historyコマンドは履歴に入れない
setopt hist_reduce_blanks # 余分な余白を削除

setopt correct # typoを教えてくれる
setopt list_packed # 補完候補を詰めて表示
autoload -Uz compinit && compinit # コマンド補完

function cd(){
    builtin cd $@ && ls;
}

# zsh-completions(補完機能)の設定
if [ -e /usr/local/share/zsh-completions ]; then
    fpath=(/usr/local/share/zsh-completions $fpath)
fi
autoload -U compinit
compinit -u
