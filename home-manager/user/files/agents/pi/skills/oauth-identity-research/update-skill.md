# Updating This Skill

## Purpose

These files exist to make OAuth/identity specs usable without re-reading the full RFC each time. Every entry should answer: "What problem does this solve, how, and should I care?"

## Adding a new spec

1. Create `refs/<name>.md`
2. Add one line to the right category in `SKILL.md`

### Ref file template

```markdown
# <Spec Name>

## <RFC/Draft identifier>

**Problem:** One sentence. What breaks without this?

**Mechanism:** How it works. Technical but brief. No filler.

**Example:** Curl command, JSON payload, or protocol flow. Something concrete.

**When to use:** Specific criteria. Not "when you need more security."

**Tradeoffs:** Cost, maturity, provider support, complexity.

**Link:** [Spec](url)
```

### SKILL.md entry format

```markdown
- **RFC XXXX** (Short Name) — One-line problem statement → `refs/filename.md`
```

Pick the right category. If none fits, add a new `###` section.

## Writing rules

**Lead with the problem.** "Service A needs to call Service B on behalf of a user" beats "This spec defines a mechanism for token exchange between parties in a distributed system."

**Be specific about when to use it.** "Microservices passing user context" not "distributed architectures." "Banking APIs" not "high-security environments."

**Include a working example.** A curl command or JSON snippet that shows the actual protocol. Skip the example if the spec is purely conceptual (like TBAC research).

**State tradeoffs honestly.** Draft status, no provider support, added complexity. If something is immature, say so.

**Keep cross-references.** When specs relate (TBAC vs AAuth, DPoP vs FAPI, Token Exchange vs Identity Chaining), add a one-line "Contrast with X" note.

## Updating existing files

Change only what changed. If an RFC gets a new version, update the mechanism and tradeoffs. If a draft becomes an RFC, update the identifier and maturity assessment. If a provider adds support, add it.

Don't rewrite files that don't need rewriting.

## What not to include

- No analogies (the brain dump has those; these files are for working reference)
- No history of how the spec evolved
- No exhaustive parameter lists (link to the spec for that)
- No provider implementation guides (link to provider docs)
