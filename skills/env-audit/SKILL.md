---
name: env-audit
description: A skill that performs a read-only audit of the Claude Code environment (CLAUDE.md / skills / agents / hooks / permissions / plugins / MCP / context efficiency). Triggered by phrases like "audit my environment," "audit my setup," "review my Claude Code configuration," or "environment feels heavy/cluttered." Recommended to run quarterly. Diagnosis only, no changes (changes are handled separately after the diagnosis is approved).
---

# env-audit — Read-only diagnosis of the Claude Code environment

Performs a read-only diagnosis of the environment and presents improvement points ranked by impact × effort. **While this skill is running, it must not create, edit, or delete any file, or change any settings** (the only exception is a Plan Mode plan file).

## Procedure

### 1. Confirm scope (always ask this first)

Before diagnosing, confirm two things: information only the user can provide (scan scope — entire home directory or just the development area? / folders to exclude), and a blanket approval for read-only commands to bundle permission prompts (present the commands you plan to run before asking). The output format defaults to a single combined presentation; only split it if the user requests that (do not ask about this up front).

### 2. Look in the order: structure → volume → content

- Structure: `ls` / `find` (down to 2-3 levels). Exclude `~/Library`, caches, `node_modules`, and the contents of `.git`
- Volume: measure the always-loaded context with `wc -c` (CLAUDE.md, CLAUDE.local.md, output-style, memory index). Count how many skill/agent description strings enabledPlugins injects
- Content: only open configuration files (CLAUDE.md / SKILL.md / settings.json / .mcp.json / hooks / agents / output-styles). Since `~/.claude.json` may contain credentials, inspect only its key structure with `jq 'keys'`. Do not open personal information, credentials, or note bodies

### 3. Diagnostic angles

- Whether things that should always be read (CLAUDE.md) are mixed together with procedures (skills)
- Whether the same instruction is duplicated across multiple files (a sign of drift)
- Leftover legacy commands format, non-functioning plugins, one-off permission entries
- Whether something "written into the rules but that recurred anyway" has been left without being turned into a hook
- Whether permissions are too broad (especially a blanket allow on Write/Edit)
- Whether a backup/rollback path exists

### 4. Output

- Current-state map (tree) → list of issues (with rationale) → impact × effort matrix → phased execution plan (for each phase: purpose, content, risk, rollback, approval point)
- Always list at least one "thing better left untouched" (identify path dependencies that would break if touched, before anything else)
- Changes require the user's approval every time. Stop and wait at each phase
