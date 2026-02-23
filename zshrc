eval "$(mise activate zsh)"

export LANG=ja_JP.UTF-8

# github repositoryの移動をしやすくする
function peco-github-dir () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}

zle -N peco-github-dir
bindkey '^]' peco-github-dir

# historyからコマンド選択できるようにする
function peco-history () {
  local history_command=$(history -nr 1 | peco --query "$LBUFFER")
  if [ -n "$history_command" ]; then
    BUFFER=$history_command
    zle accept-line
  fi
  zle clear-screen
}

zle -N peco-history
bindkey '^h' peco-history

# cdrを有効にする
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
  add-zsh-hook chpwd chpwd_recent_dirs

zstyle ':completion:*:*:cdr:*:*' menu selection
zstyle ':completion:*' recent-dirs-insert always
zstyle ':chpwd:*' recent-dirs-max 500
zstyle ':chpwd:*' recent-dirs-default true
zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/shell/chpwd-recent-dirs"
zstyle ':chpwd:*' recent-dirs-pushd true

# pecoでcdr選択できるようにする
function peco-cdr () {
  local selected_dir=$(cdr -l | awk '{ print $2 }' | peco)
  if [ -n "$selected_dir" ]; then
    BUFFER=$selected_dir
    zle accept-line
  fi
  zle clear-screen
}

zle -N peco-cdr
bindkey '^[' peco-cdr

# alias
alias ll='ls -l'
alias la='ls -a'
alias lt='ls -lt'
alias hs='history'
alias du='du -h'
alias df='df -h'
alias mybr='git rev-parse --abbrev-ref @'
alias g-ph='git push origin `mybr`'
alias g=git
alias vim=nvim

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

# cdしたらls
function cd() {
    builtin cd "$@" && ls
}

# zsh-completions(補完機能)の設定
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  # autosuggestions
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

  autoload -Uz compinit
  compinit
fi

# introduce pure
# https://github.com/sindresorhus/pure
# .zshrc
autoload -U promptinit; promptinit
prompt pure
export PATH="$HOME/.local/bin:$PATH"
