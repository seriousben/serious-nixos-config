---
name: pi-customize
description: |
  Guide adding pi agent skills, extensions, and configuration. Use when the user
  wants to add, modify, or organize skills, extensions, agents, or AGENTS.md
  rules. Covers both global (user-level) and per-repo (project-level) customization.
  Triggers on requests like "add a skill", "customize pi", "add an extension",
  "set up project agents", or any task about pi agent configuration.
---

# Pi Customize

Help the user add or modify pi agent customization. Always start by asking
whether the change should be global (all repos) or per-repo (project-local).

## Global vs per-repo

| Scope | Where it lives | Deployed how |
|-------|---------------|--------------|
| Global | `~/.pi/agent/` (skills, extensions, agents, AGENTS.md, settings.json) | Managed via [serious-nixos-config](https://github.com/seriousben/serious-nixos-config). Edit files in `home-manager/user/files/agents/pi/`, then `make apply`. |
| Per-repo | `.pi/` at the repo root (AGENTS.md, agents/, skills/) | Committed to the project repo. No nix involvement. |

Ask the user which scope before making changes. If unclear, ask.

## Global customization

Global config is nix-managed. Source of truth is the `serious-nixos-config` repo.

**File layout:**

```
home-manager/user/files/agents/pi/
├── AGENTS.md            # → ~/.pi/agent/AGENTS.md
├── settings.json        # → ~/.pi/agent/settings.json
├── agents/              # → ~/.pi/agent/agents/
├── extensions/          # → ~/.pi/agent/extensions/
├── skills/              # → ~/.pi/agent/skills/
└── README.md            # documents sources and setup
```

**To add a global extension:**
1. Add the `.ts` file to `home-manager/user/files/agents/pi/extensions/`
2. Add a `home.file` entry in `home-manager/user/default.nix` if not already
   covered by a directory-level entry
3. Run `make apply`

**To add a global skill:**
1. Create `home-manager/user/files/agents/pi/skills/<name>/SKILL.md`
2. Add a `home.file` entry in `home-manager/user/default.nix` if needed
3. Run `make apply`

For skills from external repos, add a flake input and wire it through
`home-manager/user/default.nix`. See the `humanizer` skill (uses
`skills-curated` flake input) as a reference.

**To modify AGENTS.md or settings:**
Edit the file in `home-manager/user/files/agents/pi/`, then `make apply`.

**Keep README.md up to date.** When adding extensions or skills sourced from
a community repo, add the repo to the Sources section in
`home-manager/user/files/agents/pi/README.md`. This is the central reference
for all pi agent community sources. Check the existing list before adding
duplicates.

## Per-repo customization

Per-repo config lives in the project and is committed alongside the code.

**File layout:**

```
.pi/
├── AGENTS.md            # project-specific agent instructions
├── agents/              # project-specific agent definitions
└── skills/              # project-specific skills
```

**To add a project skill:**
1. Create `.pi/skills/<name>/SKILL.md`
2. Commit to the repo

**To add project agent instructions:**
1. Create or edit `.pi/AGENTS.md`
2. Commit to the repo

Per-repo config is layered on top of global config. Project AGENTS.md
instructions are combined with global AGENTS.md at runtime.

## Community sources

Before writing a new extension or skill from scratch, check if something
already exists. The full list of community repos is in
`home-manager/user/files/agents/pi/README.md` under Sources. Key repos:

- [mitsuhiko/agent-stuff](https://github.com/mitsuhiko/agent-stuff) — extensions
- [obra/superpowers](https://github.com/obra/superpowers) — skills
- [butttons/pi-kit](https://github.com/butttons/pi-kit) — extensions
- [laulauland/dotfiles](https://github.com/laulauland/dotfiles) — commands, agents, skills
- [HazAT/pi-config](https://github.com/HazAT/pi-config) — extensions, agents

When adopting from a community repo, add a `// Source:` comment at the top of
the file with the GitHub URL.

## Checklist

After any customization change:

- [ ] Files are in the correct scope (global vs per-repo)
- [ ] `make apply` run (global changes only)
- [ ] README.md Sources section updated if a new community repo was used
- [ ] Extension/skill tested (load pi, verify it appears)
