# Identity Assertion JWT Authorization Grant (ID-JAG)

## draft-ietf-oauth-identity-assertion-authz-grant-03

Also known as "Cross App Access" (XAA). WG-adopted from the earlier individual draft (`draft-parecki-`). Builds on Identity Chaining (`draft-ietf-oauth-identity-chaining`) with specific details for SSO-trusted IdP scenarios.

**Problem:** Employee logs into internal app via Okta. App needs to call Salesforce API on behalf of that employee. Without this: employee sees Salesforce login (confusing), or you store Salesforce passwords (insecure), or build custom integrations per system (doesn't scale).

**Mechanism:**

1. User authenticates with enterprise IdP (Okta), app gets identity assertion (ID token or SAML assertion).
2. App calls IdP token exchange endpoint: "I have this identity assertion for user@example.com, I need access to Salesforce with scopes crm:read crm:write." IdP returns ID-JAG JWT.
3. App calls Salesforce (Resource AS) token endpoint with ID-JAG as a JWT authorization grant. Salesforce validates IdP signature, resolves the subject via its existing SSO trust, issues access token.
4. App calls Salesforce API.

Technical: uses `urn:ietf:params:oauth:grant-type:token-exchange` (RFC 8693) to get ID-JAG from IdP, then `urn:ietf:params:oauth:grant-type:jwt-bearer` (RFC 7523) to get access token from Resource AS.

**Key benefit:** IdP that the Resource AS already trusts for SSO brokers API access. Resource AS still decides what to authorize. User never sees a second login.

**Cross-domain client ID handling:** Client may have different `client_id` at IdP vs Resource AS. The ID-JAG carries both so the Resource AS can map correctly.

**Tenant awareness:** Spec addresses multi-tenant IdPs where issuer-tenant and client-tenant relationships affect subject identifier uniqueness.

**SAML interop:** Supports SAML 2.0 assertions as identity assertion input (not just OIDC ID tokens).

**AI agent use case:** Spec includes an appendix for AI agents accessing external tools, where the agent obtains an ID-JAG from the user's IdP to call tool APIs.

**When to use:** Enterprise SSO for APIs. One user login, seamless access to multiple SaaS APIs (Salesforce, Workday, internal services). Also applicable to AI agents calling external tool APIs on behalf of users.

**Tradeoffs:** WG draft, active development. Requires existing SSO trust relationship between IdP and Resource AS. IdP becomes broker for API access (central point). Resource AS retains final authorization decision.

**Link:** [Draft](https://datatracker.ietf.org/doc/draft-ietf-oauth-identity-assertion-authz-grant/03/)
