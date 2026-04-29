# Subject Identifier Types

## RFC 9493

**Problem:** Different systems identify users differently (issuer+sub, email, phone, DID, opaque ID). When exchanging security events or correlating identities across systems, you need unambiguous format specification.

**Mechanism:** Defines eight standard formats:

1. **email** — `{"format": "email", "email": "user@example.com"}`
2. **phone_number** — `{"format": "phone_number", "phone_number": "+1-555-0123"}`
3. **account** — `{"format": "account", "uri": "acct:user@service.example.com"}`
4. **iss_sub** — `{"format": "iss_sub", "iss": "https://auth.example.com", "sub": "user-12345"}`
5. **opaque** — `{"format": "opaque", "id": "550e8400-e29b-41d4-a716-446655440000"}`
6. **did** — `{"format": "did", "url": "did:example:123456789abcdefghi"}`
7. **uri** — `{"format": "uri", "uri": "https://social.example.com/@username"}`
8. **aliases** — Multiple identifiers for same user (no nesting)

**Used in:** Security Event Tokens (SET), RISC events, token exchange, cross-system identity correlation.

**When to use:** Any cross-system identity work. Pick the format that matches how the target system identifies users.

**Link:** [RFC 9493](https://datatracker.ietf.org/doc/html/rfc9493)
