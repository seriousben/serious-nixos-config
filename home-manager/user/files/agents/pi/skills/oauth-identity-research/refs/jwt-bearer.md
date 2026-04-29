# JWT Profile for OAuth 2.0

## RFC 7523

**Problem:** Service-to-service auth with shared secrets means secrets can leak. Need cryptographic proof instead.

**Mechanism:** Service creates signed JWT (iss, sub, aud, exp, signed with private key). Authorization server verifies with public key. Two uses: authorization grant (JWT → access token) or client authentication (JWT replaces client_secret).

**Example:**

```bash
curl -X POST https://auth.example.com/token \
  -d "grant_type=client_credentials" \
  -d "client_assertion_type=urn:ietf:params:oauth:client-assertion-type:jwt-bearer" \
  -d "client_assertion=eyJhbGc...signature"
```

**When to use:** Any machine-to-machine auth. Preferred over client secrets.

**Provider support:** Auth0 (private_key_jwt), Okta (private_key_jwt).

**Link:** [RFC 7523](https://datatracker.ietf.org/doc/html/rfc7523)
