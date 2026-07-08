#!/usr/bin/env bash
# PreToolUse(Bash) hook: turns any git push that could land on master/main into
# a confirm-first (ask) operation.
# 2026-07-08 hardening: replaced the "git push" contiguous-substring match with
# token-order detection that doesn't cross command separators (;&|), so it
# still matches across global options like git -C/-c/--no-pager. Branch
# detection follows -C or a preceding cd's target directory; --all/--mirror
# always ask unconditionally.
# ponytail: naive whitespace-based parsing. It doesn't resolve quoted paths
# containing spaces, but even then an explicit master/main or --all-family
# flag still falls through to ask via plain string matching (over-asking is
# the safe failure mode here, not silent pass-through).

payload=$(cat)
cmd=$(printf '%s' "$payload" | jq -r '.tool_input.command // empty' 2>/dev/null)

ask() {
  printf '%s' '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"This git push may land on master/main. Confirm whether to proceed."}}'
  exit 0
}

# Does "git ... push" appear without crossing a command separator (survives intervening options)?
printf '%s' "$cmd" | grep -Eq '(^|[[:space:];&|(])git[[:space:]]+([^;&|]*[[:space:]])?push([[:space:]]|$)' || exit 0

# All-branches / mirror pushes always ask
printf '%s' "$cmd" | grep -Eq '(^|[[:space:]])--(all|mirror)([[:space:]]|$)' && ask

# Ask if master/main is named explicitly (e.g. in a refspec)
printf '%s' "$cmd" | grep -Eq '(^|[^a-zA-Z0-9_-])(master|main)([^a-zA-Z0-9_-]|$)' && ask

# Resolve the target directory: git -C <dir> → a preceding cd <dir> → the hook's cwd
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
