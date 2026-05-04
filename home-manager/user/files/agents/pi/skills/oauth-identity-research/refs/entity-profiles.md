# OAuth 2.0 Entity Profiles

## draft-mora-oauth-entity-profiles-01

**Problem:** OAuth has no standard way to express *what kind of entity* a client or token subject is. A backend service, a browser SPA, a native app, and an AI agent all look the same in tokens and metadata. Resource servers can't make entity-type-aware authorization decisions without out-of-band knowledge.

**Mechanism:** Defines two new JWT claims and corresponding metadata parameters:

- `client_profile` — Classifies the client initiating the OAuth flow (e.g., `web_app`, `native_app`, `ai_agent`, `service`, `device`, `browser_app`)
- `sub_profile` — Classifies the entity represented by the `sub` claim in the token (e.g., `user`, `service`, `ai_agent`)

Seven standardized profiles: `user`, `device`, `native_app`, `web_app`, `browser_app`, `service`, `ai_agent`. Custom profiles are also supported.

These claims can appear in access tokens, ID tokens, JWT authorization grant assertions, transaction tokens, and token introspection responses. Also defines how profiles work in delegation chains via the `act` claim (RFC 8693), so each actor in a delegation chain can be classified.

AS metadata: `entity_profiles_supported` advertises which profiles the AS recognizes.
Dynamic registration: client declares `client_profile` during registration.

**Example:**

```json
{
  "iss": "https://as.example.com",
  "sub": "agent-xyz",
  "sub_profile": "ai_agent",
  "client_profile": "service",
  "aud": "https://api.example.com",
  "act": {
    "sub": "user-123",
    "sub_profile": "user"
  }
}
```

Resource server sees: the client is a service, the subject is an AI agent, acting on behalf of a user. Can apply different policies for each entity type.

**When to use:** Systems where authorization policy depends on the type of caller. AI agent governance (different permissions for agents vs users). Zero-trust architectures that need entity classification in tokens. Audit trails that need to distinguish entity types.

**Tradeoffs:** Individual draft (draft-01, April 2026). Not yet adopted by a WG. Profiles are advisory, not enforced by the protocol (resource server decides what to do with them). Risk of misclassification if client self-reports. Authors from Microsoft and independent.

**Link:** [Draft](https://datatracker.ietf.org/doc/draft-mora-oauth-entity-profiles/01/)
