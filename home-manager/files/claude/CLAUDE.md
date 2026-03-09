# AGENTS.md

User-level agent instructions for software engineering workflows.

## Environment & Tools

**System:**
- Use GNU utilities (not BSD variants)
- GNU sed is available: `sed -i ///` syntax works for in-place editing
- `rg` (ripgrep) is available for searching
- Git is configured with GPG signing enabled

## Code Quality Boundaries

**Non-Negotiable Rules:**
1. **Never change code meaning without explicit discussion** - Preserve original intent
2. **Always complete reversions fully** - Remove all traces of abandoned approaches
3. **Prefer simplicity over cleverness** - Choose obvious solutions
4. **Ask questions when uncertain** - Don't make assumptions about requirements

**Design Principles:**
- Favor deep modules with simple interfaces
- Avoid unnecessary abstraction layers
- Keep code obvious and self-documenting
- Think strategically about long-term maintainability

**Anti-Patterns to Avoid:**
- Shallow modules with complex interfaces
- Configuration parameters to avoid design decisions
- Breaking up cohesive functionality into many small pieces
- Adding complexity for minor gains

## Command Output Handling

**Never re-run a command just to filter its output differently.** This wastes time, tokens, and may produce different results.

❌ **Anti-pattern:**
```bash
long_command 2>&1 | tail -30
# ... then immediately ...
long_command 2>&1 | grep "Failure"
```

✅ **Correct approach:** Capture once to a temp file, then inspect as needed:
```bash
tmpf=$(mktemp /tmp/cmd-output.XXXXXX)
long_command &> "$tmpf"
tail -30 "$tmpf"
grep "Failure" "$tmpf"
# Clean up when done
rm -f "$tmpf"
```

This applies to any long-running or verbose command — builds, tests, linters, API calls, etc. Prioritize speed and minimal token usage: run the command once, inspect the output many times.

## Workflow Guidelines

**Making Changes:**
- Understand code before modifying
- Preserve established patterns
- Ask before major architectural decisions
- Verify changes don't break functionality

**Reverting:**
- Remove all traces of abandoned approaches
- Clean up imports, variables, methods

**Error Handling:**
- Design to prevent errors, not just handle them
- Avoid excessive exception throwing

**Comments:**
- Explain why, not what
- Document non-obvious decisions

## Planning & RFCs

The `seriousben-agent-plans/` directory (gitignored) is available in any repo for generating RFCs, plans, and tracking work-in-progress. Use it to:

- **Draft RFCs** — Write design documents before implementing significant changes (`seriousben-agent-plans/rfcs/`)
- **Create plans** — Break down complex tasks into step-by-step plans (`seriousben-agent-plans/plans/`)
- **Track WIP** — Record current progress, open questions, and next steps (`seriousben-agent-plans/wip/`)

When asked to create a plan and no other planning process is defined, use this directory. Update WIP notes as you go so context is preserved across sessions and compactions.

**Important:** Never reference `seriousben-agent-plans/` or any of its contents in committed code, comments, commit messages, PRs, or any other artifacts that leave the local workspace. This directory is strictly for internal agent use only.

## When in Doubt

- Choose the simpler approach
- Ask questions rather than assume
- Follow existing patterns
- Think like a maintainer
---

*"The greatest limitation in writing software is our ability to understand the systems we are creating."* - John Ousterhout

Remember: Beautiful code is not just code that works - it's code that can be easily understood, modified, and extended by any competent engineer who encounters it.
