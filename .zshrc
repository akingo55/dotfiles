# prompt
PROMPT="%B%F{cyan}%n@%m%f%b:%B%F{blue}%~%f%b%# "

# alias
alias ll='ls -l'
alias la='ls -a'
alias lt='ls -lt'
alias lat='ls -lat'
alias history='history -Di'
alias hs='history'
alias du='du -h'
alias df='df -h'

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

# cdしたらlsする
function cd(){
    builtin cd $@ && ls;
}
