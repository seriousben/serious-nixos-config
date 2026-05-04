# Token Exchange

## RFC 8693: OAuth 2.0 Token Exchange

**Problem:** Service A needs to call Service B on behalf of a user, but Service B requires its own access token. Without token exchange, this means re-authentication.

**Mechanism:** Authorization server acts as Security Token Service (STS). Send existing token (subject token), receive new token for different audience/resource/format. Two patterns: impersonation (new token = original user) or delegation (new token includes `act` claim identifying the calling service).

**Example:**

```bash
curl -X POST https://auth.example.com/token \
  -u "service-a:secret" \
  -d "grant_type=urn:ietf:params:oauth:grant-type:token-exchange" \
  -d "subject_token=eyJhbGc..." \
  -d "audience=https://service-b.example.com"
```

**Delegation vs impersonation:**

- **Impersonation** — New token has the original user as `sub`. No trace of the intermediary. Resource server can't tell Service A is involved.
- **Delegation** — New token includes an `act` (actor) claim identifying the intermediary. Resource server sees both the user and who is acting on their behalf.

**The `act` claim (registered JWT claim):**

Nestable claim that identifies the acting party in a delegation chain. Each `act` contains a `sub` (and optionally `iss`) for the actor, and can itself contain another `act` for multi-hop delegation.

```json
{
  "sub": "user-123",
  "act": {
    "sub": "service-a",
    "iss": "https://auth.example.com",
    "act": {
      "sub": "gateway-proxy",
      "iss": "https://auth.example.com"
    }
  }
}
```

Reads as: gateway-proxy acted on behalf of service-a, which acted on behalf of user-123.

Also defines `may_act` — an optional claim in the subject token that pre-authorizes specific actors. AS checks `may_act` before issuing a delegation token.

**Registered token type URIs:**
- `urn:ietf:params:oauth:token-type:access_token`
- `urn:ietf:params:oauth:token-type:refresh_token`
- `urn:ietf:params:oauth:token-type:id_token`
- `urn:ietf:params:oauth:token-type:saml1`
- `urn:ietf:params:oauth:token-type:saml2`
- `urn:ietf:params:oauth:token-type:jwt`

**When to use:** Microservices with user context, multi-IdP companies, format conversion (OAuth/SAML/OIDC). The `act` claim is the foundation for all delegation chain specs (Entity Profiles, Actor Profile, Transaction Tokens).

**Provider support:** Okta (On-Behalf-Of), Auth0 (Custom Token Exchange).

**Link:** [RFC 8693](https://www.rfc-editor.org/rfc/rfc8693.html)
