# OpenID Connect Discovery

## openid-connect-discovery-1_0

**Problem:** Client needs to know the OP's endpoints (authorization, token, userinfo, JWKS), supported scopes, signing algorithms, and capabilities. Without discovery, this is hardcoded or manually configured per OP.

**Mechanism:** OP publishes JSON metadata at `{issuer}/.well-known/openid-configuration`. Client fetches it to auto-configure.

Key fields:
- `issuer` — OP's issuer identifier (must match `iss` in tokens)
- `authorization_endpoint`, `token_endpoint`, `userinfo_endpoint`
- `jwks_uri` — Where to fetch signing keys
- `scopes_supported`, `response_types_supported`
- `subject_types_supported` — `public` or `pairwise`
- `id_token_signing_alg_values_supported`
- `token_endpoint_auth_methods_supported`

Also defines WebFinger-based issuer discovery (RFC 7033): given a user's email, discover which OP to use.

**Example:**
```bash
curl https://accounts.google.com/.well-known/openid-configuration
# Returns: {"issuer": "https://accounts.google.com", "authorization_endpoint": "...", ...}
```

**When to use:** Always. Any OIDC client should use discovery instead of hardcoding endpoints. Required by most OIDC libraries.

**Tradeoffs:** Universally supported. Adds one HTTP call at startup. WebFinger-based discovery is rarely used in practice; most clients know the issuer URL directly.

**Provider support:** Every OIDC provider implements this.

**Link:** [Spec](https://openid.net/specs/openid-connect-discovery-1_0.html)
