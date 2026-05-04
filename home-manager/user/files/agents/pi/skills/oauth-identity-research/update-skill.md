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

## Finding specs

Authoritative sources for each spec group. Use these to check for new versions, discover related specs, and verify current status.

### IETF OAuth WG (core framework, token exchange, security, client auth)

**WG document list (adopted drafts):**
https://datatracker.ietf.org/wg/oauth/documents/

This page lists all active and completed OAuth WG documents. Adopted drafts have `draft-ietf-oauth-` prefix. Individual submissions have author-name prefix (e.g., `draft-parecki-`, `draft-mcguinness-`).

**Search for drafts by name:**
https://datatracker.ietf.org/doc/search/?name=draft-ietf-oauth&activedrafts=on

**API to get document metadata (title, rev, date, status):**
```bash
curl -s 'https://datatracker.ietf.org/api/v1/doc/document/<draft-name>/?format=json' | python3 -c "
import sys, json; d = json.load(sys.stdin)
print(f\"{d['name']} | rev:{d['rev']} | {d['time'][:10]} | {d['title']}\")
"
```

**Read a draft's HTML:**
https://www.ietf.org/archive/id/<draft-name>-<rev>.html

**Published RFCs (final specs):**
https://www.rfc-editor.org/rfc/rfc<number>.html

**Key individual draft authors to watch:**
- Aaron Parecki (`draft-parecki-oauth-*`) - token revocation, DPoP grant, ID-JAG
- Karl McGuinness (`draft-mcguinness-oauth-*`, `draft-mcguinness-token-xchg-*`) - actor profile, resource metadata, token exchange discovery
- Dick Hardt (`draft-hardt-*`) - AAuth protocol
- Sreyantha Chary Mora (`draft-mora-oauth-*`) - entity profiles

To find all drafts by an author:
```bash
curl -s 'https://datatracker.ietf.org/doc/search/?name=draft-<lastname>&activedrafts=on' \
  | grep -oP '/doc/(draft-[^/]+)/' | sort -u
```

### OpenID Foundation (OIDC extensions, logout, shared signals, verifiable credentials, high-security profiles)

**All specs index:**
https://openid.net/developers/specs/

**List all spec URLs programmatically:**
```bash
curl -s 'https://openid.net/developers/specs/' | grep -oP 'https://openid\.net/specs/[^"]+' | sort -u
```

**Working groups with their own spec pages:**
- AB/Connect WG (OIDC core, extensions, logout): https://openid.net/wg/connect/specifications/
- Shared Signals WG (SSF, RISC, CAEP): https://openid.net/wg/sharedsignals/specifications/
- DCP WG (OID4VCI, OID4VP, SD-JWT VC): https://openid.net/wg/digital-credentials-protocols/specifications/
- FAPI WG (FAPI 2.0, grant management): https://openid.net/wg/fapi/specifications/
- AuthZEN WG (authorization API): https://openid.net/wg/authzen/specifications/
- FastFed WG: https://openid.net/wg/fastfed/specifications/

**Final vs draft:** URLs ending in `-final.html` are finalized. Others are implementer's drafts.

### IETF RFCs referenced in this skill

| RFC | Topic | URL |
|-----|-------|-----|
| 6749 | OAuth 2.0 (superseded by 2.1 draft) | https://www.rfc-editor.org/rfc/rfc6749.html |
| 7523 | JWT Bearer | https://www.rfc-editor.org/rfc/rfc7523.html |
| 8693 | Token Exchange | https://www.rfc-editor.org/rfc/rfc8693.html |
| 8707 | Resource Indicators | https://www.rfc-editor.org/rfc/rfc8707.html |
| 9396 | RAR | https://www.rfc-editor.org/rfc/rfc9396.html |
| 9449 | DPoP | https://www.rfc-editor.org/rfc/rfc9449.html |
| 9493 | Subject Identifiers | https://www.rfc-editor.org/rfc/rfc9493.html |
| 9700 | Security BCP | https://www.rfc-editor.org/rfc/rfc9700.html |
| 9728 | Protected Resource Metadata | https://www.rfc-editor.org/rfc/rfc9728.html |

### Research papers (agentic authorization)

- TBAC (Task-Based Authorization Control): https://arxiv.org/abs/2510.26702v1
- AAuth GitHub repo: https://github.com/dickhardt/AAuth

### Checking for updates

When updating this skill, check in this order:

1. OAuth WG documents page for new adopted drafts or version bumps
2. OpenID specs index for new final specs or new implementer's drafts
3. Datatracker search for new individual drafts by the key authors listed above
4. Each ref file's Link URL to see if the draft rev has incremented

## Updating existing files

Change only what changed. If an RFC gets a new version, update the mechanism and tradeoffs. If a draft becomes an RFC, update the identifier and maturity assessment. If a provider adds support, add it.

Don't rewrite files that don't need rewriting.

## What not to include

- No analogies (the brain dump has those; these files are for working reference)
- No history of how the spec evolved
- No exhaustive parameter lists (link to the spec for that)
- No provider implementation guides (link to provider docs)
