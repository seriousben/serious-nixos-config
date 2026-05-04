# OAuth 2.0 Token Exchange Target Service Discovery

## draft-mcguinness-token-xchg-target-svc-disco-01

**Problem:** Token exchange (RFC 8693) requires clients to know which target services they can exchange tokens for. Clients hardcode service lists or discover through errors. No standard way to ask "what services can I reach with this token?"

**Mechanism:** Adds a discovery endpoint where clients query the AS with their current token and receive a list of available exchange targets.

Request: client sends subject token to the discovery endpoint.
Response: list of targets, each with audience URI, available scopes, and display metadata.

**Example:**
```bash
curl -X POST https://as.example.com/token-exchange-targets \
  -H "Content-Type: application/json" \
  -d '{
    "subject_token": "eyJhbGc...",
    "subject_token_type": "urn:ietf:params:oauth:token-type:access_token"
  }'
# Response:
# {
#   "targets": [
#     {"audience": "https://payment.example.com", "scope": "payment:initiate"},
#     {"audience": "https://crm.example.com", "scope": "crm:read"}
#   ]
# }
```

**When to use:** Dynamic service catalogs. Mobile apps showing only accessible features. Any system where available exchange targets vary per user or token.

**Tradeoffs:** Individual draft (rev 01, February 2026). Simple extension to RFC 8693. AS must maintain and expose target service registry. Author: Karl McGuinness.

**Link:** [Draft](https://datatracker.ietf.org/doc/draft-mcguinness-token-xchg-target-svc-disco/01/)
