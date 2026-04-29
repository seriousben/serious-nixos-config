# Rich Authorization Requests

## RFC 9396: OAuth 2.0 RAR

**Problem:** Scopes are coarse-grained strings. Can't express "Transfer €45 to Merchant A" or "Read /Documents, write only /Documents/Uploads."

**Mechanism:** `authorization_details` parameter with structured JSON. Required `type` field identifies authorization kind. Optional `actions`, `locations`, and resource identifiers specify exact permissions.

**Example:**

```json
[{
  "type": "payment_initiation",
  "actions": ["initiate"],
  "instructedAmount": {"currency": "EUR", "amount": "45.00"},
  "creditorName": "Merchant A",
  "creditorAccount": {"iban": "DE02..."}
}]
```

Authorization server shows exact details to user. Token includes authorized details. Resource server validates.

**When to use:** Payment initiation (PSD2, Open Banking), file-level access control, any scenario where scopes are too coarse.

**Provider support:** Auth0 (Highly Regulated Identity), common in Open Banking.

**Link:** [RFC 9396](https://www.rfc-editor.org/rfc/rfc9396.html)
