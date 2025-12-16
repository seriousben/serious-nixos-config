# AGENTS.md

User-level agent instructions for software engineering workflows.

## Environment & Tools

**System:**
- Use GNU utilities (not BSD variants)
- GNU sed is available: `sed -i ///` syntax works for in-place editing
- `rg` (ripgrep) is available for searching
- Git is configured with GPG signing enabled
- NixOS/Nix environment management

## Code Quality Boundaries

**Non-Negotiable Rules:**
1. **Never change code meaning without explicit discussion** - Preserve original intent
2. **Always complete reversions fully** - Remove all traces of abandoned approaches
3. **Prefer simplicity over cleverness** - Choose obvious solutions
4. **Ask questions when uncertain** - Don't make assumptions about requirements

**Design Principles:**
- Favor deep modules with simple interfaces
- Avoid unnecessary abstraction layers
- Keep code obvious and self-documenting
- Think strategically about long-term maintainability

**Anti-Patterns to Avoid:**
- Shallow modules with complex interfaces
- Configuration parameters to avoid design decisions
- Breaking up cohesive functionality into many small pieces
- Adding complexity for minor gains

## Workflow Guidelines

**Making Changes:**
- Understand code before modifying
- Preserve established patterns
- Ask before major architectural decisions
- Verify changes don't break functionality

**Reverting:**
- Remove all traces of abandoned approaches
- Clean up imports, variables, methods

**Error Handling:**
- Design to prevent errors, not just handle them
- Avoid excessive exception throwing

**Comments:**
- Explain why, not what
- Document non-obvious decisions

## When in Doubt

- Choose the simpler approach
- Ask questions rather than assume
- Follow existing patterns
- Think like a maintainer
---

*"The greatest limitation in writing software is our ability to understand the systems we are creating."* - John Ousterhout

Remember: Beautiful code is not just code that works - it's code that can be easily understood, modified, and extended by any competent engineer who encounters it.
