#!/usr/bin/env bash
# PreToolUse(Bash) hook: master/main に届く git push を確認制(ask)にする。
# 2026-07-08 硬化: 「git push」の連続部分文字列一致をやめ、コマンド区切り
# (;&|) を跨がない範囲で git ... push を検出する（git -C/-c/--no-pager 等の
# グローバルオプション越しに対応）。ブランチ判定は -C や先行する cd の
# 対象ディレクトリで行い、--all/--mirror は無条件で ask にする。
# ponytail: 素朴な空白ベースの解析。引用符内の空白入りパスまでは解かないが、
# その場合も master 明示・--all 系は文字列検査で ask に倒れる（素通りより過剰確認側）。

payload=$(cat)
cmd=$(printf '%s' "$payload" | jq -r '.tool_input.command // empty' 2>/dev/null)

ask() {
  printf '%s' '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"master/main へ届く可能性のある git push です。続行してよいか確認してください。"}}'
  exit 0
}

# コマンド区切りを跨がずに git ... push が現れるか（オプション越し対応）
printf '%s' "$cmd" | grep -Eq '(^|[[:space:];&|(])git[[:space:]]+([^;&|]*[[:space:]])?push([[:space:]]|$)' || exit 0

# 全ブランチ/ミラー push は無条件で確認
printf '%s' "$cmd" | grep -Eq '(^|[[:space:]])--(all|mirror)([[:space:]]|$)' && ask

# refspec 等に master/main が明示されていれば確認
printf '%s' "$cmd" | grep -Eq '(^|[^a-zA-Z0-9_-])(master|main)([^a-zA-Z0-9_-]|$)' && ask

# 対象ディレクトリの特定: git -C <dir> → 先行する cd <dir> → フックの cwd
dir=$(printf '%s' "$cmd" | sed -nE 's/.*git[[:space:]]+(-[a-zA-Z-]+[[:space:]]+)*-C[[:space:]]+([^[:space:]]+).*/\2/p' | head -1)
if [ -z "$dir" ]; then
  dir=$(printf '%s' "$cmd" | sed -nE 's/(^|.*[;&|][[:space:]]*)cd[[:space:]]+([^[:space:];&|]+).*/\2/p' | head -1)
fi
dir="${dir/#\~/$HOME}"

if [ -n "$dir" ]; then
  branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null)
else
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
fi
if [ "$branch" = "master" ] || [ "$branch" = "main" ]; then
  ask
fi
exit 0
