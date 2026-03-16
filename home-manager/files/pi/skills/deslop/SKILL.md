---
name: deslop
description: |
  Remove AI-generated code slop from recent changes. Use after implementation
  to clean up extra comments, unnecessary defensive code, type casts, and style
  inconsistencies introduced by the agent. Run before committing.
---

# Deslop: Remove AI Code Artifacts

Check the diff against the base branch and remove AI-generated slop.

## What to remove

- Comments that a human wouldn't add or that are inconsistent with the rest of the file
- Defensive checks or try/catch blocks that are abnormal for that area of the codebase (especially in trusted/validated codepaths)
- Type casts to `any` to work around type issues
- Overly verbose variable names that don't match the file's style
- Commented-out code
- Any other style inconsistent with the surrounding code

## What to keep

- Comments that explain why (not what)
- Error handling that matches existing patterns in the file
- Tests and assertions

## Process

1. Get the diff: `git diff main` (or appropriate base branch)
2. For each changed file, compare new code against the file's existing style
3. Remove slop, preserving functionality
4. Run tests to verify nothing broke
5. Report a 1-3 sentence summary of what changed
