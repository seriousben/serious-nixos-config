# Pi Coding Agent Configuration

Managed via nix home-manager. Edit files here, run `make apply` from repo root.

## Extensions

### Commands

| Command | What it does |
|---------|--------------|
| `/review` | Code review with interactive mode selector. Forks a fresh session branch so review context stays isolated from your work. Supports: PR (`/review pr 123`), branch diff (`/review branch main`), uncommitted changes, specific commit, folder snapshot, custom instructions. Use `/end-review` to summarize findings and return to your original session position. Has loop-fix mode to iterate on issues. |
| `/handoff <goal>` | Extracts relevant context from current session, generates a focused prompt, and opens a **new session** with it. Your old session stays untouched — get back to it with `/resume`. You review/edit the generated prompt before submitting. Use when the current session is long or context-heavy and you need a clean start on a related task. |
| `/answer` | When the agent asks multiple questions, extracts them into a navigable TUI. Answer each one individually, then submit all answers at once. Faster than typing inline responses to multi-part questions. |

### Automatic (transparent)

| Extension | What it does |
|-----------|--------------|
| `notify` | Desktop notification (OSC 777) when agent finishes and waits for input. Works in Ghostty, iTerm2, WezTerm. |
| `permission-gate` | Prompts for confirmation before `sudo`, `chmod 777`, or any write/edit to files outside `~/src/`. |
| `raw-paste` | Handles large bracketed pastes without corruption. Arm with keybinding before pasting large blocks. |
| `subagent` | Registers a `subagent` tool the LLM can call to spawn isolated pi processes. Supports single, parallel (up to 8, 4 concurrent), and chain modes. Each subagent gets its own context window. |
| `tab-status` | Terminal tab title shows pi status: `:running...`, `:✅` (committed), `:🚧` (done, no commit), `:🛑` (timeout). |
| `verbosity-leash` | Injects conciseness rules into system prompt for commit messages, PR descriptions, changelogs, docs. |

## Subagents

Agent definitions in `agents/` → `~/.pi/agent/agents/`. The LLM picks which agent to use based on descriptions.

| Agent | Model | Tools | Purpose |
|-------|-------|-------|---------|
| `scout` | haiku | read, grep, find, ls, bash | Fast codebase recon. Returns structured findings for handoff. |
| `worker` | sonnet | all | General-purpose. Full capabilities, isolated context. |

Example usage (just tell the agent what you want):
- "Run 3 scouts in parallel: find auth code, find DB schema, find API routes"
- "Use 2 workers in parallel: one adds tests for auth, one adds tests for billing"
- "Chain: scout the payment module, then have a worker refactor it"

## Skills

| Skill | Trigger | What it does |
|-------|---------|--------------|
| `humanizer` | `/skill:humanizer` | Remove AI writing patterns from prose |
| `code-simplifier` | `/skill:code-simplifier` or auto | Simplify recently modified code for clarity and maintainability |
| `deslop` | `/skill:deslop` or auto | Remove AI code slop from diffs (comments, defensive code, `any` casts) |
| `systematic-debugging` | `/skill:systematic-debugging` or auto | 4-phase root-cause-first debugging protocol |
| `verify-completion` | `/skill:verify-completion` or auto | No completion claims without running verification |
| `pi-harness-introspect` | `/skill:pi-harness-introspect` | Audit pi setup against session history and community repos |
| `pi-customize` | auto | Guides adding skills and customization, global or per-repo |

Skills marked "or auto" may be loaded automatically when the agent recognizes a matching task from the description.

## File Layout

```
home-manager/user/files/agents/pi/
├── agents/              # .md files → ~/.pi/agent/agents/
├── extensions/          # .ts files → ~/.pi/agent/extensions/
├── skills/              # SKILL.md dirs → ~/.pi/agent/skills/
├── settings.json        # → ~/.pi/agent/settings.json
├── AGENTS.md            # → ~/.pi/agent/AGENTS.md
└── README.md            # this file
```
Humanizer skill comes from `trailofbits/skills-curated` flake input.

## Sources

- [seriousben/pi-extensions star list](https://github.com/stars/seriousben/lists/pi-extensions) — curated list of extension repos to watch

Extensions and skills adapted from:

- [mitsuhiko/agent-stuff](https://github.com/mitsuhiko/agent-stuff) — review, answer, notify, context, todos, multi-edit, files, loop, session-breakdown
- [badlogic/pi-mono](https://github.com/badlogic/pi-mono) — handoff, permission-gate, protected-paths (official examples)
- [tmustier/pi-extensions](https://github.com/tmustier/pi-extensions) — raw-paste, tab-status, files-widget, skill-creator
- [butttons/pi-kit](https://github.com/butttons/pi-kit) — verbosity-leash, explore-guard, safe-commit, auto-commit-nudge, session-recall, thinking-stash, plan-mode, dora
- [trailofbits/skills-curated](https://github.com/trailofbits/skills-curated) — humanizer skill
- [obra/superpowers](https://github.com/obra/superpowers) — systematic-debugging, verify-completion, test-driven-development, writing-plans, executing-plans, subagent-driven-development
- [laulauland/dotfiles](https://github.com/laulauland/dotfiles) — deslop, commit, pr commands, librarian/simplifier agents, agent-browser skill
- [HazAT/pi-config](https://github.com/HazAT/pi-config) — session-artifacts, cost tracking, watchdog, cmux, panel-agents, planner/reviewer/worker agents, code-simplifier skill
- [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official) — code-simplifier (upstream source)
- [EveryInc/compound-engineering-plugin](https://github.com/EveryInc/compound-engineering-plugin) — specialized review agents (code-simplicity, security, architecture, data-migration), git-history-analyzer
- [prateekmedia/pi-hooks](https://github.com/prateekmedia/pi-hooks) — checkpoint, lsp diagnostics, repeat
- [ben-vargas/pi-packages](https://github.com/ben-vargas/pi-packages) — stack trace trimming, ancestor discovery, exa search, firecrawl
