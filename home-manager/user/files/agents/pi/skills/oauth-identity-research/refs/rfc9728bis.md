# OAuth 2.0 Protected Resource Metadata Update

## draft-mcguinness-oauth-rfc9728bis-01

**Problem:** RFC 9728 defines Protected Resource Metadata but lacks clarity on resource identifier validation. When a resource server publishes metadata at `.well-known/oauth-resource-server`, clients and authorization servers need clear rules for validating the resource identifier against the metadata URL.

**Mechanism:** Updates RFC 9728 to clarify:

- The `resource` value in the metadata document must match the resource identifier used in token requests.
- Validation rules for the relationship between the metadata URL and the resource identifier.
- Handling of path-based resource identifiers vs origin-based identifiers.

**When to use:** Implementations of RFC 9728 (Protected Resource Metadata). Relevant when resource servers publish their own metadata for discovery.

**Tradeoffs:** Individual draft (rev 01, February 2026). Narrow scope, clarification only. Author: Karl McGuinness.

**Link:** [Draft](https://datatracker.ietf.org/doc/draft-mcguinness-oauth-rfc9728bis/01/)
