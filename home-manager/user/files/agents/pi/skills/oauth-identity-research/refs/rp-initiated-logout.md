# OpenID Connect RP-Initiated Logout

## openid-connect-rpinitiated-1_0

**Problem:** User clicks "Log Out" in the RP. RP clears its own session but the OP session persists. User thinks they're logged out but other RPs still have active sessions via the OP.

**Mechanism:** RP redirects user to the OP's `end_session_endpoint` with:

- `id_token_hint` — the ID token, so OP knows which user/session
- `post_logout_redirect_uri` — where to send the user after OP logout
- `client_id` — identifies the RP (alternative to id_token_hint)
- `state` — for CSRF protection on the redirect back

OP terminates the session and optionally triggers Back-Channel or Front-Channel Logout to other RPs.

**Example:**
```
https://op.example.com/logout?
  id_token_hint=eyJhbGc...&
  post_logout_redirect_uri=https://app.example.com/logged-out&
  state=abc123
```

**When to use:** Any app with a logout button that uses OIDC. This is the standard way to propagate logout to the OP.

**Tradeoffs:** Simple to implement. Requires a browser redirect (not suitable for API-only logout). OP may prompt the user to confirm logout if no id_token_hint is provided.

**Provider support:** Universal. All major OPs support this.

**Link:** [Spec](https://openid.net/specs/openid-connect-rpinitiated-1_0.html)
