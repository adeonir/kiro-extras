# MR Details Agent

Generate a Merge Request title and description, save to `MR_DETAILS.md`.

## Arguments

User may specify:
- No argument: Auto-detect base branch (main > master > develop > development)
- `base-branch`: Use specified branch as base for comparison

## Process

1. **Gather context** (run in parallel):
   ```bash
   git branch --show-current
   git diff {base}...HEAD --stat
   git diff {base}...HEAD --name-status
   git log {base}..HEAD --oneline
   git diff {base}...HEAD
   ```

2. **Extract ticket from branch name**:
   
   Branch pattern: `{prefix}_{TICKET-ID}_{description}`
   
   Examples:
   - `ab_XYZ-1234_fixSomething` -> ticket: `XYZ-1234`
   - `xy_ABC-567_addNewFeature` -> ticket: `ABC-567`
   
   Extract the ticket ID (pattern: uppercase letters + hyphen + numbers).
   If no ticket found, proceed without ticket prefix.

3. **Analyze changes**:
   - Review commits and diff to understand what changed
   - Categorize changes from product perspective (what the user sees)
   - Categorize changes from developer perspective (what the code does)

4. **Generate MR_DETAILS.md**

## Output Format

```markdown
# [TICKET-ID] Brief description of what was done

## Summary

- What this MR does from user/product perspective (present tense)
- Adds/Fixes/Improves/Removes something
- Business value or behavior change

## Changes

- what changed in the code (developer perspective, lowercase)
- technical implementation details
- files/components affected

## Notes

> Only include this section if Summary is not sufficient or extra context is needed.

Additional explanations, caveats, or important information for reviewers.

## Screenshots

> Only include this section when there are visual changes.

| Before | After |
|--------|-------|
| ![before](url) | ![after](url) |
```

## Guidelines

### Title
- Format: `[TICKET-ID] brief description in lowercase`
- If no ticket: just `brief description in lowercase`
- Convert camelCase from branch to lowercase with spaces
- Examples:
  - Branch `ab_XYZ-1234_fixLoginButton` -> `[XYZ-1234] fix login button`
  - Branch `xy_ABC-567_addUserProfile` -> `[ABC-567] add user profile`

### Summary (Product View)
- Focus on WHAT this MR is doing (present tense)
- Use business language, not technical
- Answer: "What does this MR do for the user?"
- Use verbs like: adds, fixes, improves, removes, updates, allows
- Examples:
  - "Adds password reset via email"
  - "Fixes login button not responding on mobile"
  - "Improves loading performance on dashboard"
  - "Allows users to export data as CSV"

### Changes (Developer View)
- Focus on WHAT changed in the code
- Use technical language
- Start with lowercase, past tense (code was already changed)
- Answer: "What did we change in the codebase?"
- Examples:
  - "added password reset endpoint in AuthController"
  - "optimized database queries in UserRepository"
  - "fixed race condition in form submission handler"
  - "refactored LoginButton component for mobile support"

### Notes (Optional)
- Only include when extra context is needed
- Migration steps, breaking changes, dependencies
- Things reviewers should pay attention to
- Skip entirely if Summary covers everything

### Screenshots (Optional)
- Only include for visual/UI changes
- Before/After comparison when applicable
- Skip entirely if no visual changes

## Task

Generate MR details and save to `MR_DETAILS.md`.

After generating, show a brief summary of the title and key points.
