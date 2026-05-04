# OAuth SPIFFE Client Authentication

## draft-ietf-oauth-spiffe-client-auth-01

**Problem:** Workloads in Kubernetes, service meshes, and cloud-native environments have SPIFFE identities (X.509 SVIDs) but can't use them for OAuth client authentication. You end up managing separate client credentials (secrets, certificates) alongside the SPIFFE identity you already have.

**Mechanism:** Defines a new OAuth client authentication method: `spiffe_jwt_svid`. Client authenticates to the authorization server using a SPIFFE JWT-SVID (a JWT signed by the SPIFFE trust domain's issuing authority).

Flow:
1. Workload obtains JWT-SVID from its SPIFFE runtime (SPIRE agent).
2. Workload sends JWT-SVID as `client_assertion` to the AS token endpoint.
3. AS validates the SVID signature against the SPIFFE trust bundle for that trust domain.
4. AS maps the SPIFFE ID (`spiffe://trust-domain/workload-path`) to a registered client.

The SPIFFE ID URI becomes the client identity. No client secrets, no separate PKI.

**Example:**
```bash
curl -X POST https://as.example.com/token \
  -d "grant_type=client_credentials" \
  -d "client_assertion_type=urn:ietf:params:oauth:client-assertion-type:jwt-svid" \
  -d "client_assertion=<jwt-svid>"
```

**When to use:** Kubernetes/service mesh workloads that already have SPIFFE identities. Eliminates client secret management for machine-to-machine auth in cloud-native environments.

**Tradeoffs:** WG draft (rev 01, March 2026). Requires SPIFFE infrastructure (SPIRE or equivalent). AS must be configured to trust SPIFFE trust bundles. Limited to environments with SPIFFE deployment.

**Link:** [Draft](https://datatracker.ietf.org/doc/draft-ietf-oauth-spiffe-client-auth/01/)
