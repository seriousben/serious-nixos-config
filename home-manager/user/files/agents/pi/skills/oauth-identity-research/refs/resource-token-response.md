# OAuth 2.0 Resource Parameter in Access Token Response

## draft-mcguinness-oauth-resource-token-resp-03

**Problem:** Client requests an access token for a specific resource (RFC 8707 `resource` parameter). The AS issues the token, but the response doesn't echo back which resource the token is bound to. Client can't confirm the token is for the intended resource without decoding it.

**Mechanism:** Adds a `resource` parameter to the token response. When the AS issues a token bound to a specific resource, it includes the resource URI in the response.

**Example:**
```json
{
  "access_token": "eyJhbGc...",
  "token_type": "Bearer",
  "expires_in": 3600,
  "resource": "https://api.example.com"
}
```

Client can verify the token was issued for the right resource without parsing the JWT.

**When to use:** Multi-resource environments where clients request tokens for specific APIs. Disambiguation when a client has tokens for multiple resources.

**Tradeoffs:** Individual draft (rev 03, March 2026). Simple, backward compatible. Author: Karl McGuinness.

**Link:** [Draft](https://datatracker.ietf.org/doc/draft-mcguinness-oauth-resource-token-resp/03/)
