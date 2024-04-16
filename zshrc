# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"

# x86
export LDFLAGS="-L/usr/local/opt/zlib/lib"
export CPPFLAGS="-I/usr/local/opt/zlib/include"
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
#alias history='history -Di'
alias hs='history'
alias du='du -h'
alias df='df -h'
alias mybr='git rev-parse --abbrev-ref @'
alias g-ph='git push origin `mybr`'
alias g=git

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
function cd(){
    builtin cd $@ && ls;
}

# zsh-completions(補完機能)の設定
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  # autosuggestions
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

  autoload -Uz compinit
  compinit
fi

# ruby
eval "$(rbenv init - zsh)"
export PATH="$HOME/.rbenv/bin:$PATH"

# python
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/shims:$PATH"
eval "$(pyenv init -)"

# node
eval "$(nodenv init -)"

# direnv
eval "$(direnv hook zsh)"

# ansible error対応
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# introduce pure
# https://github.com/sindresorhus/pure
autoload -U promptinit; promptinit
# change the path color
zstyle :prompt:pure:path color cyan
# change the color for both `prompt:success` and `prompt:error`
zstyle ':prompt:pure:prompt:*' color magenta
# turn on git stash status
zstyle :prompt:pure:git:stash show yes
prompt pure

# terraform
export TF_CLI_ARGS_plan="--parallelism=80"
export TF_CLI_ARGS_apply="--parallelism=80"
export GODEBUG=asyncpreemptoff=1

export PATH="$PATH:/opt/homebrew/share/git-core/contrib/diff-highlight"

# ffi error
export PKG_CONFIG_PATH="/usr/local/opt/libffi/lib/pkgconfig"
export PATH="/usr/local/opt/mysql@5.6/bin:$PATH"

# ssl
#export PATH="/usr/local/opt/openssl/bin:$PATH"
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
#export PATH="/opt/homebrew/opt/openssl@1.1/bin:$PATH"
#export LDFLAGS="-L/opt/homebrew/opt/openssl@1.1/lib"
#export CPPFLAGS="-I/opt/homebrew/opt/openssl@1.1/include"

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
export PATH="/usr/local/opt/openjdk/bin:$PATH"
