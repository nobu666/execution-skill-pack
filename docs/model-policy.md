# model-policy — Model / effort selection

Principle: **Generation uses a cheap model, judgment uses a strong model.**

| Task | Model | Rationale |
|---|---|---|
| Collection, formatting, boilerplate output (news digests, etc.) | Sonnet fixed | Deep reasoning isn't needed. Unattended runs have shown missed entries from higher-tier models hitting capacity errors — Sonnet also wins on stability |
| Implementation / draft writing | Sonnet | A high-volume step. Assumes review will catch issues |
| Code review (correctness) | Sonnet | Default for the reviewer-code agent |
| Code review (security perspective) | Explicitly specify Opus or higher | Don't use reviewer-code; request separately with the perspective made explicit |
| Structural review of prose (read-through) | Whatever is the highest-performing model available at the time | "Is this correct?" demands the most judgment. Cannot be replaced by mechanical checks |
| Design decisions, environment audits, planning | Highest-performing model + Plan Mode | Mistakes are costly and hard to undo |
| Fact-checking | Sonnet | Mostly retrieval and cross-checking; judgment is limited to a 3-value scale |

## effort / thinking

- Exploration, boilerplate: low
- Right before a confirmed operation, final review, plan finalization: high
- When in doubt: scale it to how irreversible the task is

## When to use Plan Mode

- Work involving irreversible operations (config changes, publishing, migration)
- Work touching more than 3 files
- Work where the user's request is ambiguous and differing interpretations would substantially change the outcome

## When to always require human approval

- git push / gh pr merge / publishing / deletion / billing (also enforced by hooks, but the model itself should stop as well)
- Changes to existing automation (launchd, cron, CI)
- Any confirmed operation where a single, clear basis for permission cannot be identified
