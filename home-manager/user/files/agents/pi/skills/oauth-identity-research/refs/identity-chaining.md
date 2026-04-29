# OAuth Identity and Authorization Chaining Across Domains

## draft-ietf-oauth-identity-chaining-10

**Problem:** Service A (Domain A) calls Service B (Domain B), which calls Service C (Domain C). Each domain has its own authorization server and user identifiers. Need to preserve identity and authorization context across trust domain boundaries.

**Mechanism:** Defines a common pattern combining RFC 8693 (Token Exchange) and RFC 7523 (JWT Bearer) to chain authorizations:

1. Client in trust domain A has an access token from its own auth server.
2. Exchanges token with its auth server for a JWT authorization grant targeting trust domain B.
3. Presents JWT grant to domain B's auth server using JWT bearer grant type, receives access token.
4. Repeat for each hop.

The JWT authorization grant can also be obtained through non-Token-Exchange means (proprietary APIs), but must be used as specified when requesting tokens from the downstream domain.

**Claims transcription** at domain boundaries:
- Map user IDs across systems (user 12345 → customer abc-xyz)
- Selective disclosure (don't reveal email to downstream service)
- Scope restriction (upstream authorized "payment:write", downstream gets "fraud-check:read")

**Relationship to ID-JAG:** Identity Chaining defines the general pattern. ID-JAG (`draft-ietf-oauth-identity-assertion-authz-grant`) builds on it with specific details for the SSO-trusted IdP case.

**When to use:** Multi-domain service chains. E-commerce → payment processor → fraud detection. Any scenario where user identity and authorization context must flow across organizational boundaries.

**Tradeoffs:** In IETF Last Call, submitted to IESG for publication as Proposed Standard (-10, April 2026). Each hop adds latency (token exchange). Trust relationships needed between authorization servers at each boundary.

**Link:** [Draft](https://datatracker.ietf.org/doc/draft-ietf-oauth-identity-chaining/10/)
