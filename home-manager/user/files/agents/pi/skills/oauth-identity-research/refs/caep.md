# Continuous Access Evaluation Protocol (CAEP)

## openid-caep-1_0 (Final)

**Problem:** Access decisions are made once at login. User's risk profile changes mid-session (device compromised, location change, compliance violation), but the session continues uninterrupted.

**Mechanism:** Defines security event types for continuous evaluation, delivered via the Shared Signals Framework:

- `session-revoked` — Session terminated by OP/IdP. RP must end session immediately.
- `token-claims-change` — Token claims updated (e.g., group membership changed). RP should re-evaluate access.
- `credential-change` — User changed password or rotated credentials. RP may require re-auth.
- `assurance-level-change` — Authentication assurance level changed (e.g., MFA removed).
- `device-compliance-change` — Device fell out of compliance (MDM policy violation).
- `ip-address-change` — User's IP changed significantly. May indicate session hijacking.

Each event includes the subject identifier, event-specific claims, and optionally a `reason_admin` and `reason_user` for audit/display.

**Example:**
```json
{
  "iss": "https://idp.example.com",
  "jti": "event-123",
  "iat": 1735689600,
  "aud": "https://app.example.com",
  "events": {
    "https://schemas.openid.net/secevent/caep/event-type/session-revoked": {
      "subject": {
        "format": "iss_sub",
        "iss": "https://idp.example.com",
        "sub": "user-12345"
      },
      "reason_admin": "Policy violation detected",
      "event_timestamp": 1735689500
    }
  }
}
```

**When to use:** Zero-trust architectures. Any system where session validity should be continuously re-evaluated based on external signals. Financial services, healthcare, government.

**Tradeoffs:** Final spec. Requires SSF infrastructure (Transmitter + Receiver). RP must handle mid-session revocation (UX challenge: what do you show the user?). Provider support: Microsoft Entra (Continuous Access Evaluation), Okta (limited), Google.

**Contrast with RISC:** RISC covers account-level incidents (credential compromise, account disabled). CAEP covers session-level and access-level changes (device compliance, IP change, session revocation). Both use SSF for transport.

**Link:** [Spec](https://openid.net/specs/openid-caep-1_0-final.html)
