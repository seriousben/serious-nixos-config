# DPoP (Demonstrating Proof of Possession)

## RFC 9449

**Problem:** Bearer tokens are like cash. Anyone who possesses the token can use it. Interception (compromised TLS, XSS, malicious extensions) means immediate unauthorized access.

**Mechanism:** Client generates key pair. Requests token with DPoP proof JWT (signed with private key, includes public key). Authorization server binds token to that key. Each API call requires fresh DPoP proof JWT containing method, URL, token hash (ath), timestamp, and jti. Resource server verifies signature, binding, hash, timestamp, and jti uniqueness.

**Example:**

```bash
# Request token with DPoP proof
curl -X POST https://auth.example.com/token \
  -H "DPoP: eyJhbGc...signature" \
  -d "grant_type=authorization_code&code=abc123"
# Response: {"access_token": "...", "token_type": "DPoP"}

# Access resource with fresh DPoP proof (includes ath claim)
curl https://api.example.com/data \
  -H "Authorization: DPoP eyJhbGc..." \
  -H "DPoP: eyJhbGc...new-signature-with-ath"
```

**Tradeoffs:** Adds per-request signing overhead. Client must manage key pair. Not all resource servers support verification yet.

**When to use:** High-value APIs, mobile apps, any context where token theft is a realistic threat. Required by FAPI 2.0.

**Provider support:** Auth0 (DPoP), Okta (DPoP).

**Link:** [RFC 9449](https://datatracker.ietf.org/doc/html/rfc9449)
