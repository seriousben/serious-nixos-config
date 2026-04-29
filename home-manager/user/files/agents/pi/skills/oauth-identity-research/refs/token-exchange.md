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

**When to use:** Microservices with user context, multi-IdP companies, format conversion (OAuth/SAML/OIDC).

**Provider support:** Okta (On-Behalf-Of), Auth0 (Custom Token Exchange).

## Token Exchange Target Service Discovery (draft)

**Problem:** Clients must hardcode service lists and handle access errors. No way to ask "what can I exchange my token for?"

**Mechanism:** Client queries authorization server with current token, server returns available exchange targets with scopes, client exchanges for specific service.

**Example:**

```bash
curl -X POST https://auth.example.com/token-exchange-targets \
  -d '{"subject_token": "eyJhbGc...", "subject_token_type": "urn:ietf:params:oauth:token-type:access_token"}'
# Response: {"targets": [{"audience": "https://payment.example.com", "scope": "payment:initiate"}]}
```

**When to use:** Dynamic service catalogs, mobile apps that show only accessible features.

**Links:** [RFC 8693](https://www.rfc-editor.org/rfc/rfc8693.html), [Discovery draft](https://datatracker.ietf.org/doc/draft-mcguinness-token-xchg-target-svc-disco/)
