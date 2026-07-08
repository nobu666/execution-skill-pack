---
name: task-execution
description: Execution discipline to apply before starting a multi-step implementation, writing, or research task. The canonical reference for task decomposition, the boundary between autonomous action and confirmation, handling of unclear points, and how to proceed on long-running tasks. Consult this first whenever a request will take two or more steps — "proceed with the task," "implement this," "carry out this series of work," and similar.
---

# task-execution — Task execution discipline

## Decomposition (before starting)

- Convert the task into a "verifiable goal" before starting
  - "Add validation" → "Write tests for invalid input, and make them pass"
  - "Fix the bug" → "Write a reproduction test, and make it pass"
  - "Refactor X" → "Confirm tests pass before and after"
- Break the task into 3–7 items in the form `[step] → verification: [what to check]` and present them. If it exceeds 7 items, either split the task or get the plan approved up front in Plan Mode
- If there is a clear success criterion, loop autonomously. If the criterion is ambiguous ("make it work"), confirm before starting

## The boundary between autonomous action and confirmation

- **OK to proceed**: any operation that is reversible and within the scope of the request. This includes retrying after an error and independently investigating missing information
- **Stop and ask (only these three)**: irreversible operations (push, merge, delete, publish, billing) / a substantive scope change / information only the user can provide
- Conversely, always ask about these three. Permission is scoped to that repo, that piece of work, that one time only — it does not carry over

## Handling unclear points

- If you can name exactly what is unclear, ask. If you can't name it, that means you lack information — investigate it yourself first (a question is the most expensive operation, since it consumes the user's time)
- When multiple interpretations are possible, don't silently pick one — present one recommendation with a reason and confirm (don't enumerate every option)

## Long-running tasks

- At each milestone, write progress out to an external file (a work log). Assume context compaction will happen, and write at a granularity that lets "your future self" read it and resume
- Write the final report as a "re-landing," not a continuation of the narrative. Don't use vocabulary or abbreviations invented during the work. State the result in one sentence, and when referring to files or commits, add a plain explanation

## Failure-prone patterns and how to avoid them

- **Unrequested refactoring or cleanup**: before submitting, confirm that every changed line ties back to the request
- **Verifying with fabricated examples only**: once you've touched a live pipeline, run it end-to-end with real data once before declaring it done
- **Jumping ahead in the completion report**: for each operation you report, cross-check it against tool-execution evidence. Anything that can't be cross-checked should be marked "not done"
- **Reusing permission beyond its scope**: right before an irreversible operation, point to the one explicit grant of permission it rests on. If you can't point to one, ask
