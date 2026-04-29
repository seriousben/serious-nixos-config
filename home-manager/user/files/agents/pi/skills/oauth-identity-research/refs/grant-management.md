# OAuth 2.0 Grant Management

## fapi-grant-management (Draft)

**Problem:** User authorizes an app, forgets about it, can't see or revoke what they authorized. No standard way for users or apps to query existing grants or revoke them.

**Mechanism:** Adds grant management to OAuth:

- Token response includes a `grant_id` identifying the authorization grant.
- `grant_management_actions_supported` — OP advertises `create`, `replace`, `merge` actions.
- Client can request: `grant_management_action=create` (new grant), `replace` (replace existing), `merge` (add scopes to existing).

Grant query endpoint:
```
GET /grants/{grant_id}
```
Returns the current state of the grant: scopes, claims, RAR authorization details.

Grant revocation:
```
DELETE /grants/{grant_id}
```
Revokes the entire grant and all associated tokens.

**Example:**
```bash
# Query an existing grant
curl https://op.example.com/grants/grant-abc-123 \
  -H "Authorization: Bearer <access_token>"
# Response: {"scopes": ["openid", "payments"], "claims": {"userinfo": {...}}}

# Revoke a grant
curl -X DELETE https://op.example.com/grants/grant-abc-123 \
  -H "Authorization: Bearer <access_token>"
```

**When to use:** Open Banking (PSD2 requires grant visibility). Any consent-heavy application where users need to manage their authorizations. Apps that incrementally request permissions.

**Tradeoffs:** Draft status (developed under FAPI WG). Not widely implemented outside financial APIs. Adds state management complexity at the OP. The `merge` action is powerful but can lead to scope creep if not carefully managed.

**Link:** [Spec](https://openid.net/specs/fapi-grant-management.html)
