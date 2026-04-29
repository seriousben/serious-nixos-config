# OpenID Federation

## openid-federation-1_0 (Final)

**Problem:** Bilateral trust setup (exchanging metadata, certificates, configuring each pair) doesn't scale. 100 RPs and 100 OPs means 10,000 bilateral configurations. Academic federations (eduGAIN), government identity schemes, and healthcare networks need automatic trust establishment.

**Mechanism:** Hierarchical trust via signed Entity Statements:

1. Each entity (OP, RP, Trust Anchor, Intermediate) publishes a self-signed Entity Configuration at `/.well-known/openid-federation`.
2. Trust Anchors and Intermediates publish Entity Statements about their subordinates (signed assertions: "I vouch for this entity with these metadata overrides").
3. To verify trust, build a chain from the entity up to a Trust Anchor. Each statement in the chain is signed by the issuer.
4. Metadata policies at each level can constrain what subordinates can claim (e.g., Trust Anchor requires all RPs to use PKCE).

Key concepts:
- **Entity Configuration** — Self-signed, published by the entity itself
- **Entity Statement** — Signed by a superior about a subordinate
- **Trust Chain** — Sequence from entity to Trust Anchor
- **Metadata Policy** — Constraints that accumulate up the chain
- **Trust Marks** — Signed assertions of compliance ("this entity passed certification")
- **Automatic Registration** — OP trusts RP based on trust chain, no bilateral setup

**When to use:** Large-scale federations (academic, government, healthcare). Any ecosystem where bilateral trust agreements are impractical. National digital identity schemes.

**Tradeoffs:** Final spec but complex to implement. Requires trust infrastructure (Trust Anchors, Intermediates). Overkill for simple bilateral integrations. Adoption growing in EU (eIDAS 2.0) and academic sector.

**Link:** [Spec](https://openid.net/specs/openid-federation-1_0-final.html)
