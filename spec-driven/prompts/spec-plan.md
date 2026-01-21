# Spec Plan Agent

Analyze the codebase and create a comprehensive technical plan for implementing the feature.

## Arguments

- `[ID]` - Feature ID (optional if branch is associated)
- `[additional instructions]` - Extra context for research or planning

## Process

### Step 1: Resolve Feature

If ID provided (numeric or full like `002-add-2fa`):
- Use that feature directly

If no ID:
- Get current git branch
- Search `.specs/*/spec.md` for matching `branch:` in frontmatter
- If found, use that feature
- If not found:
  - If only one feature exists, use it
  - If multiple, list them and ask user to specify

### Step 2: Load Specification

Read `.specs/{ID}-{feature}/spec.md`

If file doesn't exist, inform user to run `@spec-init` first.

### Step 3: Check for Clarifications

Search for `[NEEDS CLARIFICATION]` in the spec.

If found:
- List the items needing clarification
- Suggest running `@spec-clarify` first
- Exit

### Step 4: Research External Information

Determine if web research is needed by checking:
1. User provided additional instructions
2. Spec mentions external technologies, libraries, APIs, services
3. Spec references standards or protocols that need verification

If research is needed:
- Check if `docs/research/{topic}.md` already exists
- If exists, use existing research
- If not, conduct web search and save to `docs/research/{topic}.md`

### Step 5: Explore Codebase

Analyze the codebase:
- Find similar existing features
- Identify architecture patterns and conventions
- Find relevant entry points and integration areas
- Identify testing patterns
- Check .kiro/steering/*.md for project guidelines
- Search for README.md files in related directories
- Look for architecture docs in docs/, .docs/, architecture/

### Step 6: Review Exploration

Consolidate Critical Files:
- **Reference Files**: Patterns to follow
- **Files to Modify**: Existing files that need changes
- **Files to Create**: New files to be added

### Step 7: Generate Plan

Create `.specs/{ID}-{feature}/plan.md` with:

```markdown
# Technical Plan: {feature_name}

## Context
- Feature: {ID}-{feature}
- Created: {date}
- Spec: .specs/{ID}-{feature}/spec.md

## Research Summary
> From [docs/research/{topic}.md]

Key points:
- {key_point_1}
- {key_point_2}

## Documentation Context
> Sources reviewed: {list of docs}

Key insights:
- {insight}

## Critical Files

### Reference Files
| File | Purpose |
|------|--------|
| {path} | {why this file is a pattern to follow} |

### Files to Modify
| File | Reason |
|------|--------|
| {path} | {what changes are needed} |

### Files to Create
| File | Purpose |
|------|--------|
| {path} | {responsibility} |

## Codebase Patterns
{patterns_from_research with file:line references}

## Architecture Decision
{chosen_approach_with_rationale}

## Component Design
| Component | File | Responsibility |
|-----------|------|---------------|

## Implementation Map
{specific files to create/modify}

## Data Flow
{flow from entry points to outputs}

## Requirements Traceability
| Requirement | Component | Files | Notes |
|-------------|-----------|-------|-------|
| FR-001 | {component} | {paths} | {note} |

## Considerations
- Error Handling: {approach}
- Testing: {strategy}
- Security: {concerns}
```

### Step 8: Update Status

Update spec.md frontmatter: `status: ready`

### Step 9: Report

Inform the user:
- Research conducted (if applicable)
- Plan created at `.specs/{ID}-{feature}/plan.md`
- Key architectural decisions
- Next step: `@spec-tasks`