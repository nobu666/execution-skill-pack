#!/usr/bin/env bash
# PreToolUse(Bash) hook: gh の PR merge を確認制(ask)にする。
# mistakes.md 2026-06-26（マージ許可の射程超え・再発）の機構化。
# 2026-07-08 硬化: gh/pr/merge の隣接要求をやめ、コマンド区切り(;&|)を
# 跨がない範囲で gh ... pr ... merge の順の出現を検出する
# （gh -R owner/repo pr merge / gh pr -R owner/repo merge 等に対応）。
# ponytail: 過剰検知（例: gh pr list --label merge）は ask に倒れるだけなので許容。

payload=$(cat)
cmd=$(printf '%s' "$payload" | jq -r '.tool_input.command // empty' 2>/dev/null)

printf '%s' "$cmd" | grep -Eq '(^|[[:space:];&|(])gh[[:space:]]+([^;&|]*[[:space:]])?pr[[:space:]]+([^;&|]*[[:space:]])?merge([[:space:]]|$)' || exit 0

printf '%s' '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"PRをマージしようとしています。マージ許可はそのPR限りです。続行してよいか確認してください。"}}'
exit 0
