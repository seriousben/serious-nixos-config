---
name: verify-completion
description: |
  Verify work is actually complete before claiming it. Use before committing,
  creating PRs, or marking tasks done. Requires running verification commands
  and showing output before making any success claims. No "should work",
  no "looks correct", evidence only.
---

# Verify Before Completion

No completion claims without fresh verification evidence.

## The rule

Before claiming any status (done, fixed, passing, working):

1. **Identify** what command proves the claim
2. **Run** the command (fresh, complete, not a cached result)
3. **Read** the full output, check exit code
4. **Show** the evidence in your response
5. **Then** make the claim

Skip any step and the claim is unverified.

## What requires verification

| Claim | Run this | Not sufficient |
|-------|----------|----------------|
| Tests pass | Full test command output showing 0 failures | Previous run, "should pass" |
| Build succeeds | Build command with exit 0 | "Linter passed" |
| Bug fixed | Reproduce original symptom, show it's gone | "Code changed, should be fixed" |
| Linter clean | Linter output showing 0 errors | Partial check |
| Requirements met | Line-by-line checklist against spec | "Tests pass" |

## Red flags in your own output

Stop if you catch yourself writing:
- "should work now"
- "looks correct"
- "I'm confident this fixes it"
- "Done!" (without showing evidence)
- Any variation of success without having run verification

## Process

```
Run verification -> Show output -> State result with evidence
```

Not:

```
Make changes -> Claim success -> Hope it works
```
