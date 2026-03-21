# CLAUDE.md

このリポジトリは、シェル・CLI・エディタ設定などの dotfiles を管理し、`rcm` でホームディレクトリへ反映するためのものです。
Claude Code はこの repo を変更するとき、既存環境を壊さず、再実行可能で、ホスト差分に強い変更を優先します。

## Repository Layout

- `zshrc`, `gitconfig`, `vimrc` など: ホームディレクトリへリンクされるトップレベル dotfiles
- `config/`: XDG 配下へ反映する設定
- `nvim/`: Neovim 設定
- `initial_install.sh`: 初期セットアップ用の依存インストールスクリプト
- `rcrc`: `rcm` の反映ルール

## Setup Flow

```bash
brew install rcm
lsrc
env RCRC=$(pwd)/rcrc rcup
bash initial_install.sh
```

- `rcup` は dotfiles のリンク反映を行う
- `initial_install.sh` は Homebrew、runtime、CLI などの依存を導入する
- 設定変更と依存導入は別責務として扱う

## Change Principles

1. 既存の動作を壊さない
- 現在動いている設定は、実害が確認できない限り書き換えない
- 一般知識より、ローカルで動作している事実を優先する

2. 読み込み元と配置先を確認する
- 変更前に、そのファイルがどこへリンクされ、どのプロセスから読まれるかを確認する
- repo 内のファイルだけでなく、実配置先や生成物の有無も必要に応じて確認する

3. シェル差分を意識する
- `bash` と `zsh` の構文や初期化方法を混同しない
- login shell / interactive shell の差で壊れないようにする

4. Bootstrap は再実行可能に保つ
- `initial_install.sh` は idempotent を意識する
- 同じ処理を複数回実行しても設定が重複しないようにする
- バージョンは可能な限り固定し、結果が時間依存にならないようにする

5. バージョン依存の設定は実体を確認する
- plugin や外部ツールの API を前提に変更する場合は、インストール済みバージョンと実ファイルを確認する
- よくある設定例をそのまま当てはめない

## Validation Checklist

- `git diff` で意図した差分だけか確認する
- shell script は `bash -n` などで構文確認する
- リンク反映に関わる変更は `lsrc` / `rcup` を前提に確認する
- シェル設定は新しい shell を開いて確認する
- エディタ設定は対象アプリを起動して確認する

## Git Hygiene

- `git add` の前に必ず `git status` を確認する
- 既にステージ済みの変更が混ざっていないか確認する
- ホスト固有ファイルや秘密情報をコミットしない
- できるだけ 1 トピック 1 コミットにする

## Tool-specific Notes

### Neovim plugins

- API 変更を前提に設定を変える前に、`~/.config/nvim/lazy-lock.json` でバージョンを確認する
- 必要なら `~/.local/share/nvim/lazy/<plugin>/` でモジュール実体を確認する
- 動いている設定は、実害がない限り一般論だけで置き換えない
