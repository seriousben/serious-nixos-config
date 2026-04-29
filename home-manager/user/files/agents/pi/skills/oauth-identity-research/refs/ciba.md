# Client-Initiated Backchannel Authentication (CIBA)

## openid-client-initiated-backchannel-authentication-core-1_0

**Problem:** Standard OIDC requires a browser redirect. Doesn't work when the device initiating auth isn't the device the user authenticates on. Examples: POS terminal, call center, IoT device, CLI tool.

**Mechanism:** Decoupled authentication. The client (consumption device) and the user's authentication device are separate.

1. Client sends backchannel authentication request to OP with a user hint (`login_hint`, `login_hint_token`, or `id_token_hint`) and optionally a `binding_message` (displayed on both devices for user to verify).
2. OP contacts the user on their authentication device (push notification, SMS, etc.).
3. User authenticates and consents on their device.
4. Client gets tokens via one of three modes:
   - **Poll** — Client polls the token endpoint until auth completes
   - **Ping** — OP notifies client's callback URL, client then fetches tokens
   - **Push** — OP pushes tokens directly to client's callback URL

**Example:**
```bash
# Step 1: Client initiates backchannel auth
curl -X POST https://op.example.com/bc-authorize \
  -u "client_id:client_secret" \
  -d "scope=openid" \
  -d "login_hint=user@example.com" \
  -d "binding_message=VERIFY-42"
# Response: {"auth_req_id": "abc123", "expires_in": 300, "interval": 5}

# Step 2: Poll for completion
curl -X POST https://op.example.com/token \
  -u "client_id:client_secret" \
  -d "grant_type=urn:openid:params:grant-type:ciba" \
  -d "auth_req_id=abc123"
# Initially: {"error": "authorization_pending"}
# After user approves: {"access_token": "...", "id_token": "..."}
```

**When to use:** POS/payment terminals (SCA for PSD2). Call centers authenticating callers. Smart TV login. CLI tools. Any scenario where the auth-initiating device has no browser or the user authenticates on a separate device.

**Tradeoffs:** Requires OP to have a way to reach the user (push notification infrastructure). Confidential clients only. More complex than standard OIDC. Binding message is critical for preventing confused deputy attacks.

**Provider support:** Okta, Ping Identity, Authlete. Used in Open Banking (UK, Brazil) for SCA.

**Link:** [Spec](https://openid.net/specs/openid-client-initiated-backchannel-authentication-core-1_0.html)
