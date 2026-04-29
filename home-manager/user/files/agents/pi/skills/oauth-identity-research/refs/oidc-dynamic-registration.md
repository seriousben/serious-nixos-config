# OpenID Connect Dynamic Client Registration

## openid-connect-registration-1_0

**Problem:** Traditional OAuth requires pre-registering clients with each authorization server (manual portal, admin API). Doesn't scale for dynamic ecosystems where clients discover servers at runtime.

**Mechanism:** Client POSTs its metadata to the OP's `registration_endpoint` (discovered via OIDC Discovery). OP returns a `client_id` and optionally `client_secret`.

Registration request includes:
- `redirect_uris` — Required
- `client_name`, `logo_uri`, `client_uri` — Display info
- `grant_types`, `response_types` — What the client needs
- `token_endpoint_auth_method` — How the client authenticates
- `subject_type` — `public` or `pairwise`

OP may return a `registration_access_token` for reading/updating the registration later.

**Example:**
```bash
curl -X POST https://op.example.com/register \
  -H "Content-Type: application/json" \
  -d '{
    "redirect_uris": ["https://app.example.com/callback"],
    "client_name": "My App",
    "grant_types": ["authorization_code"],
    "token_endpoint_auth_method": "client_secret_basic"
  }'
# Response: {"client_id": "abc123", "client_secret": "...", ...}
```

**When to use:** Development tools that connect to arbitrary OPs. Federated ecosystems. Testing environments.

**Tradeoffs:** Security concern: open registration endpoints can be abused (spam registrations, phishing). Most production deployments require authentication or disable it entirely. Consider Client ID Metadata Document (CIMD) as an alternative that avoids registration entirely.

**Contrast with CIMD:** Dynamic Registration creates a client_id at the OP. CIMD uses a URL as the client_id with self-published metadata. CIMD needs no registration endpoint but only supports public clients.

**Link:** [Spec](https://openid.net/specs/openid-connect-registration-1_0.html)
