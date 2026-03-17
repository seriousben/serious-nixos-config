---
name: systematic-debugging
description: |
  Structured debugging protocol. Use when encountering any bug, test failure,
  or unexpected behavior, before proposing fixes. Enforces root cause
  investigation before any code changes. Use especially when stuck or when
  previous fix attempts failed.
---

# Systematic Debugging

No fixes without root cause investigation first.

## When to use

- Test failures
- Bugs or unexpected behavior
- Build failures
- Performance problems
- When previous fix attempts didn't work
- When under time pressure (rushing guarantees rework)

## Phase 1: Investigate

Before attempting any fix:

1. **Read error messages carefully.** Don't skip past errors or warnings. Read stack traces completely. Note line numbers, file paths, error codes.

2. **Reproduce consistently.** Can you trigger it reliably? What are the exact steps? Capture output to a temp file for repeated inspection:
   ```bash
   tmpf=$(mktemp /tmp/debug-output.XXXXXX)
   failing_command &> "$tmpf"
   cat "$tmpf"
   ```

3. **Form a hypothesis.** Based on the error, what specifically is going wrong? Write it down. "I think X happens because Y."

4. **Gather evidence.** Read the relevant code. Add targeted logging or print statements. Check recent changes with `git log --oneline -10` and `git diff`.

If you cannot explain the root cause, you are not ready for Phase 2.

## Phase 2: Test the hypothesis

- Change ONE variable at a time
- Predict what will happen before running the test
- If prediction is wrong, revise the hypothesis and return to Phase 1
- Don't combine multiple changes; you won't know which one helped

## Phase 3: Fix

- Minimal, targeted fix that addresses the root cause
- Don't fix symptoms. Don't add workarounds.
- If the fix is more than a few lines, reconsider whether you found the real root cause

## Phase 4: Verify

- Run the failing test/command and confirm it passes
- Run the broader test suite to check for regressions
- If the fix involved a race condition or timing issue, run multiple times
- Show the verification output. Don't claim "should work."
