# git-helpers

Git workflow helper agents for Kiro CLI.

## Workflow

```
@git-review --> @git-commit --> @git-summary
```

## Agents

| Agent | Description |
|-------|-------------|
| `@git-commit` | Create commit with ticket ID from branch name |
| `@git-review` | Review changes with confidence scoring + test coverage |
| `@git-summary` | Generate MR description to file |

### @git-commit

Create commits with ticket ID extracted from branch name.

```
@git-commit              # Stage all files and commit
@git-commit -s           # Commit only staged files
```

**Branch pattern:** `{prefix}_{TICKET-ID}_{description}`

**Examples:**
| Branch | Commit Message |
|--------|----------------|
| `ab_XYZ-1234_fixSomething` | `[XYZ-1234] fix something` |
| `xy_ABC-567_addUserAuth` | `[ABC-567] add user auth` |
| `feature_PROJ-99_updateDocs` | `[PROJ-99] update docs` |
| `main` | `resolve issue` (no ticket) |

**Message format:** `[TICKET-ID] description` (single line, no body, no type prefix)

### @git-review

Review code changes for bugs, security issues, test coverage, and steering guidelines compliance.

```
@git-review              # Terminal output
@git-review main         # Compare against main
@git-review --save       # Save to CODE_REVIEW.md
```

**Review areas:**
1. Security vulnerabilities
2. Bugs and logic errors
3. Data loss risks
4. Performance issues
5. Unit test coverage
6. Steering guidelines compliance

### @git-summary

Generate MR title and description to `MR_DETAILS.md`.

```
@git-summary          # Auto-detect base branch
@git-summary main     # Use main as base
```

**Output format:**
```markdown
# [TRU-1234] brief description

## Summary
- User/product perspective (present tense: adds, fixes, improves)

## Changes
- developer/code perspective (past tense, lowercase)

## Notes (optional)
Extra context when needed

## Screenshots (optional)
| Before | After |
|--------|-------|
```

## Confidence Scoring

| Score | Meaning | Action |
|-------|---------|--------|
| >= 80 | High confidence | Report as issue |
| 50-79 | Medium confidence | Investigate more |
| < 50 | Low confidence | Do not report |

## Test Coverage Analysis

The `@git-review` agent checks:
- Missing tests for new functions/methods
- Broken tests from code changes
- Test quality issues
- Untested edge cases

Test file patterns:
- `*.test.ts`, `*.spec.ts`
- `__tests__/*.ts`
- `tests/*.py`, `test_*.py`
