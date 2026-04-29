# OpenID Connect Native SSO

## openid-connect-native-sso-1_0

**Problem:** User logs into App A on their phone. Opens App B on the same phone. App B forces another login because there's no shared browser session between native apps. Browser-based SSO doesn't work for native apps.

**Mechanism:** Introduces a `device_secret` bound to the device. Flow:

1. App A authenticates normally, requests `device_sso` scope.
2. OP returns ID token, refresh token, and `device_secret`.
3. App A stores `device_secret` in shared device storage (Keychain/Keystore).
4. App B reads `device_secret`, sends it with the ID token to the OP's token endpoint using token exchange (RFC 8693).
5. OP validates the device_secret + ID token, issues tokens for App B without user interaction.

The device_secret is rotated on each use. If the user logs out or the OP revokes the session, the device_secret becomes invalid for all apps.

**Example:**
```bash
# App B exchanges device_secret for its own tokens
curl -X POST https://op.example.com/token \
  -d "grant_type=urn:ietf:params:oauth:grant-type:token-exchange" \
  -d "subject_token=<id_token_from_app_a>" \
  -d "subject_token_type=urn:ietf:params:oauth:token-type:id_token" \
  -d "actor_token=<device_secret>" \
  -d "actor_token_type=urn:openid:params:oauth:token-type:device-secret" \
  -d "client_id=app_b_client_id" \
  -d "scope=openid profile"
```

**When to use:** Mobile app suites (e.g., Microsoft Office apps, Google Workspace apps) where multiple native apps from the same or trusted publishers need SSO on the same device.

**Tradeoffs:** Requires shared secure storage between apps (platform-specific). Device_secret rotation adds complexity. Provider support growing: Okta supports it, Microsoft has similar via broker.

**Link:** [Spec](https://openid.net/specs/openid-connect-native-sso-1_0.html)
