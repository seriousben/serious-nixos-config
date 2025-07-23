# agents.md

This document outlines my expectations and philosophy when working with AI agents on software engineering tasks. These guidelines are rooted in managing complexity - the fundamental challenge in software design.

## Core Principles

### 1. Complexity is the Enemy

> "Complexity is anything related to the structure of a software system that makes it hard to understand and modify the system." - John Ousterhout

**For agents, this means:**
- Never introduce unnecessary complexity 
- Always favor simplicity over cleverness
- Reject solutions that make the codebase harder to understand
- Question every abstraction and dependency you introduce

### 2. Preserve Intent and Meaning

**Absolute requirements:**
- **NEVER change the meaning of existing code** without explicit discussion
- Maintain the original author's intent unless there's a compelling reason to change it
- When modifying code, preserve the core logic and behavior patterns
- Ask questions rather than making assumptions about intended behavior

### 3. Complete Your Reversions

**Critical rule:**
- If we decide to discard an approach, **fully revert all related changes**
- Do not leave half-implemented features or partial reversions
- Clean up all traces of abandoned approaches (imports, variables, methods, etc.)
- A partial reversion that adds complexity is worse than the original problem

## Design Philosophy

### Deep Modules Over Shallow Ones

Following Ousterhout's principle of "deep modules":
- Create modules with **simple interfaces** but powerful implementations
- Hide complexity behind clean, obvious APIs
- Prefer fewer, more capable methods over many small, shallow ones
- Each module should encapsulate significant functionality

### Information Hiding

- Encapsulate design decisions within modules
- Minimize dependencies between components
- Make interfaces obvious and self-documenting
- Avoid information leakage across module boundaries

### Strategic vs Tactical Programming

**Always think strategically:**
- Working code is not enough - the design must be maintainable
- Invest time in making code obvious and easy to modify
- Consider the long-term impact of every change
- Refactor when complexity accumulates, don't just add more features

## Simplicity Guidelines

### Prefer Obvious Over Clever

- Write code that is immediately understandable
- Choose clarity over conciseness when they conflict
- Use straightforward approaches over "smart" or complex solutions
- **Simple, verbose code is better than complex, concise code**

### Naming and Consistency

- Use consistent naming patterns throughout the codebase
- Choose names that explain what something does, not how it works
- Maintain existing naming conventions in the codebase
- Simple names usually indicate simple functionality

### Method and Module Design

- Methods should do "one thing and do it completely"
- Long methods are acceptable if they have simple interfaces and clear flow
- Avoid conjoined methods that require jumping between many small functions
- Join modules with strong affinity, split those with weak affinity

## Agent Behavioral Expectations

### When Making Changes

1. **Understand first** - Read and comprehend the existing code before modifying
2. **Preserve patterns** - Follow established patterns in the codebase
3. **Ask before major changes** - Discuss significant architectural decisions
4. **Test your understanding** - Verify your changes don't break existing functionality

### When Suggesting Improvements

1. **Identify specific complexity** - Point out exact areas where complexity can be reduced
2. **Propose concrete solutions** - Don't just identify problems, suggest fixes
3. **Consider the whole system** - Think about how changes affect other components
4. **Respect existing decisions** - Understand why code was written a certain way

### When Reverting or Changing Direction

1. **Complete the reversion** - Remove all traces of the abandoned approach
2. **Clean up dependencies** - Update imports, remove unused variables/methods
3. **Restore original state** - Return to a clean baseline before trying new approaches
4. **Communicate the change** - Explain what was reverted and why

## Error Handling Philosophy

Follow Ousterhout's principle of "defining errors out of existence":
- Design systems to prevent errors rather than just handling them
- Use general-purpose approaches that handle edge cases naturally
- Avoid excessive exception throwing that creates shallow interfaces
- Handle special cases internally rather than exposing them

## Comments and Documentation

- Write comments that explain **why**, not what
- Comments should describe non-obvious design decisions
- Good code is self-documenting, but complex business logic needs explanation
- Update comments when changing the underlying code

## Forbidden Practices

### Never Do These:

1. **Change code meaning without discussion** - This breaks trust and understanding
2. **Leave partial reversions** - Always complete what you start
3. **Add complexity for minor gains** - The cure should not be worse than the disease
4. **Ignore existing patterns** - Consistency reduces cognitive load
5. **Make assumptions about requirements** - Ask questions when uncertain

### Red Flags to Avoid:

- Introducing unnecessary layers of abstraction
- Creating shallow modules with complex interfaces
- Adding configuration parameters to avoid making design decisions
- Breaking up cohesive functionality into many small pieces
- Duplicating logic across multiple modules

## Success Criteria

You're doing well when:
- The codebase becomes easier to understand after your changes
- New functionality integrates seamlessly with existing patterns
- Other developers can easily follow and extend your work
- The system requires fewer mental models to comprehend
- Changes are localized and don't create ripple effects

## When in Doubt

1. **Choose the simpler approach** - Complexity is easier to add than remove
2. **Ask questions** - Better to clarify than assume
3. **Follow existing patterns** - Consistency trumps personal preference
4. **Think like a maintainer** - Will this be easy to debug in 6 months?

---

*"The greatest limitation in writing software is our ability to understand the systems we are creating."* - John Ousterhout

Remember: Beautiful code is not just code that works - it's code that can be easily understood, modified, and extended by any competent engineer who encounters it.