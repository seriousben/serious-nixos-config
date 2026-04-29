# AuthZEN Authorization API

## authorization-api-1_0

**Problem:** Authorization logic is embedded in application code. Every app reimplements access control differently. No standard API to externalize authorization decisions.

**Mechanism:** Standardizes the interface between a Policy Enforcement Point (PEP, in the app) and a Policy Decision Point (PDP, the authorization service).

Single evaluation endpoint:
```
POST /access/v1/evaluation
```

Request contains:
- `subject` — Who is requesting (user ID, roles, attributes)
- `action` — What they want to do (`can_read`, `can_delete`, etc.)
- `resource` — What they want to act on (document ID, type, attributes)
- `context` — Additional context (IP, time, device)

Response: `{"decision": true}` or `{"decision": false}` with optional `context` (reason, obligations).

Also defines:
- Batch evaluation (`/access/v1/evaluations`) for multiple decisions in one call
- Resource search (`/access/v1/query`) — "what resources can this user access?"

**Example:**
```bash
curl -X POST https://pdp.example.com/access/v1/evaluation \
  -H "Content-Type: application/json" \
  -d '{
    "subject": {"type": "user", "id": "user-123"},
    "action": {"name": "can_read"},
    "resource": {"type": "document", "id": "doc-456"}
  }'
# Response: {"decision": true}
```

**When to use:** Externalizing authorization from application code. Multi-app environments needing consistent policy enforcement. Works with any policy engine (OPA, Cedar, OpenFGA) behind the standard API.

**Tradeoffs:** v1.0 spec (published 2024). API is simple but the hard part is the policy engine behind it. Adds network latency per authorization check (mitigate with caching or sidecar deployment). Doesn't define the policy language; that's the PDP's concern.

**Link:** [Spec](https://openid.net/specs/authorization-api-1_0-01.html)
