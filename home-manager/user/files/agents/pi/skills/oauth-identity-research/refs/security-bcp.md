# OAuth 2.0 Security Best Current Practice

## RFC 9700

**Problem:** OAuth 2.0 (2012) predates a decade of production incidents and security research. RFC 9700 consolidates all lessons learned.

**Key requirements:**

- **PKCE mandatory** — Required for public clients, recommended for confidential. Prevents authorization code interception.
- **Exact redirect URI matching** — No pattern matching. `https://app.example.com/callback` must match exactly.
- **Sender-constrained tokens** — mTLS or DPoP. Prevents stolen token reuse.
- **Deprecated grants** — Implicit grant removed (tokens in URLs). Resource owner password credentials removed (password anti-patterns).
- **Mix-up attack mitigation** — Client validates authorization server matches expected server.
- **Short-lived codes** — 60 seconds recommended for authorization codes.
- **No tokens in query parameters** — Prevents credential leakage via logs and referrer headers.

**Mental model:** This is "OAuth 2.0 in 2025." If starting today, implement this. It incorporates all known security fixes.

**When to use:** Always. This is the baseline for any new OAuth implementation.

**Link:** [RFC 9700](https://www.rfc-editor.org/rfc/rfc9700.html)
