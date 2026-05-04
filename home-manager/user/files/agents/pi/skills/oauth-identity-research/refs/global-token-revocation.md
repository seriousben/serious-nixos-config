# Global Token Revocation

## draft-parecki-oauth-global-token-revocation-06

**Problem:** RFC 7009 revokes individual tokens. When a user's account is compromised, you need to revoke all tokens for that user across all clients. No standard way to tell an AS "revoke everything for this user."

**Mechanism:** Defines a new endpoint at the authorization server for revoking all tokens associated with a subject.

The requesting party (typically an API or admin service) sends a subject identifier and the AS revokes all access tokens, refresh tokens, and authorization grants for that user.

Request uses the Subject Identifier format from RFC 9493 to identify the user.

**Example:**
```bash
curl -X POST https://as.example.com/global-token-revocation \
  -H "Authorization: Bearer <admin_token>" \
  -H "Content-Type: application/json" \
  -d '{
    "sub_id": {
      "format": "iss_sub",
      "iss": "https://as.example.com",
      "sub": "user-12345"
    }
  }'
```

**When to use:** Account compromise response. User-initiated "sign out everywhere." Compliance-driven access revocation (employee offboarding, GDPR right to erasure).

**Tradeoffs:** Individual draft (rev 06, February 2026). Requires AS to support bulk revocation. Caller needs admin-level authorization. Uses RFC 9493 subject identifiers. Author: Aaron Parecki.

**Link:** [Draft](https://datatracker.ietf.org/doc/draft-parecki-oauth-global-token-revocation/06/)
