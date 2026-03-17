---
name: pi-harness-audit
description: |
  Audit and improve a user's pi coding agent setup. Analyzes session history,
  current AGENTS.md, extensions, and skills, then cross-references community
  repos to propose targeted improvements. Use when asked to review/improve pi
  configuration, suggest new extensions or skills, or optimize the agent harness.
---

# Pi Harness Audit

Analyze a user's pi setup and session history to propose targeted improvements
to their AGENTS.md, extensions, skills, and workflow.

## Nix Home-Manager Context

The pi harness is managed via nix home-manager in this repo (CWD). Changes
to pi configuration follow the nix workflow, not direct file edits.

**Source of truth:**
- `home-manager/files/claude/AGENTS.md` -- shared as both `~/.pi/agent/AGENTS.md` and `~/.claude/CLAUDE.md`
- `home-manager/files/pi/extensions/` -- pi extensions (updated via `make update-pi-extensions`)
- `home-manager/files/pi/settings.json` -- pi settings
- `home-manager/default.nix` -- wires files to `~/.pi/agent/` via symlinks

**Skills:**
- Nix-managed skills use flake inputs (e.g. `skills-curated`) and `home.file` entries in `default.nix`
- The `~/.pi/agent/skills/` directory itself is real (not nix-managed), so skills
  can also be placed there directly for quick iteration before nixifying

**Deployment:**
- Edit source files in `home-manager/files/`
- Run `make apply` (which runs `darwin-rebuild switch --flake .#seriousben-mbp`)
- Files are symlinked through the nix store to `~/.pi/agent/`

**Adding new extensions:** Add the `.ts` file to `home-manager/files/pi/extensions/`,
optionally add a curl line to the `update-pi-extensions` Makefile target if sourced
from a remote repo, then `make apply`.

**Adding new skills:** Either place directly in `~/.pi/agent/skills/<name>/SKILL.md`
for quick use, or add a flake input + `home.file` entry for nix-managed skills.

**AGENTS.md is shared with Claude Code.** Changes to AGENTS.md affect both
`~/.pi/agent/AGENTS.md` and `~/.claude/CLAUDE.md`. Keep instructions
harness-agnostic or use conditional language.

## Process

### Phase 1: Inventory current setup

Gather what exists before looking at anything else.

```bash
# Nix home-manager source files (the actual source of truth)
ls home-manager/files/pi/extensions/
ls home-manager/files/pi/settings.json
cat home-manager/files/claude/AGENTS.md

# What's deployed (symlinks into nix store)
ls -la ~/.pi/agent/extensions/
ls -la ~/.pi/agent/skills/

# Current skills (may include non-nix-managed ones)
find ~/.pi/agent/skills -name "SKILL.md" 2>/dev/null

# Settings
cat ~/.pi/agent/settings.json

# Makefile targets for extension management
grep -A2 "^update-pi-extensions" Makefile

# Flake inputs for skills
grep -B1 -A3 "skills" flake.nix

# Project-level AGENTS.md (if in a project with one)
cat .pi/AGENTS.md 2>/dev/null || cat AGENTS.md 2>/dev/null
```

### Phase 2: Analyze session history

Extract user messages from recent sessions to find correction patterns,
workflow patterns, and pain points.

**Session file format:** JSONL where entries have `type: "message"` and
`message: { role, content }`. User messages have `role: "user"`.

Use a single Python script to extract user messages — avoid per-line shell
parsing of JSONL (too fragile, quoting issues with `basename` on paths
containing `--`).

```python
# Write to a temp file, then read it — don't try to inline this in bash
import os, json, glob, re, collections

sessions_dir = os.path.expanduser("~/.pi/agent/sessions")
# Skip test/e2e sessions
skip_patterns = ["serac-e2e", "serac-debug", "private-tmp", "private-var"]

# Sort by modification time (most recent first)
dirs = sorted(
    os.listdir(sessions_dir),
    key=lambda d: os.path.getmtime(os.path.join(sessions_dir, d)),
    reverse=True
)

# Extract user messages
for d in dirs:
    if any(p in d for p in skip_patterns):
        continue
    session_path = os.path.join(sessions_dir, d)
    if not os.path.isdir(session_path):
        continue
    short_name = d.replace("--Users-USERNAME-src-", "").strip("-")

    for f in sorted(glob.glob(os.path.join(session_path, "*.jsonl")), reverse=True)[:5]:
        prev_was_assistant = False
        for line in open(f):
            data = json.loads(line)
            if data.get("type") != "message":
                continue
            msg = data.get("message", {})
            role = msg.get("role")
            if role == "user" and prev_was_assistant:
                content = msg.get("content", "")
                if isinstance(content, list):
                    text = " ".join(
                        p.get("text", "") for p in content
                        if isinstance(p, dict) and p.get("type") == "text"
                    )
                else:
                    text = str(content)
                text = text.strip()
                if text and len(text) > 5:
                    print(f"[{short_name}] {text[:400]}")
            prev_was_assistant = (role == "assistant")
```

**Important:** The session directory names encode the path with `--` delimiters
(e.g. `--Users-bob-src-myproject--`). Don't use `basename` on these — it
treats leading `--` as an option flag. Just string-replace to get a short name.

**What to look for in user messages:**

Count correction patterns (short messages after assistant responses):

| Pattern | What it reveals |
|---------|----------------|
| "remove X", "delete X" | Agent adds unwanted content |
| "no bold", "no em dashes" | Agent uses wrong formatting |
| "plan only", "plan first", "don't change" | Agent executes when user wants discussion |
| "undo", "revert" | Agent made wrong changes |
| "wrong", "that's wrong" | Agent misunderstood |
| "continue" | Agent stopped prematurely or user is steering step-by-step |
| "why?" | Agent did something without explaining |
| "commit", "push", "branch" | Git workflow patterns |

