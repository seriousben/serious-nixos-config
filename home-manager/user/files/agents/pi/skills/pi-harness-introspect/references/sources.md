# Community Repos for Pi Harness Audit

Curated list of repos with useful pi extensions, skills, and agent configurations.
Quality ratings from prior evaluation (2026-03).

## High quality (trusted)

These repos have well-tested, well-documented code worth adopting directly.

### mitsuhiko/agent-stuff
- **URL:** https://github.com/mitsuhiko/agent-stuff
- **Notable extensions:**
  - `answer.ts` — Interactive Q&A extraction with custom TUI
  - `review.ts` — Multi-mode code review (PR, branch, uncommitted, commit)
  - `notify.ts` — Desktop notifications via OSC 777
  - `context.ts` — Shows loaded context, skills, extensions, token usage
  - `todos.ts` — File-based todo system with GC and session assignment
  - `multi-edit.ts` — Batched edits and Codex-style patch support
  - `files.ts` — File browser with diff, reveal, edit actions
  - `loop.ts` — Repeat prompt until condition met (tests pass, custom)
  - `session-breakdown.ts` — Session cost/token analysis
- **Best for:** Power-user extensions with polished TUI

### obra/superpowers
- **URL:** https://github.com/obra/superpowers
- **Notable skills:**
  - `systematic-debugging` — 4-phase root-cause-first debugging protocol
  - `verification-before-completion` — No completion claims without evidence
  - `test-driven-development` — Red-green-refactor with iron rules
  - `writing-plans` — Detailed implementation plan creation
  - `executing-plans` — Step-by-step plan execution with verification
  - `subagent-driven-development` — Dispatch subagents per task with review
  - `requesting-code-review` — Structured review dispatch
  - `finishing-a-development-branch` — Merge/PR/discard workflow
  - `brainstorming` — Spec creation with visual companion
  - `using-git-worktrees` — Worktree-based feature branches
- **Best for:** Structured development workflows, debugging discipline

### laulauland/dotfiles
- **URL:** https://github.com/laulauland/dotfiles
- **Notable items:** (in `shared/.claude/` and `shared/.config/opencode/`)
  - `commands/deslop.md` — Remove AI code slop from diffs
  - `commands/commit.md` — Structured commit creation
  - `commands/pr.md` — PR description generation
  - `commands/question.md` — Investigation-only mode (no modifications)
  - `agents/librarian.md` — Context gathering before implementation
  - `agents/simplifier.md` — Post-implementation code simplification
  - `skills/bear-notes/` — Bear.app note integration
  - `skills/agent-browser/` — Browser automation
- **Best for:** Commands that enforce discipline (no-change modes, deslop)

### EveryInc/compound-engineering-plugin
- **URL:** https://github.com/EveryInc/compound-engineering-plugin
- **Notable agents:**
  - `review/code-simplicity-reviewer.md` — YAGNI-focused review
  - `review/kieran-typescript-reviewer.md` — Strict TS quality bar
  - `review/security-sentinel.md` — OWASP/vulnerability scanning
  - `review/architecture-strategist.md` — Architecture review
  - `review/data-migration-expert.md` — Migration review
  - `research/git-history-analyzer.md` — Git archaeology
  - `research/repo-research-analyst.md` — Codebase exploration
- **Best for:** Specialized review agents with deep domain prompts

### trailofbits/skills-curated
- **URL:** https://github.com/trailofbits/skills-curated
- **Notable:** Smart contract vulnerability scanning skills (Solidity-specific)
- **Best for:** Only relevant if working with smart contracts

## Good quality

### HazAT/pi-config
- **URL:** https://github.com/HazAT/pi-config
- **Notable extensions:**
  - `session-artifacts/` — `write_artifact` tool for session-scoped files
  - `cost/` — Session and daily cost tracking from JSONL files
  - `watchdog/` — LLM judge that monitors session for drift/loops
  - `cmux/` — Push pi state to cmux sidebar
  - `panel-agents/` — Multi-panel agent orchestration
  - `claude-tool/` — Use Claude as a secondary model
- **Notable agents:**
  - `planner.md` — Interactive 7-phase planning with mandatory stops
  - `reviewer.md` — Code review with priority levels (P0-P3)
  - `worker.md` — Task implementation with verification
  - `researcher.md` — Research agent
  - `scout.md` — Codebase exploration
- **Best for:** Structured multi-agent workflows, cost tracking

### tmustier/pi-extensions
- **URL:** https://github.com/tmustier/pi-extensions
- **Notable:**
  - `tab-status/` — Terminal tab title with run status
  - `raw-paste/` — Bracketed paste handling for large content
  - `files-widget/` — File tree viewer with git integration
  - `extending-pi/skill-creator/` — Skill creation wizard
- **Best for:** Terminal UX polish

### butttons/pi-kit
- **URL:** https://github.com/butttons/pi-kit
- **Notable extensions:**
  - `verbosity-leash.ts` — System prompt injection for concise artifacts
  - `explore-guard.ts` — Limits consecutive read-only tool calls
  - `safe-commit.ts` — Confirmation before git commit
  - `auto-commit-nudge.ts` — Nudge to commit after N writes
  - `session-recall.ts` — Search past sessions by query
  - `thinking-stash.ts` — Capture/re-inject thinking on interrupt
  - `handoff.ts` — Context transfer to new session
  - `plan-mode/` — Separate planning mode
  - `dora.ts` — DORA metrics tracking
- **Best for:** Guardrails and workflow discipline extensions

## Lower relevance

### prateekmedia/pi-hooks
- **URL:** https://github.com/prateekmedia/pi-hooks
- **Notable:**
  - `checkpoint/` — Git-based checkpoints per turn (ref-based persistence)
  - `lsp/` — LSP diagnostics after edits (supports TS, Go, Python, Rust, etc.)
  - `repeat/` — Repeat last command
- **Best for:** LSP integration (high value if not using CI for type checking)

### ben-vargas/pi-packages
- **URL:** https://github.com/ben-vargas/pi-packages
- **Notable:**
  - `pi-cut-stack/` — Smart stack trace trimming
  - `pi-ancestor-discovery/` — Find project root by walking up
  - `pi-exa-mcp/` — Exa search integration
  - `pi-firecrawl/` — Web scraping
  - `pi-antigravity-image-gen/` — Image generation
- **Best for:** Specialized tool integrations
