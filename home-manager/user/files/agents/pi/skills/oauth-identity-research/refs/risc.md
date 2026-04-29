# RISC (Risk Incident Sharing and Coordination)

## OpenID RISC Profile 1.0 (Final, August 2025)

**Problem:** User's password leaks at Site A. User reuses that password at Sites B, C, D. Site A detects compromise and forces reset. Sites B, C, D remain vulnerable. Attacker has days/weeks to exploit.

**Mechanism:** Sites share security events via signed JWTs (Security Event Tokens/SET) using Shared Signals and Events (SSE) Framework.

**Event types:** credential-compromise, credential-change, account-purged, account-disabled, account-enabled, identifier-changed, identifier-recycled, recovery-activated, recovery-information-changed, opt-out management.

**Example:**

```json
{
  "iss": "https://idp.example.com/",
  "events": {
    "https://schemas.openid.net/secevent/risc/event-type/credential-compromise": {
      "subject": {"format": "email", "email": "user@example.com"},
      "credential_type": "password"
    }
  }
}
```

**Receiver actions:** Force password reset, invalidate sessions, trigger MFA, notify user.

**When to use:** Any system that needs to react to credential compromise or account state changes from external identity providers.

**Provider support:** Google (Project Herald), Microsoft Entra, Okta (event hooks), Auth0.

**Link:** [Spec](https://openid.net/specs/openid-risc-1_0-final.html)
