# OpenID Connect Enterprise Extensions

## openid-connect-enterprise-extensions-1_0 (draft-01)

**Problem:** Enterprise OIDC deployments have diverged on common needs: multi-tenant OP identification, session lifetime signaling, and account linking. Each vendor invented their own parameters, breaking interop.

**Mechanism:** Defines three optional ID Token claims and authentication request parameters:

- `session_expiry` — Unix timestamp indicating when the RP session must expire. OP tells RP the session lifetime instead of RP guessing.
- `tenant` — Identifies which tenant within a multi-tenant OP the user belongs to. Reserved values: `personal` (individual-managed account), `organization` (org-managed account), or an opaque OP-unique value.
- `aud_sub` — Opaque string representing the identifier the RP already has for the account. Enables account linking without the RP sending its user ID in the auth request.

Authentication request parameters: `domain_hint` (hint for OP to select tenant), `tenant` (explicit tenant selection).

Third-party login initiation: adds `client_id`, `domain_hint`, `tenant` to the login initiation endpoint for multi-tenant apps hosting multiple client_ids.

**When to use:** Multi-tenant enterprise SSO. SaaS apps connecting to customer IdPs where you need to route to the right tenant and control session lifetime.

**Tradeoffs:** Very early (draft-01, September 2025). Co-authored by Dick Hardt (Hellō) and Karl McGuinness. Standardizes what Okta, Entra, and others already do with proprietary parameters. Low risk to adopt since claims are optional.

**Link:** [Spec](https://openid.net/specs/openid-connect-enterprise-extensions-1_0.html)
