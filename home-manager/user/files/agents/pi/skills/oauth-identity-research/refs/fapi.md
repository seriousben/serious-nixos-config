# FAPI 2.0 Security Profile

## openid-fapi-2_0-security-profile-03

Note: Spec has been renamed to "FAPI Security Profile 2.0".

**Problem:** Standard OAuth is for typical web apps. Banks, healthcare, and government need higher security guarantees. Stolen tokens mean money loss. Need audit trails. Only certified apps should access data.

**Key requirements:**

- **Confidential clients only** — No public clients (mobile, SPA).
- **Strong client auth** — Only `private_key_jwt` or mTLS. No client secrets.
- **Pushed Authorization Requests (PAR)** — Auth parameters sent server-to-server. Client redirects with just `request_uri`. Prevents request tampering.
- **Sender-constrained tokens** — All access tokens must use mTLS or DPoP.
- **Short lifetimes** — Auth codes max 60 seconds. Access tokens short-lived.
- **Strong crypto** — PS256, ES256, or EdDSA only. Min 2048-bit RSA, P-256 curve.
- **Network security** — TLS 1.2+, DNSSEC and CAA recommended.

**Forbidden:** Implicit grant, resource owner password credentials, bearer tokens.

**When to use:** Banking, healthcare, government APIs. Any context where token theft has direct financial or safety consequences.

**Tradeoffs:** Significant implementation complexity. Requires all parties to support strong auth methods. Overkill for typical web apps.

**Link:** [Spec](https://openid.net/specs/fapi-2_0-security-profile-03.html)
