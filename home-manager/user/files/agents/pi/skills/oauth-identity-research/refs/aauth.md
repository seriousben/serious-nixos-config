# AAuth Protocol

## draft-hardt-aauth-protocol-02

**Problem:** OAuth assumes pre-registered clients with fixed integrations. Client IDs are server-specific (`client_id` at Google means nothing at GitHub). Shared secrets leak. Agents discover resources at runtime, span trust domains, need mid-task authorization. OAuth has no concept of agent identity, mission governance, or progressive authorization.

**Mechanism:** Every agent gets HTTPS-based cryptographic identity (`aauth:local@domain`) bound to a signing key, published at a well-known URL, verifiable by any party. No pre-registration, no shared secrets. All requests signed with HTTP Message Signatures (RFC 9421). Stolen tokens are useless without the private key.

Four progressive access modes:

1. **Identity-based** — Resource verifies agent's signed identity. Replaces API keys. No authorization flow needed.
2. **Resource-managed (2-party)** — Resource handles its own authorization via interaction/consent. Returns opaque access token.
3. **PS-managed (3-party)** — Resource issues resource token to agent's Person Server (PS). PS issues auth token carrying user identity, org membership, groups.
4. **Federated (4-party)** — Resource has its own Access Server (AS). PS federates with AS for cross-domain policy enforcement.

**Key concepts:**

- **Person Server (PS):** Represents the user. Manages missions, handles consent, asserts identity, brokers authorization. User chooses their own PS.
- **Agent Server:** Issues agent tokens binding signing keys to agent identity.
- **Missions:** Agent proposes intent in natural language. PS approves. All actions logged against mission context. Not a policy language; designed for decisions that can't be reduced to machine-evaluable rules.
- **Clarification chat:** Users can ask agents questions during consent. Agents can explain or adjust requests.
- **Multi-hop:** Call chaining and interaction chaining across services and trust domains.

**Key differences from OAuth:**

| | OAuth 2.0 | AAuth |
|---|---|---|
| Client identity | Server-issued, per-AS | Self-contained, global |
| Secrets | Shared secrets or PKCE | HTTP Message Signatures only |
| Token type | Bearer (default) | Proof-of-possession always |
| Registration | Pre-registration required | None; first call is registration |
| Agent governance | None | Missions, permissions, audit |
| Consent | One-time at authorization | Ongoing; clarification chat |
| Adoption | All-or-nothing | Progressive (4 independent modes) |

**Design rationale highlights:**
- No authorization code (signatures replace redirect security)
- No refresh tokens (agent re-requests with same mechanism)
- JSON instead of form-encoded (agent-native, not browser-native)
- Reuses OpenID Connect vocabulary for identity claims
- Missions are natural language, not a policy language, because agent behavior can't always be predicted

**Tradeoffs:**
- Very early (draft-02, April 2026). No provider support.
- New infrastructure required (Person Server, Agent Server, Access Server).
- Complexity of four access modes.
- Designed for a world where agents are primary HTTP clients, which isn't fully here yet.
- Competes with extending OAuth (GNAP, DPoP, etc.) rather than replacing it.

**When to use:** Designing agent-to-resource auth for autonomous agents. Understanding where OAuth fundamentally falls short for agentic workloads. Evaluating "extend OAuth" vs "replace OAuth" tradeoffs.

**Contrast with TBAC:** TBAC retrofits OAuth with semantic scope filtering (keeps OAuth, adds intelligence at the authorization server). AAuth replaces the protocol with mission-based governance (agent declares intent, person server evaluates holistically).

**Links:** [Draft](https://datatracker.ietf.org/doc/draft-hardt-aauth-protocol/02/), [GitHub](https://github.com/dickhardt/AAuth)
