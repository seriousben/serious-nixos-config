# OAuth Client ID Metadata Document (CIMD)

## draft-ietf-oauth-client-id-metadata-document-01

**Problem:** Traditional OAuth requires pre-registering every client with every authorization server. For open ecosystems (ActivityPub federation, MCP servers), this doesn't scale. Client doesn't know which servers exist. Server doesn't know which clients will connect. Dynamic Client Registration (RFC 7591) helps but creates data management and cleanup challenges.

**Mechanism:** Client publishes metadata at a public HTTPS URL and uses that URL as its `client_id`. Authorization server fetches the document to read client metadata (name, logo, redirect URIs, grant types).

**Constraints:**
- `client_id` must be HTTPS (no fragments, no credentials)
- Metadata `client_id` field must match the URL exactly
- Only public client auth methods (no shared secrets)
- Servers may restrict redirect URIs to same origin as `client_id`

**Example:**

```json
{
  "client_id": "https://app.example.com/client-metadata.json",
  "client_name": "Example App",
  "redirect_uris": ["https://app.example.com/callback"],
  "grant_types": ["authorization_code", "refresh_token"],
  "token_endpoint_auth_method": "none",
  "scope": "openid profile email"
}
```

**Metadata caching:** Authorization servers should cache fetched metadata. Spec defines caching behavior to avoid re-fetching on every request while allowing metadata updates.

**Development use:** Spec includes provisions for localhost/development client metadata documents, addressing a practical gap for local testing.

**Security considerations (expanded in -01):**
- Redirect URI vs client_id origin relationship
- Client metadata mutation risks (keys, redirect URIs changing)
- SSRF attacks via metadata fetch
- Maximum response size limits
- Logo display phishing risks
- Domain trust for client_id URLs
- Coexistence with pre-registered clients

**When to use:** Federated systems where pre-registration is impractical. ActivityPub/Mastodon, MCP server authentication, development tooling.

**Links:** [Draft](https://datatracker.ietf.org/doc/draft-ietf-oauth-client-id-metadata-document/01/), [MCP SEP-991](https://github.com/modelcontextprotocol/modelcontextprotocol/issues/991)
