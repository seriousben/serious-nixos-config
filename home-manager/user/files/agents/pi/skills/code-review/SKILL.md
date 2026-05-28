---
name: code-review
description: |
  Review code changes using Conventional Comments. Use after completing a
  coding task, before committing. Flags issues that impact accuracy,
  performance, security, or maintainability. Does not flag style preferences
  or hypothetical edge cases. A short review with few findings is the right
  answer for good code.
disable-model-invocation: true
---

# Code Review

Review the changes in this session using Conventional Comments format.

## Commands

```bash
git diff main
```

## Comment Format

Use [Conventional Comments](https://conventionalcomments.org/):

- `issue (blocking):` — Must fix before merge. Accuracy, security, data loss.
- `suggestion (non-blocking):` — Worth considering. Performance, maintainability.
- `nitpick:` — Minor. Style, naming, formatting.
- `praise:` — Good work worth calling out.

## What to flag

- Incorrect logic or broken behavior
- Security issues (injection, auth bypass, secret exposure)
- Performance problems (N+1 queries, unbounded allocations, missing indexes)
- Missing error handling where failure is plausible
- API contract changes without migration path
- Concurrency bugs (races, deadlocks, missing synchronization)

## What to skip

- Style preferences already handled by formatters/linters
- Hypothetical edge cases with no realistic trigger
- "What if" scenarios that apply to pre-existing code, not the diff
- Suggesting abstractions for code that works fine as-is

## Process

1. Get the diff: `git diff main` (or appropriate base branch)
2. Read each changed file in full context (not just the diff)
3. Post comments with `file:line` references
4. Keep the review short. Few findings on good code is correct.
