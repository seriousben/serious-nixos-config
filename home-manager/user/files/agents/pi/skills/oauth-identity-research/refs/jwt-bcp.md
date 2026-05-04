# JSON Web Token Best Current Practices

## draft-ietf-oauth-rfc8725bis-04

**Problem:** JWTs are easy to misuse. Common mistakes: accepting tokens without verifying signatures, using `"alg": "none"`, confusing encryption and signing, not validating `iss`/`aud`/`exp`, using JWTs when simpler formats would suffice.

**Mechanism:** Updates RFC 8725 with current best practices for JWT producers and consumers:

- Always verify signatures. Never accept `"alg": "none"` unless explicitly intended.
- Always validate `iss`, `aud`, `exp`, `nbf` claims.
- Use explicit typing (`typ` header) to prevent cross-JWT confusion (e.g., an ID token accepted as an access token).
- Prefer compact, unambiguous claim names.
- Use asymmetric signatures (RS256, ES256) over symmetric (HS256) in multi-party scenarios.
- Don't put sensitive data in JWT payloads unless encrypted (JWE).
- Keep JWTs short. Don't use them as general-purpose data containers.
- Consider opaque tokens when the consumer is the same as the issuer.

**When to use:** Always. Any system producing or consuming JWTs should follow this. Read before designing a JWT-based protocol.

**Tradeoffs:** WG draft (rev 04, March 2026). Updates RFC 8725 with lessons from the last several years. No breaking changes, purely additive guidance.

**Link:** [Draft](https://datatracker.ietf.org/doc/draft-ietf-oauth-rfc8725bis/04/)
