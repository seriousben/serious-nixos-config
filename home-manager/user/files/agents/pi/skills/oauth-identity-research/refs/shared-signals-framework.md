# Shared Signals Framework (SSF)

## openid-sharedsignals-framework-1_0 (Final)

**Problem:** Security events (credential compromise, session revocation, compliance changes) need to flow between providers in real time. Without a standard transport, every integration is custom.

**Mechanism:** Defines the plumbing for delivering Security Event Tokens (SETs) between a Transmitter and Receiver. Two delivery methods:

- **Push:** Transmitter POSTs SETs to Receiver's endpoint as they occur.
- **Poll:** Receiver GETs SETs from Transmitter's endpoint on a schedule.

Stream management API:
- Create/read/update/delete event streams
- Configure which event types to receive
- Add/remove subjects to monitor
- Verification endpoint to test connectivity

Subject identification uses RFC 9493 formats (email, iss_sub, opaque, etc.).

**Example:**
```bash
# Poll for events
curl -X POST https://transmitter.example.com/sse/poll \
  -H "Authorization: Bearer <token>" \
  -d '{"maxEvents": 10, "returnImmediately": true}'
# Response: {"sets": {"jti-1": "eyJhbGc...", "jti-2": "eyJhbGc..."}}

# Acknowledge processed events
curl -X POST https://transmitter.example.com/sse/poll \
  -H "Authorization: Bearer <token>" \
  -d '{"acks": ["jti-1", "jti-2"]}'
```

**When to use:** Implementing RISC or CAEP. Any cross-provider security event sharing. This is the transport layer; RISC and CAEP define the event types.

**Tradeoffs:** Final spec (mature). Push requires Receiver to expose an endpoint. Poll adds latency. Both Transmitter and Receiver must implement the stream management API.

**Contrast with RISC:** SSF is the transport. RISC defines the events (credential-compromise, account-disabled, etc.). CAEP defines continuous access events (session-revoked, compliance-change). All ride on SSF.

**Link:** [Spec](https://openid.net/specs/openid-sharedsignals-framework-1_0-final.html)
