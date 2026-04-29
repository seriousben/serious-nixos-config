# Task-Based Authorization Control for AI Agents

## Delegated Authorization for LLM Agents (Research)

**Problem:** AI agents get broad OAuth scopes upfront. Agent's task is "schedule a meeting" but it holds `calendar:write payment:execute email:send`. If compromised, excessive permissions are exploitable. Traditional scopes are static, chosen at authorization time, with no semantic understanding of what the task actually requires.

**Mechanism:** Agent sends task description + requested scopes to authorization server. Server uses semantic analysis (LLM-based) to match task requirements to minimal scopes. Grants only what the task needs, denies the rest.

**Example:**

```json
// Agent request
{
  "task": "Book restaurant reservation for dinner tomorrow and add to calendar",
  "requested_scopes": ["calendar:write", "restaurant_api:booking", "email:send", "payment:execute"]
}

// Server response (after semantic matching)
{
  "granted_scopes": ["calendar:write", "restaurant_api:booking"],
  "denied_scopes": ["email:send", "payment:execute"],
  "reason": "Task does not require email or payment capabilities"
}
```

**Comparison:**

| Approach | Granularity | Dynamic | Semantic Understanding |
|----------|-------------|---------|----------------------|
| Traditional Scopes | Coarse | No | None |
| RAR | Fine | No | None |
| Cedar Policies | Fine | No | None |
| Macaroons | Transaction | Yes | None |
| TBAC | Task-specific | Yes | Yes |

**Findings:** Works well for simple, clear tasks. Struggles with complex multi-step tasks and ambiguous descriptions.

**Challenges:** Agents can lie about tasks (mitigate with audit trails). Vague descriptions produce poor matching. Semantic matching adds latency. LLM misinterpretation risk (use conservative deny-when-uncertain).

**Tradeoffs:** Research paper, not a standard. Depends on LLM quality. Adds latency. But points at the next evolution: identity-based → capability-based → intent-based authorization.

**Contrast with AAuth:** TBAC retrofits OAuth with semantic scope filtering. AAuth replaces the protocol entirely with mission-based governance where the agent declares intent and the person server evaluates it.

**Link:** [Paper](https://arxiv.org/abs/2510.26702v1)
