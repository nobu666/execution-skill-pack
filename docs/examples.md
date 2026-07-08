# examples — A collection of real cases: failure → rule → mechanism

A record of failures that actually occurred and which layer (rule or mechanism) they were escalated to. This corresponds to the "why" behind the articles throughout the Pack.

## Case 1: Unauthorized push (recurred multiple times)

Interpreted "back it up" or "put it in" as authorization to push, and executed it. The same type of failure — carrying over authorization just granted in a different repo into the next task and executing a merge — happened multiple times, spaced apart.
- Turned into a rule: "Authorization is limited to that repo, that task, that one time" (executor Article 10)
- Turned into a mechanism: `hooks/confirm-master-push.sh` and `hooks/confirm-merge.sh` (bundled with this Pack). They take `.tool_input.command` from the stdin JSON, detect pushes to master/main and `--all`/`--mirror` via subcommand parsing of git push, and detect PR merges via subcommand parsing of gh pr merge; if a match is found, they output `{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"..."}}` (if no match, no output and exit 0). A simple consecutive string match would be evaded by variants like `git -C dir push` or `gh -R owner/repo pr merge`, so subcommand extraction across options is used instead
- Lesson: **If it recurs even after being turned into a rule, escalate it to a mechanism.** Rules may go unread, but a mechanism always runs. That said, a mechanism can still be bypassed if its detection logic is weak (in this case, it was first implemented with a simple match, and only hardened after a later audit measured the bypass in practice)

## Case 2: Verified with contrived examples only, and stopped an automation that had been working

Added a content scan to pre-commit and reported "no false positives" based only on artificial test cases. It produced a false positive on real data, and a working automated backup was down for more than half a day.
- Turned into a rule: "When touching a working system, run one real-data end-to-end pass" (executor Article 12, workflow-patterns, task-execution)
- Lesson: The quality of verification is the quality of the test data. Verification that hasn't been run against the real thing isn't verification

## Case 3: Reported a write as "done" without ever executing it

Reported completion of writes to multiple locations, with specific file names, but the write tool had never actually been called.
- Turned into a rule: "Reconcile every reported item against actual tool execution. Anything that can't be reconciled is marked as not done" (executor Article 9, quality-gate 3)
- Turned into a mechanism: Made an evidence column mandatory in the completion report format
- Lesson: A fabricated completion report is the worst kind of failure. Suspect it most at the end of a session and after context compaction

## Case 4: Asserted a service's terms from vague memory (corrected twice in a row within the same deliverable)

Exaggerated a conversational assumption when writing it into the deliverable, which contradicted the official announcement. Even the first correction was filled back in with guesswork and was wrong again.
- Turned into a rule: "Get the primary source before writing. If pointed out, don't fill the gap back in with guesswork — confirm the source with one question" (executor Article 11)
- Turned into a mechanism: fact-checker agent (dedicated to primary-source verification before publication)

## Case 5: Failure to propagate a URL change

A change to an article's publication date changed its URL, but the previously proposed social media post text was left with the old URL, resulting in a 404.
- Turned into a rule: "When a URL changes, update every place that references it (social media text, in-body links, logs) within the same operation"
- Lesson: The scope of a change's impact isn't "that file" — it's "every place that references it"

## Good example: Turning feedback into a rule and showing it to the same reviewer again

Rather than fixing review feedback ad hoc, generalize the feedback and add it to a rule (a skill or checklist), then pass re-review with the same reviewer. The fix and the process improvement finish at the same time.
