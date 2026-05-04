# OAuth Actor Profile for Delegation

## draft-mcguinness-oauth-actor-profile-00

**Problem:** In delegation chains (RFC 8693 `act` claim), the acting entity is identified but not classified. Resource server sees an actor `sub` but doesn't know if it's a user, service, or AI agent. Can't apply entity-type-aware policy to actors in delegation.

**Mechanism:** Defines `actor_profile` as a claim within the `act` claim of a JWT. Uses the same Entity Profile vocabulary (user, service, ai_agent, device, etc.) from the Entity Profiles spec (draft-mora-oauth-entity-profiles).

The `actor_profile` classifies each actor in the delegation chain, enabling resource servers to make policy decisions based on who is acting on behalf of whom.

**Example:**
```json
{
  "sub": "user-123",
  "sub_profile": "user",
  "act": {
    "sub": "agent-xyz",
    "actor_profile": "ai_agent",
    "act": {
      "sub": "tool-service-1",
      "actor_profile": "service"
    }
  }
}
```

Resource server sees: user delegated to an AI agent, which delegated to a service. Can enforce policy at each level.

**When to use:** Multi-hop delegation chains where actors are heterogeneous (mix of users, agents, services). Complements Entity Profiles for the delegation context.

**Tradeoffs:** Individual draft (rev 00, April 2026). Very early. Depends on Entity Profiles vocabulary. Author: Karl McGuinness.

**Contrast with Entity Profiles:** Entity Profiles defines `client_profile` and `sub_profile` for the top-level token. Actor Profile extends the same vocabulary into the `act` claim for delegation chains.

**Link:** [Draft](https://datatracker.ietf.org/doc/draft-mcguinness-oauth-actor-profile/00/)
