# Macaroon Access Tokens

## Transactional Authorization with Macaroons

**Problem:** OAuth's conflicting goals: convenience (long-lived access) vs security (high-value transactions need approval). Short-lived tokens annoy users. Broad scopes are dangerous. RAR requires knowing transaction details upfront.

**Mechanism:** Bearer tokens with attached restrictions (caveats). First-party caveats checked by resource server. Third-party caveats require proof from another service (discharge macaroon). For transactions: user authorizes app with macaroon containing third-party caveat. Routine operations work normally. High-value transactions require real-time discharge approval.

**Example:**

```bash
# User wants to transfer funds. App requests discharge macaroon.
curl -X POST https://auth.bank.example.com/transaction-auth \
  -H "Authorization: Bearer <macaroon>" \
  -d '{"transaction": {"amount": "5000.00", "currency": "EUR", "recipient_iban": "DE02...118603"}}'

# App executes with both macaroon and discharge
curl -X POST https://api.bank.example.com/payments \
  -H "Authorization: Bearer <macaroon>" \
  -H "X-Discharge-Macaroon: <discharge-macaroon>" \
  -d '{"amount": "5000.00", "currency": "EUR", "recipient_iban": "DE02...118603"}'
```

**Comparison:**

| Approach | Convenience | Security | Transaction Approval |
|----------|-------------|----------|---------------------|
| Long-lived broad tokens | Good | Poor | None |
| Short-lived tokens | Poor | Good | Re-auth each time |
| RAR (upfront) | Fair | Good | Must know details at auth time |
| Macaroons | Good | Good | Just-in-time approval |

**Tradeoffs:** Not standardized in OAuth. Complex implementation. Google uses internally. Good fit when transaction details are unknown at authorization time.

**When to use:** Banking apps with routine access + per-transaction approval. Any flow where authorization needs to be refined after initial grant.

**Link:** [Neil Madden: Macaroon Access Tokens Part 2](https://neilmadden.blog/2020/09/09/macaroon-access-tokens-for-oauth-part-2-transactional-auth/)
