# OAuth 2.0 JWT Authorization Grant with DPoP Binding

## draft-parecki-oauth-jwt-dpop-grant-01

**Problem:** JWT Bearer grant (RFC 7523) issues bearer tokens. Stolen tokens are usable by anyone. DPoP (RFC 9449) binds tokens to keys but only works with authorization code and client credentials grants, not JWT Bearer.

**Mechanism:** Combines JWT Bearer grant with DPoP proof-of-possession. Client presents both a JWT assertion (for authorization) and a DPoP proof (for key binding). The resulting access token is DPoP-bound.

Flow:
1. Client creates a JWT assertion (as in RFC 7523).
2. Client creates a DPoP proof JWT bound to the token endpoint.
3. Client sends both to the token endpoint.
4. AS issues a DPoP-bound access token.

**Example:**
```bash
curl -X POST https://as.example.com/token \
  -H "DPoP: eyJhbGc...dpop-proof" \
  -d "grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer" \
  -d "assertion=eyJhbGc...jwt-assertion"
# Response: {"access_token": "...", "token_type": "DPoP"}
```

**When to use:** Service-to-service auth (JWT Bearer) that also needs sender-constrained tokens (DPoP). High-security environments where JWT Bearer alone isn't sufficient.

**Tradeoffs:** Individual draft (rev 01, January 2026). Combines two existing mechanisms. Adds DPoP overhead to JWT Bearer flows. Author: Aaron Parecki.

**Link:** [Draft](https://datatracker.ietf.org/doc/draft-parecki-oauth-jwt-dpop-grant/01/)
