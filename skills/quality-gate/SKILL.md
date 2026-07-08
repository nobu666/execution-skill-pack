---
name: quality-gate
description: A mechanical checklist that must be run immediately before submitting a deliverable, proposing a commit, or publishing an article. Triggered by phrases like "pre-submission check," "pre-publish check," "is this okay to submit?" and also applied proactively as the final gate for any deliverable submission.
---

# quality-gate — a mechanical gate before submission

Run through this in order, right before submission. If even one item fails, do not submit (either fix it, or write the reason it failed in the report).

**If the deployed environment already has an existing completion-report format, prefer that one.** The "Report Format" below is the default used when no such format exists; when an existing format is present, this skill only adds the evidence column (marking items as evidenced / not done) as a required addition on top of it.

## Checklist

1. **Cross-check against pass criteria**: Did you check off the pass criteria enumerated at the start of the task, one item at a time? Are confirmed items backed by evidence, and unconfirmed items explicitly marked "unverified"?
2. **Mechanical counting**: For anything countable (character counts, link counts, forbidden patterns), was it counted mechanically? Visual/manual counting fails this check.
3. **Evidence reconciliation**: Does every operation written in the report have a corresponding tool execution and successful result within the same session? If not, rewrite it as "not done."
4. **Raw results**: Were test and build results pasted as raw output? Are failures reported as failures, unmodified?
5. **Naming the weak point**: Did you specifically name the single weakest part of the deliverable? Did you either fix it or write why it can't be fixed?
6. **Scope check**: Does every changed line trace back to the request? Were untraceable lines removed?
7. **Review isolation**: For non-trivial changes, was the work reviewed by a subagent running in a context separate from your own? Use reviewer-code for code, reviewer-structure for prose, and fact-checker for external facts (in environments without agents of the same name, substitute by handing a single review perspective to any subagent running in a separate context from your own).

## Report Format

1. **Overall flow** — what was done and what was completed, in one line
2. **What was done** — a table with columns for item, file, status, and evidence (command run / path / result). Any row lacking evidence must say "not done"
3. **What was not done** — items intentionally skipped, and why
