---
name: oauth-identity-research
description: |
  OAuth/OIDC/identity protocol research assistant. Use when analyzing, comparing,
  or designing around OAuth 2.0, OpenID Connect, token security, authorization
  patterns, or identity federation specs. Provides structured mental models and
  knows key specs, their problems, and tradeoffs.
---

# OAuth & Identity Research

Structured thinking for OAuth 2.0, OpenID Connect, and identity protocol work.

## When to use

- Evaluating which OAuth extension fits a problem
- Designing token security or authorization flows
- Comparing identity federation approaches
- Reviewing implementations for spec compliance
- Researching new specs or drafts

## How to respond

For any identity/auth question, structure the answer around:

1. **Problem** — What specific limitation or security gap does this address? One sentence.
2. **Mechanism** — How does it work technically? Brief, no fluff.
3. **Tradeoffs** — What does it cost? Complexity, latency, provider support, maturity.
4. **When to use / skip** — Concrete criteria, not "it depends."

Keep answers concise. Link to RFCs and specs. No analogies unless asked.

When deeper context is needed on a specific spec, read the corresponding file from `refs/` (resolve relative to this skill directory).

## Spec landscape

### OpenID Connect extensions
- **OIDC Enterprise Extensions** (draft) — Multi-tenant OP interop: `tenant`, `session_expiry`, `aud_sub`, `domain_hint` → `refs/oidc-enterprise-extensions.md`
- **OIDC Native SSO** — SSO across native apps on same device via device secret + token exchange → `refs/oidc-native-sso.md`
- **OIDC Prompt Create** — `prompt=create` to direct user to signup instead of login → `refs/prompt-create.md`
- **CIBA** — Decoupled auth: one device initiates, user approves on another (POS, call center, CLI) → `refs/ciba.md`

### Discovery & registration
- **OIDC Discovery** — `.well-known/openid-configuration` for auto-configuring OP endpoints → `refs/oidc-discovery.md`
- **OIDC Dynamic Registration** — Programmatic client registration via POST to OP → `refs/oidc-dynamic-registration.md`
- **Client ID Metadata / CIMD** (WG draft-01) — Self-service client registration via HTTPS URL; no registration endpoint → `refs/client-id-metadata.md`
- **OpenID Federation** (Final) — Hierarchical trust chains via signed entity statements; automatic trust without bilateral setup → `refs/openid-federation.md`
- **FastFed** — Automated federation handshake between IdP and SaaS app (SAML + SCIM profiles) → `refs/fastfed.md`

### Token exchange & conversion
- **RFC 8693** (Token Exchange) — Convert tokens across systems without re-auth → `refs/token-exchange.md`
- **RFC 7523** (JWT Bearer) — Service auth with signed JWTs, no shared secrets → `refs/jwt-bearer.md`

### Token security & binding
- **RFC 9449** (DPoP) — Bind tokens to key pairs; stolen tokens are useless → `refs/dpop.md`
- **Macaroons** — Long-lived tokens with caveats and just-in-time transaction approval → `refs/macaroons.md`
- **RFC 9700** (Security BCP) — Mandatory PKCE, exact redirect URIs, no implicit grant → `refs/security-bcp.md`

### Fine-grained authorization
- **RFC 9396** (RAR) — Structured JSON authorization instead of coarse scopes → `refs/rar.md`
- **AuthZEN** (v1.0) — Standard API for externalized authorization decisions (PEP ↔ PDP) → `refs/authzen.md`
- **Grant Management** (draft) — Query, merge, and revoke OAuth grants; user-visible consent management → `refs/grant-management.md`

### Agentic authorization
- **TBAC research** — Semantic task-to-scope matching; retrofits OAuth with intent-aware scope granting → `refs/tbac.md`
- **AAuth Protocol** (draft-02) — Agent-native protocol replacing OAuth; cryptographic agent identity, mission-based governance, no pre-registration → `refs/aauth.md`

### Identity & federation
- **RFC 9493** (Subject Identifiers) — Eight standard formats for cross-system identity → `refs/subject-identifiers.md`
- **ID-JAG** (WG draft-03) — Enterprise SSO for APIs via trusted IdP; one login, many SaaS tokens, AI agent tool access → `refs/id-jag.md`
- **Identity Chaining** (WG draft-10, IETF Last Call) — Multi-hop authorization across domain boundaries; nearing RFC → `refs/identity-chaining.md`

### Logout
- **Back-Channel Logout** — OP sends signed logout JWT to RP backend; no browser needed → `refs/backchannel-logout.md`
- **Front-Channel Logout** — OP renders hidden iframes to RP logout URLs; browser-dependent → `refs/frontchannel-logout.md`
- **RP-Initiated Logout** — RP redirects user to OP logout endpoint; the standard "log out" flow → `refs/rp-initiated-logout.md`

### Shared signals & events
- **Shared Signals Framework** (Final) — Transport layer for security events; push and poll delivery → `refs/shared-signals-framework.md`
- **RISC Profile** (Final) — Account-level security events: credential compromise, account state changes → `refs/risc.md`
- **CAEP** (Final) — Session-level continuous evaluation: revocation, compliance change, IP change → `refs/caep.md`

### Verifiable credentials (OpenID4VC)
- **OID4VCI** — Issue verifiable credentials (mDL, diplomas, badges) to wallets via OAuth flows → `refs/oid4vci.md`
- **OID4VP** — Present verifiable credentials to verifiers with selective disclosure → `refs/oid4vp.md`

### High-security profiles
- **FAPI 2.0** — All security knobs to max; banking, healthcare, government → `refs/fapi.md`

## Maintaining this skill

See `update-skill.md` for guidance on adding new specs and updating existing ones.

## Evaluation checklist

When recommending a spec or pattern for a specific use case:

- [ ] Does the problem actually require this? Simpler alternatives ruled out?
- [ ] Provider support (Okta, Auth0, Entra, Keycloak) for the spec?
- [ ] Draft vs RFC — what's the maturity and adoption?
- [ ] What breaks if you skip it? What's the actual risk?
- [ ] Does it compose with other specs already in use?