Count by category to prioritize AGENTS.md fixes.

Also identify:
- **Languages/tech** used across projects (from project names and message content)
- **Workflow patterns** (RFC drafting, code review, multi-repo, debugging)
- **Repeated manual instructions** the user pastes into sessions

### Phase 3: Clone and examine community repos

Clone repos the user provides (or use the [reference list](references/sources.md)
as a starting point). Use `--depth 1` to minimize time.

**What to look for in each repo:**

```bash
# Structure overview
find REPO -name "*.ts" -o -name "*.md" -o -name "SKILL.md" | head -40

# Extension entry points
head -40 REPO/extensions/*.ts REPO/pi-extensions/*.ts 2>/dev/null

# Skill descriptions
grep -A5 "^description:" REPO/skills/*/SKILL.md 2>/dev/null

# Agent definitions
cat REPO/agents/*.md 2>/dev/null | head -60
```

**Evaluate each item against the user's actual patterns:**
- Does it address a correction pattern found in Phase 2?
- Does it match their tech stack and workflow?
- Is it transparent (auto-loaded) or triggered (command)?
- Does it duplicate something they already have?
- Does it add complexity beyond its value?

### Phase 4: Produce the plan

Structure the output as a plan document with:

1. **Analysis summary** — what you found in their sessions (correction counts,
   workflow patterns, tech stack)
2. **Current setup** — what they already have
3. **Recommendations ordered by impact** — each with:
   - Source (which repo/idea)
   - Impact type: transparent vs triggered
   - Why it matters (tied to specific session patterns)
   - Size estimate
4. **What you're NOT recommending** — and why (shows you evaluated everything)
5. **Implementation order** — table with priority, type, effort

### Phase 5: (Optional) Implement approved items

If the user approves items from the plan, implement them following the
nix home-manager workflow:

- **AGENTS.md changes:** Edit `home-manager/files/claude/AGENTS.md` (shared
  with Claude Code). Then `make apply`.
- **Extensions:** Add `.ts` files to `home-manager/files/pi/extensions/`.
  If sourced from a remote repo, add a curl line to the `update-pi-extensions`
  Makefile target. Then `make apply`.
- **Skills (local):** Add to `home-manager/files/pi/skills/<name>/SKILL.md`
  and add a `home.file` entry in `home-manager/default.nix` using
  `./files/pi/skills/<name>`. Then `make apply`.
  See `pi-harness-audit` as a reference pattern.
- **Skills (external repo):** Add a flake input for the source repo and a
  `home.file` entry in `home-manager/default.nix`, then `make apply`.
  See the `humanizer` skill as a reference pattern (uses `skills-curated`
  flake input).
- **Settings:** Edit `home-manager/files/pi/settings.json`, then `make apply`.

## Pitfalls learned from experience

### Nix home-manager specifics

- **Don't edit `~/.pi/agent/` files directly.** They are nix store symlinks
  (read-only). Edit the source in `home-manager/files/` and run `make apply`.
  Exception: AGENTS.md and Claude Code files use `mkOutOfStoreSymlink`
  (editable live symlinks to the repo). Everything else is a nix store copy.
- **AGENTS.md is CLAUDE.md.** The pi AGENTS.md and Claude Code CLAUDE.md are
  the same file (`home-manager/files/claude/AGENTS.md`). Any change affects
  both harnesses. Write harness-agnostic instructions.
- **Extensions and skills are nix store copies.** After editing source files
  in `home-manager/files/`, `make apply` is required for changes to deploy.
- **Flake inputs for skills are pinned.** The `skills-curated` input is pinned
  in `flake.lock`. Run `nix flake update skills-curated` to get newer versions.

### Session data extraction

- **Don't parse JSONL with shell tools.** User messages contain JSON, quotes,
  newlines, and special characters. Use Python.
- **Session dirs have `--` prefix.** The path encoding uses `--` as delimiters.
  GNU `basename` treats `--` as end-of-options. Use string manipulation instead.
- **Message type is `"message"`, not `"user"`.** The top-level `type` field is
  always `"message"` for conversation entries. The role is inside
  `entry.message.role`.
- **Content can be string or array.** User messages may have
  `content: [{type: "text", text: "..."}]` or `content: "string"`. Handle both.
- **Write extraction scripts to temp files.** Inline Python in bash with
  variable interpolation breaks on paths containing quotes or special chars.

### Repo evaluation

- **Read actual extension code, not just READMEs.** Many repos over-describe
  simple functionality. The code tells you actual scope and quality.
- **Check if extensions are pi-compatible.** Some repos target Claude Code or
  OpenCode with different APIs (Bash, Edit, Write tool names differ).
  Pi extensions use `@mariozechner/pi-coding-agent` types.
- **Skills are more portable than extensions.** A Claude Code skill (markdown
  instructions) works in pi with minimal changes. Extensions need pi's API.

### Recommendation quality

- **Tie every recommendation to observed session patterns.** "This is a good
  idea" is weak. "You corrected formatting 80 times across sessions" is strong.
- **Prefer AGENTS.md changes over new extensions.** AGENTS.md changes are
  zero-cost (no code, no maintenance, instant effect). Extensions need to be
  maintained across pi upgrades.
- **Transparent > triggered for frequent patterns.** If the user corrects
  something in every session, it should be automatic, not a command.
- **Explain what you're skipping.** The user gave you repos to evaluate.
  Showing you considered and rejected items builds trust in the recommendations.

## Reference sources

See [references/sources.md](references/sources.md) for a curated list of
community repos worth evaluating.
