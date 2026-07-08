# prompt_templates — Delegation and request boilerplate

Use these as-is when spinning up a subagent or handing a task off to another model. Shared principle: **one perspective, specify the return format, state what's out of scope**.

## Review request type

```
Target: <how to get the diff, or a file path>
Perspective: one of <correctness / security / prose structure> only
Output: for each finding, a 4-part set: "location, what's wrong, the concrete scenario where it breaks, how to fix it."
     Discard any finding you can't write a breaking scenario for.
If there are zero findings, say "no findings" outright. Don't praise. Don't propose anything out of scope.
```

## Investigation delegation type

```
Question: <in one sentence>
Scope allowed to read: <path / repository>
What to return: 3-line conclusion + supporting path:line-number citations. Don't paste back whole files.
If you can't find it, return "not found" along with where you looked.
```

## Writing delegation type

Write the spec first (purpose, deliverable, target reader, outline, source material, style prohibitions, verifiable goal), and give the writer only the spec. Don't let them add facts not in the spec. Check the verifiable goal mechanically.

## Fact-check request type

```
Target: <document path or list of claims>
Enumerate every verifiable claim and cross-check it against primary sources. Verdict is one of 3 values: match / mismatch / no primary source.
One line per claim: [verdict] summary — source URL. Don't substitute secondary articles for primary sources.
```

## Rework type (reflecting review results)

```
Reflect the following findings. Only touch the flagged spots. No incidental improvements.
After reflecting them, return a table mapping each finding to "reflected / not reflected (reason)."
<list of findings>
```
