---
name: oauth-identity-research
description: |
  OAuth/OIDC/identity protocol research assistant. Use when dealing with identity
  protocols, or when analyzing, comparing, or designing around OAuth 2.0, OpenID
  Connect, token security, authorization patterns, or identity federation specs.
  Provides structured mental models and knows key specs, their problems, and
  tradeoffs.
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

### Core framework
- **OAuth 2.1** (WG draft-15) — Consolidates OAuth 2.0 + all security fixes into one spec; the modern baseline → `refs/oauth-2-1.md`
- **JWT Best Practices** (WG draft-04) — Updated BCP for JWT producers and consumers; replaces RFC 8725 → `refs/jwt-bcp.md`

### Token exchange & conversion
- **RFC 8693** (Token Exchange) — Convert tokens across systems without re-auth → `refs/token-exchange.md`
- **Token Exchange Target Discovery** (draft-01) — Discover which services a token can be exchanged for → `refs/token-exchange-discovery.md`
- **RFC 7523** (JWT Bearer) — Service auth with signed JWTs, no shared secrets → `refs/jwt-bearer.md`
- **JWT DPoP Grant** (draft-01) — JWT Bearer grant with DPoP-bound tokens; sender-constrained service auth → `refs/jwt-dpop-grant.md`

### Token security & binding
- **RFC 9449** (DPoP) — Bind tokens to key pairs; stolen tokens are useless → `refs/dpop.md`
- **Macaroons** — Long-lived tokens with caveats and just-in-time transaction approval → `refs/macaroons.md`
- **RFC 9700** (Security BCP) — Mandatory PKCE, exact redirect URIs, no implicit grant → `refs/security-bcp.md`
- **Refresh Token Expiration** (WG draft-01) — Signal refresh token and authorization grant lifetimes to clients → `refs/refresh-token-expiration.md`
- **Global Token Revocation** (draft-06) — Revoke all tokens for a user across all clients → `refs/global-token-revocation.md`

### Fine-grained authorization
- **RFC 9396** (RAR) — Structured JSON authorization instead of coarse scopes → `refs/rar.md`
- **AuthZEN** (v1.0) — Standard API for externalized authorization decisions (PEP ↔ PDP) → `refs/authzen.md`
- **Grant Management** (draft) — Query, merge, and revoke OAuth grants; user-visible consent management → `refs/grant-management.md`

### Resource metadata
- **Resource in Token Response** (draft-03) — Echo resource URI in token response so client can confirm token target → `refs/resource-token-response.md`
- **Protected Resource Metadata Update** (draft-01) — Clarifies RFC 9728 resource identifier validation rules → `refs/rfc9728bis.md`

### Agentic authorization
- **TBAC research** — Semantic task-to-scope matching; retrofits OAuth with intent-aware scope granting → `refs/tbac.md`
- **AAuth Protocol** (draft-02) — Agent-native protocol replacing OAuth; cryptographic agent identity, mission-based governance, no pre-registration → `refs/aauth.md`

### Client authentication
- **SPIFFE Client Auth** (WG draft-01) — Workload identity via SPIFFE JWT-SVID for OAuth client auth; no client secrets → `refs/spiffe-client-auth.md`

### Identity & federation
- **Entity Profiles** (draft-01) — Classify OAuth entities (client, subject) by type: user, service, ai_agent, device; enables entity-type-aware policy → `refs/entity-profiles.md`
- **Actor Profile** (draft-00) — Classify actors in delegation chains using Entity Profile vocabulary → `refs/actor-profile.md`
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

## Registered claims, parameters & grant types

Key terms introduced or defined by specs in this skill. Use this to quickly find which spec defines a term.

### JWT claims

