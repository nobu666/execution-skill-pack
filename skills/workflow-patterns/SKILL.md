---
name: workflow-patterns
description: A collection of patterns for choosing between parallelization, delegation, and verification loops when designing medium-or-larger tasks. Triggered by phrases like "What's the fastest way to proceed?", "Do this in parallel", "Set up a review structure", and also referenced proactively whenever multiple independent subtasks appear.
---

# workflow-patterns — Choosing Between Parallelization, Delegation, and Verification

## Four Principles

- **Exploration is parallel**: Launch independent research, searches, and reviews at the same time. Keep working on your own tasks while waiting for results, and only wait sequentially when the next step depends on those results.
- **Writes are serial**: Never write to the same file in parallel. When parallelizing write-type subtasks, isolate them with worktrees or similar mechanisms.
- **Review happens in a separate context**: You are the worst possible reviewer of something you just wrote. Always hand review off to a subagent (or a separate session). Give the reviewer a single perspective to focus on — "look at everything" amounts to looking at nothing.
- **Verification uses real data**: When you modify a working system (a pipeline, automation, or hook), run it end-to-end once with real data, not a contrived example.

## Patterns

### Separating Generation from Judgment
Use a cheap model to produce volume for generation (drafts, implementations), and concentrate judgment (review, selection) in a strong model. Give the judge only the output, not the excuses behind how it was generated.

### Multi-Perspective Review
Run reviewers in parallel, one reviewer per perspective (correctness / security / structure). If the perspectives are independent, run them simultaneously and merge once all results are back. Dedupe overlapping findings yourself during the merge.

### Escalating Failure to Rule to Mechanism
If the same failure happens twice, turn it into a rule (documentation). If it recurs even after becoming a rule, escalate it to a mechanism such as a hook, permission, or CI. Rules may go unread, but mechanisms always run.

### Staged Approval
For plans that include irreversible operations, split the work into phases and pause at the end of each phase. Prepare a rollback method for each phase before starting it — a phase you can't write a rollback for isn't fully designed yet.
