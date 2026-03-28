---
name: code-simplifier
description: |
  Simplify and refine code for clarity, consistency, and maintainability while
  preserving all functionality. Use after completing a coding task, before
  committing. Should auto-trigger when implementation is done and ready to
  commit. Focuses on recently modified code unless instructed otherwise.
disable-model-invocation: true
---

# Code Simplifier

Review recently modified code and simplify it without changing functionality.

## Principles

### Preserve Functionality

Never change what the code does, only how it does it. All original features, outputs, and behaviors must remain intact.

### Apply Project Standards

Before simplifying, check for project conventions:

- Read AGENTS.md or CLAUDE.md at the repo root for coding standards
- Match the existing style of the file being modified (naming, formatting, patterns)
- Follow established error handling patterns in the codebase
- Respect the project's abstraction level (don't flatten what the team intentionally layered)

### Enhance Clarity

- Reduce unnecessary complexity and nesting
- Eliminate redundant code and abstractions
- Use clearer variable and function names
- Consolidate related logic
- Remove unnecessary comments that describe obvious code
- Avoid nested ternary operators, prefer if/else or switch
- Choose clarity over brevity

### Maintain Balance

Do not over-simplify. Avoid:

- Overly clever solutions that are hard to understand
- Combining too many concerns into single functions
- Removing helpful abstractions that improve organization
- Prioritizing "fewer lines" over readability
- Making code harder to debug or extend

### Focus Scope

Only refine code that has been recently modified or touched in the current session, unless explicitly instructed to review a broader scope.

## Process

1. Get the diff: `git diff main` (or appropriate base branch)
2. For each changed file, analyze for simplification opportunities
3. Apply simplifications
4. Run tests to verify behavior is unchanged
5. Report a 1-3 sentence summary of what changed

## Examples

### Nested ternaries to clear conditionals

Before:
```
const status = isLoading ? 'loading' : hasError ? 'error' : isComplete ? 'complete' : 'idle';
```

After:
```
if (isLoading) return 'loading';
if (hasError) return 'error';
if (isComplete) return 'complete';
return 'idle';
```

### Overly compact chain to clear steps

Before:
```
const result = arr.filter(x => x > 0).map(x => x * 2).reduce((a, b) => a + b, 0);
```

After:
```
const positiveNumbers = arr.filter(x => x > 0);
const doubled = positiveNumbers.map(x => x * 2);
const sum = doubled.reduce((a, b) => a + b, 0);
```

### Redundant abstraction

Before:
```
function isNotEmpty(arr) {
  return arr.length > 0;
}
if (isNotEmpty(items)) { ... }
```

After:
```
if (items.length > 0) { ... }
```
