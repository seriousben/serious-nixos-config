# FastFed

## fastfed-core-1_0

**Problem:** Setting up federation between an IdP and a SaaS app is manual: exchange metadata URLs, configure SAML endpoints, set up SCIM provisioning, map attributes. Takes days per integration. IT admins do this hundreds of times.

**Mechanism:** Automated federation handshake:

1. Admin triggers setup from either IdP or app side.
2. Both parties publish FastFed metadata at `.well-known/fastfed-configuration`.
3. Handshake negotiates capabilities: which protocols (SAML, SCIM), which attributes, which provisioning features.
4. Registration endpoint exchanges configuration: IdP sends its SAML metadata, SCIM endpoint, signing keys. App sends its SAML consumer URL, required attributes.
5. Federation is live. No manual copy-paste of URLs or certificates.

Has profiles for SAML (`fastfed-saml-1_0`) and SCIM (`fastfed-scim-1_0`) provisioning.

**When to use:** SaaS vendors wanting zero-touch federation setup. Enterprise IdP vendors wanting to reduce support burden. IT automation for organizations onboarding many SaaS apps.

**Tradeoffs:** Requires both sides to implement FastFed. Adoption is early. Doesn't cover OIDC federation setup yet (SAML and SCIM only in current profiles). Reduces manual errors but adds protocol complexity.

**Link:** [Spec](https://openid.net/specs/fastfed-core-1_0-03.html)
