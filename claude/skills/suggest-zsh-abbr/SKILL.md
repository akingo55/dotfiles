---
name: suggest-zsh-abbr
description: `zsh-abbr` の追加候補と削除候補を shell usage log から提案する skill。`~/.cache/shell/command-usage-*.log` を集計して、繰り返し実行されるコマンドから追加候補を洗い出し、既存の `config/zsh-abbr/user-abbreviations` のうち使われていないものを削除候補として提示し、確認後のみ abbreviations ファイルを更新したいときに使う。
disable-model-invocation: true
allowed-tools:
  - Bash(bash ./claude/skills/suggest-zsh-abbr/scripts/remove-old-logs.sh)
  - Bash(bash ./claude/skills/suggest-zsh-abbr/scripts/usage-top-commands.sh)
  - Read(~/.cache/shell/command-usage-*.log)
  - Read(./config/zsh-abbr/user-abbreviations)
  - Edit(./config/zsh-abbr/user-abbreviations)
---

# Suggest Zsh Abbr

`history` ではなく `~/.cache/shell/command-usage-*.log` を集計元に使う。重複排除済み history では実行回数が失われるため、頻度ベースの提案には usage log を使う。

## Workflow

1. まず以下のスクリプトを実行し、古い log を削除する。

```bash
bash ./claude/skills/suggest-zsh-abbr/scripts/remove-old-logs.sh
```

2. 次に以下のスクリプトを実行し、usage log から 2 回以上実行されたコマンドを集計する。

```bash
bash ./claude/skills/suggest-zsh-abbr/scripts/usage-top-commands.sh
```

   "No command usage logs found." と表示された場合は、ログが存在しないためここで終了する。その旨をユーザーに伝える。

3. `config/zsh-abbr/user-abbreviations` を読み、既存の略語名と展開コマンドを把握する。
4. usage log に現れるコマンドから、すでに登録されている展開コマンドを除外し、短縮価値があるものだけを追加候補にする。
5. `config/zsh-abbr/user-abbreviations` のうち、usage log に現れていない展開コマンドを削除候補にする。
6. 追加候補一覧と削除候補一覧をユーザーに提示する。
7. 追加する項目と削除する項目を確認する。確認前に `config/zsh-abbr/user-abbreviations` を編集しない。
8. 変更対象が確定したら、編集直前に `config/zsh-abbr/user-abbreviations` を再読込し、差分がずれていないことを確認してから更新する。

## Selection Rules

追加候補として優先するもの:

- タイプ量を減らす効果がある
- 定型的に繰り返して使うコマンドである

追加候補から外すもの:

- すでに `config/zsh-abbr/user-abbreviations` に登録されているもの
- 一時的なワンライナーや、abbreviation にしても読みにくいもの
- 略語名の方がほとんど短くならないもの（例：ls, cd, pwdなど）

削除候補にするもの:

- `config/zsh-abbr/user-abbreviations` に登録されている
- 現在の usage log に対応する展開コマンドが現れない
- その場限りの理由で残していると明示されていない

削除候補から外すもの:

- 今は log に出ていなくても、意図的に残しているとユーザーが判断しそうな基盤コマンド
- 展開コマンドの一致だけでは usage log と対応付けにくいもの

## Output

追加候補一覧には最低限次を含める:

- 実行回数
- 提案する abbreviation
- 展開後のコマンド

削除候補一覧には最低限次を含める:

- 現在の abbreviation
- 展開後のコマンド
- usage log に現れなかったこと

候補一覧を出したあと、「どれを追加するか」「どれを削除するか」を短く確認する。

## Resources

### scripts/remove-old-logs.sh
90 日より古い usage log を削除する。候補集計の前に毎回実行する。

### scripts/usage-top-commands.sh
usage log を読み、2 回以上実行されたコマンドを多い順に表示する。既存 abbreviations の除外や略語名の生成はこのスクリプトでは行わない。
