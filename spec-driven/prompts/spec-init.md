# Spec Init Agent

Initialize a new feature with a structured specification file.

## Arguments

User may provide:
- `<description>` - Text describing the feature
- `@<file.md>` - Path to PRD file to use as context
- `--link <ID>` - Associate current branch with existing feature

## Process

### Step 1: Handle --link Flag

If `--link <ID>` provided:
- Find feature with that ID in `.specs/`
- Get current git branch
- Update the feature's `spec.md` frontmatter with `branch: {current_branch}`
- Inform user and exit

### Step 2: Generate Feature ID

Scan `.specs/` directory for existing features.
Find the highest ID number and increment by 1.

Example: If `.specs/003-payment-flow/` exists, next ID is `004`.

If `.specs/` doesn't exist, start with `001`.

### Step 3: Detect Greenfield vs Brownfield

Analyze the user's description to determine type:

**Brownfield keywords:**
- "improve", "refactor", "fix", "optimize", "extend", "add to", "modify", "update"

**Greenfield keywords:**
- "create", "new", "implement from scratch"

Search codebase for related code using technical terms from description.

**Decision Matrix:**
| Keywords | Code Found | Type |
|----------|------------|------|
| Greenfield | No | `greenfield` |
| Greenfield | Yes | Ask user |
| Brownfield | No | Ask user |
| Brownfield | Yes | `brownfield` |
| Unclear | No | `greenfield` |
| Unclear | Yes | Ask user |

### Step 4: Process Input

If input is a file reference (@file.md):
- Read the file content as PRD context

If input is text:
- Use as feature description

If input is empty:
- Ask the user for a feature description

### Step 5: Baseline Discovery (if brownfield)

If type is `brownfield`:
- Find related files using technical terms
- Read main files (up to 5 most relevant)
- Document baseline: files, current behavior, modification points

### Step 6: Generate Feature Name

Derive a short kebab-case name:
- "Add two-factor authentication" -> `add-2fa`
- "User registration flow" -> `user-registration`

### Step 7: Check Branch Association

```bash
git branch --show-current
```

Ask user if they want to associate feature with current branch.

### Step 8: Generate Specification

Create `.specs/{ID}-{feature}/spec.md` with frontmatter:

```yaml
---
id: {ID}
feature: {feature-name}
type: {greenfield | brownfield}
status: draft
branch: {branch or empty}
created: {YYYY-MM-DD}
---
```

**Content for greenfield:**
```markdown
# Feature: {Feature Title}

## Overview
{brief_description}

## User Stories
- As a {user_type}, I want {goal} so that {benefit}

## Functional Requirements
- [ ] FR-001: {requirement}
- [ ] FR-002: {requirement}

## Acceptance Criteria
- [ ] AC-001: {criterion}
- [ ] AC-002: {criterion}

## Notes
{additional_context}
```

**Content for brownfield (includes Baseline section):**
Add Baseline section with related files, current behavior, and modification points.

### Step 9: Mark Ambiguities

For unclear items, add: `[NEEDS CLARIFICATION: specific question]`

### Step 10: Report

Inform the user:
- Feature created: `{ID}-{feature}`
- Type: `{greenfield | brownfield}`
- Spec file location
- Branch associated (or "none")
- Number of items needing clarification
- Next step: `@spec-clarify` or `@spec-plan`
