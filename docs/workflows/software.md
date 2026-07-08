# software — Software Development Workflow

**Note: Plans/, Decisions/, Knowledge/, and Notes/ in the text refer to categories in the author's Obsidian Vault (external brain). Substitute your own environment's recording location.**

1. Planning: For non-trivial changes, use Plan Mode. Write the plan outside the project (Plans/)
2. Goal conversion: Convert the task into a verifiable goal before starting (see task-execution)
3. Implementation: Make surgical changes. Every changed line ties directly to the request
4. Review: reviewer-code (correctness). For code in a public repo or that handles external input, also give the diff a separate security-focused review (SSRF, command injection, path traversal, prompt injection, resource exhaustion). Do not push while Critical/High issues remain
5. Verification: Tests plus end-to-end real-data verification. Especially important when touching existing automation
6. Submission: Show the change in a staged state. Get explicit confirmation for each commit/push (also enforced by a hook). The same applies to merges
7. Recording: Decisions involving a choice go to Decisions/, resolved problems go to Knowledge/, work logs go to Notes/
