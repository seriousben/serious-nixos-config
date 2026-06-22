# AGENTS.md

User-level agent instructions for software engineering workflows.

<critical_notes>
These rules are non-negotiable and apply for the entire session.

- Never change code meaning without explicit discussion. Preserve original intent.
- "remove X" means delete it completely. Do not rephrase, relocate, or comment it out.
- Complete reversions fully. Remove all traces of abandoned approaches: imports, variables, methods.
- No dynamic imports (`await import(...)`). Use static `import` at the top of the file. No exceptions.
</critical_notes>

<environment>
- GNU utilities, not BSD. GNU `sed -i` in-place syntax works.
- `rg` (ripgrep) is available; prefer it over grep in shell commands.
- `GIT_EDITOR=true` when rebasing, so git doesn't get stuck opening an editor for the rebase todo list.
- `gh` for GitHub operations (PRs, issues, releases, API calls).
</environment>

<execution_discipline>
Default mode is PROPOSE, not EXECUTE.

Propose and wait for approval when the task involves:
- RFC or document drafting
- Multi-file or multi-repo changes (present a plan first)
- Git operations: commit, push, branch, PR

Execute without asking only when:
- I say "do it", "go ahead", "implement", "commit and push"
- It is an unambiguous single-file edit I explicitly requested
- It is read-only (ls, grep, git diff, git log)

When uncertain about scope, stop and ask.
</execution_discipline>

<workflow>
- Understand code before modifying. Preserve established patterns.
- Optimize the feedback loop: shorten the cycle between making a change and knowing if it works. Prefer fast, targeted test runs and strong types over runtime checks.
- Prefer one script over many tool calls. When a task needs several shell steps, write a single bash script that runs them together rather than issuing separate calls. Fewer round-trips is faster and cheaper.
- Keep scratch scripts and command output in `seriousben-agent-plans/scratch/` (gitignored). Avoid `/tmp` so file writes and cleanup don't trip sandbox prompts.
- Capture command output once, inspect it many times. Never re-run a command just to filter its output differently:
  ```bash
  mkdir -p seriousben-agent-plans/scratch
  long_command &> seriousben-agent-plans/scratch/out.txt
  tail -30 seriousben-agent-plans/scratch/out.txt
  rg "Failure" seriousben-agent-plans/scratch/out.txt
  ```
</workflow>

<opportunistic_cleanup>
When you encounter pre-existing issues while working:
- Lint errors: fix them in any file you touch.
- Build or test errors: fix them even if unrelated. The build and tests must pass.
- Style violations: fix only when already changing nearby code (same function or adjacent lines). Do not go hunting.
- Minor bugs: do not fix silently. Raise them as a separate observation.
</opportunistic_cleanup>

<writing>
For RFCs, PRs, docs, commits, and any written content:
- No bold in body text unless I use bold.
- No em dashes. Use commas or periods.
- Plain renderable markdown tables, no colspan hacks.
- PR descriptions: Why + What, concise bullets, no walls of text.
- Commit messages: imperative mood, subject under 72 chars, body is bullets.

When iterating on a document:
- Make exactly the change requested. Do not reorganize surrounding text.
- Show only the changed section after each edit, not the whole document.
- Do not add sections or elaboration unless asked.
- "propose changes" means describe them, do not make the edits.
</writing>

<code_review>
When reviewing code (or on `/review`):
- Use Conventional Comments: `issue (blocking):`, `suggestion (non-blocking):`, `nitpick:`, `praise:`.
- Flag only what meaningfully impacts accuracy, performance, security, or maintainability.
- Do not flag style preferences or hypothetical edge cases.
- For migrations: always assess table lock impact.
- Give specific file:line references.
- A short review with few findings is the right answer for good code.
</code_review>

<language_conventions>
TypeScript/Node:
- Static imports only. No `any` without justification.
- Prefer vitest patterns when test files use vitest.

Go:
- Follow the repo's existing test harness patterns.
- Table-driven tests for multiple scenarios. `t.Helper()` in test helpers.
</language_conventions>

<planning>
`seriousben-agent-plans/` (gitignored) is available in any repo for RFCs (`rfcs/`), plans (`plans/`), WIP tracking (`wip/`), and scratch scripts/output (`scratch/`). Use it when asked to plan and no other process is defined. Update WIP notes as you go so context survives across sessions and compactions.

Never reference `seriousben-agent-plans/` or its contents in committed code, comments, commit messages, PRs, or anything that leaves the local workspace.
</planning>

<estimation>
Never estimate in time units. Use T-shirt sizes for complexity:
- S: small, single file or straightforward fix.
- M: a few files, some design thought.
- L: multiple files or components, needs a plan.
- XL: cross-cutting, multi-system, needs an RFC.

Label each step of a plan with a size. Answer "how long" / "how big" with a size.
</estimation>

<subagents>
Delegate implementation work to subagents. Keep the main agent focused on orchestration, verification, and responding to steering. This preserves context for high-value decisions.
</subagents>

<north_star>
The lens I work through, in priority order when they conflict:

- Empathy. Code is read and maintained by people. Optimize for the next human, in the code and in the review.
- Vision. Know where the system is heading. Make today's change fit tomorrow's shape.
- Curiosity. Understand before changing. Follow the interesting thread; the eclectic detour often pays off.

For code design specifically, follow A Philosophy of Software Design (Ousterhout): deep modules, manage complexity, prefer strategic over tactical work.
</north_star>
