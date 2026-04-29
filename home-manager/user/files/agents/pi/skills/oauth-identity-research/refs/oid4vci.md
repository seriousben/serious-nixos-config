# OpenID for Verifiable Credential Issuance (OID4VCI)

## openid-4-verifiable-credential-issuance-1_0

**Problem:** No standard protocol for issuing verifiable credentials (digital IDs, diplomas, employee badges) to a holder's wallet. Each issuer invents their own API.

**Mechanism:** Extends OAuth 2.0 for credential issuance. Two main flows:

1. **Authorization Code Flow** — User authenticates at issuer, authorizes credential issuance, wallet receives credential.
2. **Pre-Authorized Code Flow** — Issuer generates a pre-authorized code (e.g., via QR code or email link). Wallet exchanges code for credential without additional authorization. Optionally requires a PIN.

Key endpoints:
- `credential_issuer` metadata at `/.well-known/openid-credential-issuer`
- `/credential` — Wallet POSTs proof of key possession, receives credential
- `/batch_credential` — Issue multiple credentials at once
- `/deferred_credential` — For credentials that take time to issue (background verification)
- `/notification` — Wallet notifies issuer about credential lifecycle events

Credential formats supported: JWT VC, SD-JWT VC, ISO mDL (mdoc), W3C Verifiable Credentials.

**When to use:** Government digital identity (mDL, national ID). Education (digital diplomas). Enterprise (employee badges, access credentials). Any system that issues machine-verifiable claims.

**Tradeoffs:** Final spec but ecosystem still maturing. Wallet interop is the hard part. Multiple credential formats to support. Adds complexity vs simple JWT-based claims in OIDC.

**Link:** [Spec](https://openid.net/specs/openid-4-verifiable-credential-issuance-1_0.html)
