#!/usr/bin/env bash
# PreToolUse(Bash) hook: turns `gh pr merge` into a confirm-first (ask) operation.
# Codifies mistakes.md 2026-06-26 (merge permission scope exceeded, a repeat offense).
# 2026-07-08 hardening: dropped the requirement that gh/pr/merge be adjacent;
# now detects gh ... pr ... merge appearing in that order without crossing a
# command separator (;&|), e.g. `gh -R owner/repo pr merge` or
# `gh pr -R owner/repo merge`.
# ponytail: over-detection (e.g. `gh pr list --label merge`) just falls
# through to ask, which is acceptable.

payload=$(cat)

ask() {
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"%s"}}' "$1"
  exit 0
}

# Fail closed: a confirm gate that silently stops firing is worse than a noisy
# one. If jq is missing, or the payload is non-empty but the command can't be
# extracted, ask instead of exiting 0.
command -v jq >/dev/null 2>&1 || ask "confirm-merge hook: jq not found, cannot inspect the command. Install jq; confirm this command manually."
cmd=$(printf '%s' "$payload" | jq -r '.tool_input.command // empty' 2>/dev/null)
if [ -n "$payload" ] && [ -z "$cmd" ]; then
  ask "confirm-merge hook: could not parse the tool input. Confirm this command manually."
fi

printf '%s' "$cmd" | grep -Eq '(^|[[:space:];&|(])gh[[:space:]]+([^;&|]*[[:space:]])?pr[[:space:]]+([^;&|]*[[:space:]])?merge([[:space:]]|$)' || exit 0

ask "This is about to merge a PR. Merge permission is scoped to that one PR. Confirm whether to proceed."
