# OpenID Connect Prompt Create

## openid-connect-prompt-create-1_0

**Problem:** OIDC has `prompt=login` (force re-auth) and `prompt=consent` (force consent), but no standard way to say "send the user to account creation instead of login." Apps that want a signup flow redirect to the OP's login page and hope the user finds the "create account" link.

**Mechanism:** Adds `prompt=create` as a new value for the `prompt` parameter in the authentication request. OP receives it and presents the account creation UX instead of login.

Can be combined with other prompt values: `prompt=login create` means "force interaction and prefer account creation."

If the OP doesn't support account creation or the user already has an account and chooses to log in instead, the OP proceeds normally.

**Example:**
```
https://op.example.com/authorize?
  response_type=code&
  client_id=app123&
  redirect_uri=https://app.example.com/callback&
  scope=openid%20profile%20email&
  prompt=create
```

**When to use:** Apps with explicit "Sign Up" buttons that use OIDC. Onboarding flows that should skip the login screen. Marketing landing pages with registration CTAs.

**Tradeoffs:** Simple to implement. OP support is growing: Google, Apple, Okta support it. If the OP doesn't support it, it returns `unmet_authentication_requirements` error or ignores it.

**Link:** [Spec](https://openid.net/specs/openid-connect-prompt-create-1_0.html)
