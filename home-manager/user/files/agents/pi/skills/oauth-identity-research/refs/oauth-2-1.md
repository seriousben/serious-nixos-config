# OAuth 2.1

## draft-ietf-oauth-v2-1-15

**Problem:** OAuth 2.0 (RFC 6749) is from 2012. Security best practices, mandatory extensions, and deprecated grants are scattered across a dozen RFCs and BCPs. Implementers must read RFC 6749 + RFC 7636 (PKCE) + RFC 9700 (Security BCP) + deprecation notices to know what's current.

**Mechanism:** Consolidates OAuth 2.0 with all mandatory security fixes into one document:

- PKCE required for all authorization code grants (public and confidential clients)
- Implicit grant removed entirely
- Resource owner password credentials grant removed
- Bearer tokens in query parameters prohibited
- Exact redirect URI matching required (no pattern matching)
- Refresh token rotation or sender-constraining recommended
- Authorization code injection protection via PKCE

No new features. This is OAuth 2.0 as it should be implemented today, in one place.

**When to use:** Any new OAuth implementation. This is the baseline. If starting from scratch, read this instead of RFC 6749.

**Tradeoffs:** Still a draft (rev 15, March 2026) but expected to become an RFC. Content is already the de facto standard via RFC 9700. Existing OAuth 2.0 deployments don't need to migrate; they just need to follow the security BCP.

**Link:** [Draft](https://datatracker.ietf.org/doc/draft-ietf-oauth-v2-1/15/)
