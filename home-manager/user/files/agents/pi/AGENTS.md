# AGENTS.md

User-level agent instructions for software engineering workflows.

## Environment & Tools

**System:**
- Use GNU utilities (not BSD variants)
- GNU sed is available: `sed -i ///` syntax works for in-place editing
- `rg` (ripgrep) is available for searching
- Use `GIT_EDITOR=true` when rebasing to auto-accept the default todo list (avoids opening an interactive editor)
- Use `gh` for GitHub operations (PRs, issues, releases, API calls)

## Code Quality Boundaries

**Non-Negotiable Rules:**
1. **Never change code meaning without explicit discussion** - Preserve original intent
2. **Always complete reversions fully** - Remove all traces of abandoned approaches
3. **Prefer simplicity over cleverness** - Choose obvious solutions
4. **Ask questions when uncertain** - Don't make assumptions about requirements

**Design Principles:**
- **Optimize the feedback loop** — Always think about how to shorten the cycle between making a change and knowing if it works. Prefer fast, targeted test runs; use strong types to catch errors at compile time rather than runtime.
- Favor deep modules with simple interfaces
- Avoid unnecessary abstraction layers
- Keep code obvious and self-documenting
- Think strategically about long-term maintainability

**Anti-Patterns to Avoid:**
- Shallow modules with complex interfaces
- Configuration parameters to avoid design decisions
- Breaking up cohesive functionality into many small pieces
- Adding complexity for minor gains
- **Dynamic imports (`await import(...)`)** — Always use static `import` at the top of the file. Dynamic imports make dependency tracking harder, break tree-shaking, and hide load-time errors. No exceptions.

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

## Execution Discipline

**Default mode is PROPOSE, not EXECUTE.**

When the task involves:
- RFC/document drafting: propose changes, wait for approval before editing
- Multi-file or multi-repo changes: present a plan, wait for go-ahead
- Git operations (commit, push, branch, PR): always ask first unless explicitly told

**Only execute without asking when:**
- The user says "do it", "go ahead", "implement", "commit and push"
- The task is an unambiguous single-file edit the user explicitly requested
- Running read-only commands (ls, grep, git diff, git log)

When uncertain about scope, stop and ask.

## Opportunistic Cleanup

When you encounter pre-existing issues while working:
- **Lint warnings/errors:** Fix them in any file you touch.
- **Build or test errors:** Fix them even if unrelated to your change. The build and tests must pass.
- **Style violations:** Fix them only when you are already changing code nearby (same function or adjacent lines). Do not go hunting through the file.
- **Minor bugs:** Do not fix them silently. Raise them to the user as a separate observation.

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

## Writing Conventions

When drafting RFCs, PRs, docs, or any written content:
- No bold in body text unless the user uses bold
- No em dashes. Use commas or periods instead.
- Plain markdown tables (no colspan hacks, keep it renderable)
- PR descriptions: Why + What format, concise bullets, no walls of text
- Commit messages: imperative mood, subject under 72 chars, body is bullets
- "remove X" means delete it completely. Don't rephrase or relocate it.

## RFC and Document Drafting

When iterating on documents (RFCs, PRs, docs):
- Make exactly the change requested. Don't reorganize surrounding text.
- After each change, show only the changed section, not the whole document.
- Don't add sections, context, or elaboration unless asked.
- When told "propose changes", describe what you'd change. Don't make the edits.

## Code Review

When reviewing code (or when `/review` is used):
- Use Conventional Comments format: `issue (blocking):`, `suggestion (non-blocking):`, `nitpick:`, `praise:`
- Flag only issues that meaningfully impact accuracy, performance, security, or maintainability
- Don't flag style preferences or hypothetical edge cases
- For migration reviews: always assess table lock impact
- Provide specific file:line references
- A short review with few findings is the right answer for good code

## Language Conventions

**TypeScript/Node:**
- Static imports only (no `await import(...)`)
- Prefer vitest patterns when test files use vitest
- No `any` without justification

**Go:**
- Follow existing test harness patterns in the repo
- Table-driven tests when testing multiple scenarios
- `t.Helper()` in test helpers

## Planning & RFCs

The `seriousben-agent-plans/` directory (gitignored) is available in any repo for generating RFCs, plans, and tracking work-in-progress. Use it to:

- **Draft RFCs** — Write design documents before implementing significant changes (`seriousben-agent-plans/rfcs/`)
- **Create plans** — Break down complex tasks into step-by-step plans (`seriousben-agent-plans/plans/`)
- **Track WIP** — Record current progress, open questions, and next steps (`seriousben-agent-plans/wip/`)

When asked to create a plan and no other planning process is defined, use this directory. Update WIP notes as you go so context is preserved across sessions and compactions.

**Important:** Never reference `seriousben-agent-plans/` or any of its contents in committed code, comments, commit messages, PRs, or any other artifacts that leave the local workspace. This directory is strictly for internal agent use only.

## Subagent Usage

Delegate implementation work to subagents. Keep the main agent focused on orchestration, verification, and responding to user steering. This preserves context window for high-value decisions.

## When in Doubt

- Choose the simpler approach
- Ask questions rather than assume
- Follow existing patterns
- Think like a maintainer
---

*"The greatest limitation in writing software is our ability to understand the systems we are creating."* - John Ousterhout

Remember: Beautiful code is not just code that works - it's code that can be easily understood, modified, and extended by any competent engineer who encounters it.