| Claim | Defined in | Purpose |
|-------|-----------|--------|
| `act` | RFC 8693 | Actor in delegation chain (nestable) |
| `may_act` | RFC 8693 | Pre-authorizes specific actors for delegation |
| `client_profile` | Entity Profiles (draft) | Classifies the client type (web_app, service, ai_agent) |
| `sub_profile` | Entity Profiles (draft) | Classifies the token subject type |
| `actor_profile` | Actor Profile (draft) | Classifies actor within `act` claim |
| `authorization_details` | RFC 9396 (RAR) | Structured authorization request (replaces coarse scopes) |
| `cnf` | RFC 9449 (DPoP) | Confirmation claim binding token to key |
| `ath` | RFC 9449 (DPoP) | Access token hash in DPoP proof |
| `events` | SSF / RISC / CAEP | Security event payload in SETs |
| `sid` | OIDC Back-Channel Logout | Session ID for targeted logout |
| `tenant` | OIDC Enterprise Ext. | Tenant identifier in multi-tenant OPs |
| `session_expiry` | OIDC Enterprise Ext. | Unix timestamp for session expiration |
| `aud_sub` | OIDC Enterprise Ext. | RP's identifier for the account |

### OAuth parameters

| Parameter | Defined in | Purpose |
|-----------|-----------|--------|
| `domain_hint` | OIDC Enterprise Ext. | Hint for OP tenant selection |
| `prompt=create` | OIDC Prompt Create | Direct user to signup instead of login |
| `device_secret` | OIDC Native SSO | Shared secret for cross-app SSO on device |
| `resource` | RFC 8707 / Resource Token Resp. | Target resource for token; echoed in response |
| `refresh_expires_in` | Refresh Token Exp. (draft) | Seconds until refresh token expires |
| `authorization_expires_in` | Refresh Token Exp. (draft) | Seconds until authorization grant expires |
| `grant_id` | Grant Management (draft) | Identifier for managing OAuth grants |
| `DPoP` | RFC 9449 | HTTP header carrying DPoP proof JWT |
| `login_hint` | CIBA | User identifier hint for backchannel auth |
| `binding_message` | CIBA | Message displayed on both devices for verification |

### Grant types

| Grant type URI | Defined in | Purpose |
|---------------|-----------|--------|
| `urn:ietf:params:oauth:grant-type:token-exchange` | RFC 8693 | Token exchange |
| `urn:ietf:params:oauth:grant-type:jwt-bearer` | RFC 7523 | JWT assertion grant |
| `urn:openid:params:grant-type:ciba` | CIBA | Backchannel auth grant |

### Client auth methods

| Method | Defined in | Purpose |
|--------|-----------|--------|
| `private_key_jwt` | OIDC Core / RFC 7523 | Client auth via signed JWT |
| `spiffe_jwt_svid` | SPIFFE Client Auth (draft) | Client auth via SPIFFE workload identity |

### Token type URIs (RFC 8693)

`urn:ietf:params:oauth:token-type:{access_token, refresh_token, id_token, saml1, saml2, jwt}`

### Well-known endpoints

| Endpoint | Defined in | Purpose |
|----------|-----------|--------|
| `/.well-known/openid-configuration` | OIDC Discovery | OP metadata |
| `/.well-known/oauth-authorization-server` | RFC 8414 | AS metadata |
| `/.well-known/oauth-resource-server` | RFC 9728 | Protected resource metadata |
| `/.well-known/openid-federation` | OpenID Federation | Entity configuration for trust chains |
| `/.well-known/fastfed-configuration` | FastFed | Federation handshake metadata |

## Maintaining this skill

See `update-skill.md` for guidance on adding new specs and updating existing ones.

## Evaluation checklist

When recommending a spec or pattern for a specific use case:

- [ ] Does the problem actually require this? Simpler alternatives ruled out?
- [ ] Provider support (Okta, Auth0, Entra, Keycloak) for the spec?
- [ ] Draft vs RFC — what's the maturity and adoption?
- [ ] What breaks if you skip it? What's the actual risk?
- [ ] Does it compose with other specs already in use?
