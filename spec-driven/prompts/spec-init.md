# Spec Init Agent

Initialize a new feature with comprehensive specification analysis and baseline discovery.

## Arguments

User may provide:

- `<description>` - Text describing the feature to implement
- `@<file.md>` - Path to PRD file to use as context
- `--link <ID>` - Associate current branch with existing feature

## Process

### Step 1: Handle --link Flag

If `--link <ID>` provided:

- Find feature with that ID in `.specs/`
- Get current git branch: `git branch --show-current`
- Update the feature's `spec.md` frontmatter with `branch: {current_branch}`
- Inform user and exit

### Step 2: Generate Feature ID

Scan `.specs/` directory for existing features:

- Find the highest ID number and increment by 1
- Example: If `.specs/003-payment-flow/` exists, next ID is `004`
- If `.specs/` doesn't exist, start with `001`

### Step 3: Detect Project Type (Greenfield vs Brownfield)

Analyze the user's description to determine implementation type:

**Brownfield indicators:**

- Keywords: "improve", "refactor", "fix", "optimize", "extend", "add to", "modify", "update", "enhance"
- References to existing features or components
- Mentions of current behavior or limitations

**Greenfield indicators:**

- Keywords: "create", "new", "implement from scratch", "build", "develop"
- No references to existing code
- Fresh feature descriptions

**Codebase analysis:**

- Search for related code using technical terms from description
- Use file patterns, function names, class names from description
- Check for existing similar features or components

**Decision Matrix:**
| Keywords | Code Found | Type | Action |
|----------|------------|------|--------|
| Greenfield | No | `greenfield` | Proceed |
| Greenfield | Yes | Ask user | Clarify intent |
| Brownfield | No | Ask user | Verify scope |
| Brownfield | Yes | `brownfield` | Proceed |
| Unclear | No | `greenfield` | Default |
| Unclear | Yes | Ask user | Get clarification |

### Step 4: Process Input Context

**If input is file reference (@file.md):**

- Read the file content as PRD context
- Extract requirements, user stories, acceptance criteria
- Use as foundation for specification

**If input is text description:**

- Use as feature description
- Extract key requirements and scope

**If input is empty:**

- Ask the user for a detailed feature description
- Guide them to provide scope and requirements

### Step 5: Baseline Discovery (Brownfield Only)

If type is `brownfield`, conduct comprehensive baseline analysis:

**Documentation Discovery:**

- Search for README.md files in related directories
- Look for architecture docs in `docs/`, `.docs/`, `architecture/`
- Find diagrams: mermaid blocks, `.dbml`, `.puml`, `.drawio` files
- Check existing specs in `.specs/` for related features
- Review `CLAUDE.md` for project conventions

**Code Discovery:**

- Find entry points (APIs, UI components, CLI commands)
- Locate core implementation files using technical terms
- Map feature boundaries and configuration
- Identify related test files and documentation

**Architecture Analysis:**

- Map abstraction layers (presentation → business logic → data)
- Identify design patterns and architectural decisions
- Document interfaces between components
- Note cross-cutting concerns (auth, logging, caching)

**Current Behavior Documentation:**

- Trace execution paths from entry to output
- Document data transformations and state changes
- Identify dependencies and integrations
- Note modification points and extension opportunities

### Step 6: Generate Feature Name

Derive a descriptive kebab-case name from the description:

- "Add two-factor authentication" → `add-2fa`
- "User registration flow improvements" → `user-registration-improvements`
- "Fix payment validation bugs" → `fix-payment-validation`
- "Implement dashboard analytics" → `dashboard-analytics`

### Step 7: Branch Association

```bash
git branch --show-current
```

Ask user if they want to associate feature with current branch:

- If yes: include branch name in frontmatter
- If no: leave branch field empty
- Explain they can link later with `@spec-init --link {ID}`

### Step 8: Generate Comprehensive Specification

Create `.specs/{ID}-{feature}/spec.md` with structured frontmatter:

```yaml
---
id: { ID }
feature: { feature-name }
type: { greenfield | brownfield }
status: draft
branch: { branch or empty }
created: { YYYY-MM-DD }
---
```

**Content for Greenfield:**

```markdown
# Feature: {Feature Title}

## Overview

{comprehensive_description_from_input}

## User Stories

- As a {user_type}, I want {goal} so that {benefit}
- As a {user_type}, I want {goal} so that {benefit}

## Functional Requirements

- [ ] FR-001: {specific_requirement}
- [ ] FR-002: {specific_requirement}

## Acceptance Criteria

- [ ] AC-001: {testable_criterion}
- [ ] AC-002: {testable_criterion}

## Technical Considerations

- {architecture_notes}
- {integration_points}
- {performance_requirements}

## Notes

{additional_context_and_assumptions}
```

**Content for Brownfield (includes Baseline):**

```markdown
# Feature: {Feature Title}

## Overview

{comprehensive_description_from_input}

## Baseline Analysis

### Current Implementation

**Entry Points:**

- {file_path} - {description}

**Core Files:**

- {file_path} - {responsibility}

**Current Behavior:**

- {existing_functionality_description}

**Modification Points:**

- {file_path}:{function} - {what_needs_changing}

### Architecture Context

- {existing_patterns_and_conventions}
- {integration_points_and_dependencies}

## User Stories

- As a {user_type}, I want {goal} so that {benefit}

## Functional Requirements

- [ ] FR-001: {specific_requirement}
- [ ] FR-002: {specific_requirement}

## Acceptance Criteria

- [ ] AC-001: {testable_criterion}
- [ ] AC-002: {testable_criterion}

## Technical Considerations

- {architecture_notes}
- {integration_points}
- {performance_requirements}

## Notes

{additional_context_and_assumptions}
```

### Step 9: Mark Ambiguities and Research Needs

For unclear or complex items, add appropriate markers:

- `[NEEDS CLARIFICATION: specific question about requirements]`
- `[RESEARCH NEEDED: technology or pattern to investigate]`
- `[DECISION REQUIRED: architectural choice to be made]`

### Step 10: Report and Next Steps

Inform the user:

- **Feature created**: `{ID}-{feature}`
- **Type**: `{greenfield | brownfield}`
- **Spec file location**: `.specs/{ID}-{feature}/spec.md`
- **Branch associated**: `{branch}` or "none"
- **Items needing attention**:
  - X clarifications needed
  - Y research topics identified
  - Z decisions required

**Recommended next steps:**

- If clarifications needed: `@spec-clarify`
- If research needed: External research on identified topics
- If ready: `@spec-plan`

## Quality Guidelines

**Specification Quality:**

- Requirements should be specific and testable
- User stories should follow standard format
- Acceptance criteria should be measurable
- Technical considerations should be actionable

**Baseline Analysis Quality (Brownfield):**

- Include file paths with line numbers when relevant
- Document actual behavior, not assumptions
- Identify specific modification points
- Map dependencies and integration points

**Research Integration:**

- Incorporate findings from documentation discovery
- Reference architectural patterns found in codebase
- Note constraints from existing implementations
- Highlight opportunities for improvement
