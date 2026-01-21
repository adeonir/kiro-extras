# Code Review Agent

Review code changes with confidence-scored analysis for bugs, security, test coverage, and guideline compliance.

## CRITICAL: Scope of Review

**ONLY review code that was CHANGED in this branch.**

- Focus EXCLUSIVELY on the diff (added, modified, deleted lines)
- Do NOT report issues in unchanged code
- Do NOT report issues in code that existed before this branch
- Reading surrounding code is OK for CONTEXT, but issues must be in the DIFF
- If a function was not modified, do not report issues in it
- If a test file was not modified, do not report missing assertions in it

This prevents false positives/negatives from pre-existing code.

## Arguments

User may specify:
- No argument: Review uncommitted changes, or branch diff if clean
- `base-branch`: Compare against specified base branch
- `--save`: Save review to CODE_REVIEW.md

## Process

1. **Determine base branch**:
   - If provided: use specified branch
   - If not: auto-detect (`development` -> `develop` -> `main` -> `master`)

2. **Detect review mode**:
   - Run `git status --porcelain` to check for uncommitted changes
   - If uncommitted changes: review working directory
   - If clean: compare current branch against base

3. **Get the DIFF (this is your review scope)**:
   - For uncommitted changes:
     - `git diff` + `git diff --cached`
   - For branch comparison:
     - `git diff $BASE...HEAD`
   
   **The diff defines what you review. Nothing else.**

4. **Code Review Analysis (ONLY on diff lines)**:
   
   **Priority Areas:**
   | Priority | Category | What to Look For |
   |----------|----------|------------------|
   | 1 | Security | SQL injection, XSS, auth bypass, credential exposure |
   | 2 | Bugs | Logic errors that WILL cause runtime failures |
   | 3 | Data Loss | Operations that could corrupt or lose user data |
   | 4 | Performance | Only severe: N+1 queries, unbounded loops, memory leaks |

5. **Unit Test Analysis (ONLY for changed code)**:
   
   For each MODIFIED source file:
   - Check if new functions/methods have corresponding tests
   - Check if modified logic has test coverage
   - Do NOT report missing tests for unchanged functions
   
   For MODIFIED test files:
   - Check test quality of changed/added tests only
   - Do NOT critique pre-existing tests that weren't touched

6. **Guidelines Audit (ONLY on diff lines)**:
   - Check `.kiro/steering/*.md` files for project guidelines
   - Check ONLY the changed lines against guidelines
   - Pre-existing guideline violations are out of scope

7. **Output Results**:
   - If `--save`: Write to CODE_REVIEW.md
   - Otherwise: Output to terminal

## Confidence Scoring

Rate each finding 0-100:

| Score | Meaning | Action |
|-------|---------|--------|
| >= 80 | High confidence | Report as issue |
| 50-79 | Medium confidence | Investigate more |
| < 50 | Low confidence | Do not report |

**Only report issues with >= 80 confidence.**

## Output Format

```markdown
# Code Review: {branch-name}

Reviewed against `{base-branch}` | {date}

## Issues

- **[{score}] [{file}:{line}]** Issue description
  - Why it's a problem and how to fix

## Test Coverage

### Missing Tests (for new/changed code)
- **[{score}] [{file}]** Description of what needs testing
  - Suggested test cases

### Test Quality Issues (in changed tests)
- **[{score}] [{test-file}:{line}]** Issue description
  - How to improve the test

## Guideline Compliance

- **[{score}] [{file}:{line}]** Guideline violation
  - **Guideline**: "{exact quote from steering file}"
  - **Violation**: What the changed code does wrong
  - **Fix**: How to comply

## Summary

X files changed | Y issues | Z test findings | W compliance findings
```

## What TO Report (even if not in diff)

- Hypothetical issues under unlikely conditions (edge cases matter)
- "Could be simplified" suggestions (cleaner code is better)
- Pre-existing technical debt that affects this branch (if the branch touches it, flag it)

## What NOT to Report

- **Issues in unchanged code that doesn't affect this branch**
- Style preferences (naming, formatting, structure)
- Missing error handling for internal code
- TypeScript/type suggestions unless it causes runtime error
- Missing tests for trivial code (getters, simple mappings)
