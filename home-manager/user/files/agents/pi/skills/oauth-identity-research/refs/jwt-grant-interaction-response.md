# JWT Authorization Grant Interaction Response (JAG-IR)

## draft-parecki-oauth-jwt-grant-interaction-response-00

Individual draft (not WG-adopted), Informational intent. Authors: Parecki (Okta), Campbell (Ping), Liu (Alibaba).

**Problem:** The JWT Authorization Grant (RFC 7523) and ID-JAG issue tokens without user interaction, but some requests need explicit user consent (AI agent operations, high-risk transactions, GDPR consent, policy approval). Without a standard signal, the AS can only return an error, forcing the client to fall back to a full redirect-based OAuth flow and lose the benefit of the grant.

**Mechanism:** Adds a third token-endpoint outcome alongside token and error: an interaction response.

1. Client presents the assertion (e.g. ID-JAG) to the Resource AS token endpoint via `urn:ietf:params:oauth:grant-type:jwt-bearer`, optionally adding a `redirect_uri`.
2. AS validates the grant but decides interaction is required. Returns HTTP 400 `application/json` with `error: interaction_required`, `interaction_uri` (https), `interval` (poll spacing, default 5s), `expires_in`.
3. Client launches `interaction_uri` in a browser; user completes the interaction (consent, step-up, etc.).
4. Client learns it is done via either: polling (re-send the same assertion; meanwhile gets `interaction_pending` / `slow_down` / `access_denied`), or a bare redirect to `redirect_uri` (no code, just a completion signal) then retry.
5. AS sees the interaction is complete and issues the access token on the next request.

The redirect carries no authorization code or token; it is only a "interaction complete, retry now" signal. Lower latency than polling alone (Device Authorization Grant style without forced polling).

**Example:**

```
POST /token HTTP/1.1
Host: auth.example.com
Content-Type: application/x-www-form-urlencoded

grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer
&assertion=eyJhbGciOi...
&redirect_uri=https://client.example.org/callback
```

```
HTTP/1.1 400 Bad Request
Content-Type: application/json

{
  "error": "interaction_required",
  "interaction_uri": "https://auth.example.com/interact/abc123",
  "interval": 5,
  "expires_in": 600
}
```

**When to use:** A jwt-bearer / ID-JAG request that may need a human in the loop before token issuance: AI agent consent, step-up for sensitive operations, auditable regulatory consent, fine-grained policy approval. Also the standardized hook for any AS-driven interaction gate (a first-time account setup / JIT provisioning-with-confirmation step could live in this interaction, though the draft frames it around consent, not provisioning).

**Tradeoffs:** Very early (rev 00), individual draft with no formal IETF standing, Informational intent, no provider support yet. Treat as a direction signal, not a dependency. Note: it does not itself provision accounts; ID-JAG still assumes the subject resolves to an existing account, and JAG-IR only gives the AS a standard way to pause and run an interaction first.

**Contrast with:** Device Authorization Grant (RFC 8628) also returns a URI + polling interval, but JAG-IR adds the redirect/callback option for lower latency and is scoped to the jwt-bearer grant rather than device-code entry. Composes directly with ID-JAG (draft-ietf-oauth-identity-assertion-authz-grant): the flow chains ID-JAG → JWT grant → `interaction_required`.

**Link:** [Draft](https://datatracker.ietf.org/doc/html/draft-parecki-oauth-jwt-grant-interaction-response-00)
