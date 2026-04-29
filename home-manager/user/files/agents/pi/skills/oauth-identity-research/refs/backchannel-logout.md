# OpenID Connect Back-Channel Logout

## openid-connect-backchannel-1_0

**Problem:** User logs out at the OP. RPs that used the OP for login don't know and keep sessions alive. Session Management uses iframes and third-party cookies, which browsers are killing.

**Mechanism:** OP sends a signed JWT (`logout_token`) directly to each RP's backchannel_logout_uri via HTTP POST. No browser involvement.

Logout token contains:
- `iss`, `aud` — standard issuer/audience
- `sub` and/or `sid` — identifies the user and/or session to terminate
- `events` claim with `http://schemas.openid.net/event/backchannel-logout` key
- `iat` — issued at
- No `nonce` (distinguishes it from ID tokens)

RP validates the JWT signature, finds matching sessions, terminates them, returns 200 OK.

**Example:**
```json
{
  "iss": "https://op.example.com",
  "sub": "user-12345",
  "aud": "app-client-id",
  "iat": 1735689600,
  "jti": "unique-logout-id",
  "events": {
    "http://schemas.openid.net/event/backchannel-logout": {}
  },
  "sid": "session-abc"
}
```

**When to use:** Any OIDC RP that needs reliable logout notification. Preferred over Session Management and Front-Channel Logout for server-rendered apps.

**Tradeoffs:** RP must expose a reachable endpoint (not suitable for pure SPAs without a backend). OP must track all RP sessions to notify them. Delivery is best-effort (HTTP POST may fail).

**Provider support:** Okta, Entra ID, Keycloak, Auth0 all support it.

**Link:** [Spec](https://openid.net/specs/openid-connect-backchannel-1_0.html)
