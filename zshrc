export LANG=ja_JP.UTF-8

# fzf
# Open in tmux popup if on tmux, otherwise use --height mode
export FZF_DEFAULT_OPTS='--height 40% --tmux bottom,40% --layout reverse --border top'

# zsh-completions, zsh-abbr
if type brew >/dev/null 2>&1; then
  fpath=(
    "$(brew --prefix)/share/zsh-abbr"
    "$(brew --prefix)/share/zsh-completions"
    $fpath
  )

  # zsh-abbr
  source /opt/homebrew/share/zsh-abbr/zsh-abbr.zsh
fi

autoload -Uz compinit
compinit -u

# zsh-abbr reminders
ABBR_GET_AVAILABLE_ABBREVIATION=1
ABBR_LOG_AVAILABLE_ABBREVIATION=1
ABBR_LOG_AVAILABLE_ABBREVIATION_AFTER=1
# zsh-autosuggestions-abbreviations-strategy
ZSH_AUTOSUGGEST_STRATEGY=( abbreviations $ZSH_AUTOSUGGEST_STRATEGY )

# github repositoryの移動をしやすくする
function fzf-github-dir () {
  local selected_dir=$(ghq list -p | fzf --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}

zle -N fzf-github-dir
bindkey '^]' fzf-github-dir

# historyからコマンド選択できるようにする
function fzf-history () {
  local history_command=$(history -nr 1 | fzf --query "$LBUFFER")
  if [ -n "$history_command" ]; then
    BUFFER=$history_command
    zle accept-line
  fi
  zle clear-screen
}

zle -N fzf-history
bindkey '^h' fzf-history

# cdrを有効にする
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
  add-zsh-hook chpwd chpwd_recent_dirs

zstyle ':completion:*:*:cdr:*:*' menu selection
zstyle ':completion:*' recent-dirs-insert always
zstyle ':chpwd:*' recent-dirs-max 500
zstyle ':chpwd:*' recent-dirs-default true
zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/shell/chpwd-recent-dirs"
zstyle ':chpwd:*' recent-dirs-pushd true

# fzfでcdr選択できるようにする
function fzf-cdr () {
  local selected_dir=$(cdr -l | awk '{ print $2 }' | fzf)
  if [ -n "$selected_dir" ]; then
    BUFFER=$selected_dir
    zle accept-line
  fi
  zle clear-screen
}

zle -N fzf-cdr
bindkey '^[' fzf-cdr

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
#autoload -Uz compinit && compinit # コマンド補完

# cdしたらls
function cd() {
    builtin cd "$@" && ls
}

# introduce pure
# https://github.com/sindresorhus/pure
# .zshrc
autoload -U promptinit; promptinit
prompt pure
export PATH="$HOME/.local/bin:$PATH"

# activate mise
eval "$(mise activate zsh)"

# zsh-autosuggestions-abbreviations-strategy
source /opt/homebrew/share/zsh-autosuggestions-abbreviations-strategy/zsh-autosuggestions-abbreviations-strategy.zsh
