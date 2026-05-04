# OAuth 2.0 Refresh Token and Authorization Expiration

## draft-ietf-oauth-refresh-token-expiration-01

**Problem:** OAuth has no standard way to tell clients when refresh tokens or the overall authorization will expire. Clients discover expiration only when a refresh fails, causing poor UX (unexpected re-auth prompts) and making it impossible to proactively re-authorize.

**Mechanism:** Adds two new fields to the token response:

- `refresh_expires_in` — Seconds until the refresh token expires. Analogous to `expires_in` for access tokens.
- `authorization_expires_in` — Seconds until the entire authorization grant expires. After this, no amount of refreshing will work; the user must re-authorize.

AS metadata: `refresh_token_expiration_supported` and `authorization_expiration_supported` advertise support.

**Example:**
```json
{
  "access_token": "eyJhbGc...",
  "token_type": "Bearer",
  "expires_in": 3600,
  "refresh_token": "dGhpcyBpcyBh...",
  "refresh_expires_in": 86400,
  "authorization_expires_in": 2592000
}
```

Client knows: access token expires in 1 hour, refresh token in 24 hours, entire authorization in 30 days. Can plan re-auth UX accordingly.

**When to use:** Any app that uses refresh tokens and wants to avoid surprise re-auth. Mobile apps that need to show "your session expires in X days." Compliance contexts requiring explicit authorization lifetime visibility.

**Tradeoffs:** WG draft (rev 01, February 2026). Simple addition, backward compatible. Clients that don't understand the new fields ignore them.

**Link:** [Draft](https://datatracker.ietf.org/doc/draft-ietf-oauth-refresh-token-expiration/01/)
