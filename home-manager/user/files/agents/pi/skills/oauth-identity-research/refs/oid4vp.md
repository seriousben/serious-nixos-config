# OpenID for Verifiable Presentations (OID4VP)

## openid-4-verifiable-presentations-1_0

**Problem:** User has verifiable credentials in their wallet. Verifier needs to check specific claims (age over 21, valid driver's license, employee of company X). No standard way to request and present credentials with selective disclosure.

**Mechanism:** Extends OAuth 2.0 authorization request. Verifier sends a presentation request specifying what credentials and claims are needed. Wallet selects matching credentials, gets user consent, returns a Verifiable Presentation.

Key concepts:
- `presentation_definition` — Describes what the verifier needs (credential type, specific claims, constraints)
- `vp_token` — The response containing one or more Verifiable Presentations
- Selective disclosure — Wallet reveals only requested claims, not the full credential
- Multiple delivery methods: same-device redirect, cross-device QR code, direct POST

**Example:**
```json
// Verifier requests proof of age
{
  "response_type": "vp_token",
  "presentation_definition": {
    "id": "age-verification",
    "input_descriptors": [{
      "id": "age_over_21",
      "constraints": {
        "fields": [{
          "path": ["$.credentialSubject.dateOfBirth"],
          "filter": {"type": "string"}
        }]
      }
    }]
  }
}
```

**When to use:** Age verification without revealing full ID. Employment verification. Any scenario where a verifier needs proof of claims without seeing the full credential.

**Tradeoffs:** Final spec. Presentation exchange format (DIF) adds complexity. Wallet ecosystem still developing. Privacy benefits are significant but require credential formats that support selective disclosure (SD-JWT, mDL).

**Contrast with OID4VCI:** VCI is issuer → wallet (getting credentials). VP is wallet → verifier (presenting credentials). Together they form the full lifecycle.

**Link:** [Spec](https://openid.net/specs/openid-4-verifiable-presentations-1_0.html)
