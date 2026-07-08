# execution-skill-pack

An output-style, skills, and agents bundle that turns a frontier model's (Claude Fable 5) default behavior into explicit instructions other models (Opus, Sonnet, etc.) can follow. Written by Fable 5 itself, alongside its own environment diagnosis, on 2026-07-08.

## Philosophy

What a top-tier model does silently, a weaker model needs spelled out in text. Three layers:

1. **What should apply on every turn** → output-style (`output-styles/executor.md`). Conclusion-first, immediate action, evidence reconciliation, permission scope, real-data verification — 12 rules.
2. **Procedures invoked per situation** → skills (task execution, quality gate, environment audit, workflow patterns)
3. **Independent perspectives that must stay isolated** → agents (code review, structural review, fact-checking — 3 subagents)

Isolating review into a separate context from the author is the key to reproducing quality. Assign cheap models to generation and strong models to judgment (`docs/model-policy.md`).

## Structure

```
output-styles/executor.md   Behavior code, 12 rules (always applied)
skills/task-execution/      Task decomposition, autonomy vs. confirmation boundary, long-running tasks
skills/quality-gate/        Mechanical pre-submission checklist
skills/env-audit/           Read-only diagnosis procedure for a Claude Code environment
skills/workflow-patterns/   When to parallelize, delegate, or loop-verify
agents/reviewer-code.md     Code-diff reviewer (read-only, sonnet)
agents/reviewer-structure.md Structural / read-through reviewer (read-only, opus)
agents/fact-checker.md      Primary-source verification specialist (web+read, sonnet)
hooks/confirm-master-push.sh Turns a push to master/main into a confirm-first PreToolUse hook
hooks/confirm-merge.sh      Turns `gh pr merge` into a confirm-first PreToolUse hook
hooks/hooks.json            Registers both hooks for plugin installs
.claude-plugin/plugin.json  Plugin manifest
docs/handoff_prompt.md      Copy-paste prompt for non-Claude-Code environments
docs/prompt_templates.md    Templates for review requests, research delegation, writing delegation
docs/model-policy.md        Model and effort-level assignment policy
docs/examples.md            Case studies: failure → codified rule
docs/workflows/             Domain-specific workflows (content/software/business/seminar/teaching)
```

## Install

### As a plugin (recommended)

Clone this repo into a skills directory. Because it ships a `.claude-plugin/plugin.json` manifest, Claude Code loads it automatically on the next session — no marketplace, no install step:

```
git clone https://github.com/nobu666/execution-skill-pack ~/.claude/skills/execution-skill-pack
```

It loads as `execution-skill-pack@skills-dir` and is available in every project. To scope it to a single project instead, clone into `<project>/.claude/skills/execution-skill-pack` and accept the workspace trust dialog for that project.

A one-command marketplace install (`/plugin marketplace add ...`) needs a separate `marketplace.json` that this repo does not ship yet.

### Manual copy (fallback, non-plugin environments)

1. Copy `output-styles/executor.md` to `~/.claude/output-styles/` and select `executor` from the Output style menu in `/config` (the standalone `/output-style` command was removed in v2.1.91). To apply it to every project, set `"outputStyle": "executor"` directly in `~/.claude/settings.json`.
2. Copy each directory under `skills/` to `~/.claude/skills/`.
3. Copy `agents/` to `~/.claude/agents/`. Rewrite each file's frontmatter `model:` to a value available in your environment (`sonnet` / `opus` / a full model ID / `inherit`). Where Opus isn't available, downgrade `reviewer-structure` to `sonnet` (judgment quality drops).
4. Copy `hooks/` to `~/.claude/hooks/` and register both scripts under `hooks.PreToolUse` in `~/.claude/settings.json` with `matcher: "Bash"` (copying the scripts alone does not activate them — see example 1 in `docs/examples.md`).
5. Don't copy `docs/` — keep the repo itself on disk instead. Agent descriptions reference files like `docs/model-policy.md`, so they need to stay readable after step 3.

Don't duplicate rules you already have. If your CLAUDE.md or output-style already covers a rule, importing it again just burns context and invites drift. Partial installs (e.g. skipping `agents/` and calling the same named agent from CLAUDE.md step 3 instead) should follow each skill's fallback notes for "what to do when the named agent doesn't exist."

**Your environment's CLAUDE.md and other project-specific rules win over this pack when they conflict.** In particular, defer to your existing confirmation boundary (executor.md rule 6) and quality-gate report format when your project already has one; adopt only the parts of this pack that add something new.

## Install (non-Claude-Code)

Paste `docs/handoff_prompt.md` into the system prompt or first message. When handing it to a Sonnet-class model, follow the note at the end of that file (a duplicated summary of the critical rules).

## Measuring effect

Run the same task before and after adoption and compare three numbers: the share of completion reports backed by evidence, the share of review findings that include a concrete failure scenario, and the number of rework cycles.

## Before publishing a fork

This repo originated from one person's working environment. If you fork or republish it, check first for real names, real paths, internal project names, and whether references to skills that aren't bundled here (the ones `docs/workflows/` assumes) come with an explanation of what to do without them.
