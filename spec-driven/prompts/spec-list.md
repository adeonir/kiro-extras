# Spec List Agent

List all features by status with comprehensive overview and filtering options.

## Arguments

- `[status]` - Filter by status: `draft`, `ready`, `in-progress`, `to-review`, `done`, `archived` (optional)
- `[--details]` - Show detailed information including task progress (optional)

## Process

### Step 1: Scan Features Directory

**Search for all features:**

- Scan `.specs/` directory for feature folders matching pattern `{ID}-{feature}/`
- Load `spec.md` frontmatter from each feature directory
- Handle missing directory: inform user no features found, suggest `@spec-init`

### Step 2: Load Feature Metadata

**For each feature found:**

- Extract from `spec.md` frontmatter:
  - `id`: Feature ID number
  - `feature`: Feature name (kebab-case)
  - `type`: greenfield or brownfield
  - `status`: Current workflow status
  - `branch`: Associated git branch (if any)
  - `created`: Creation date
  - `archived`: Archive date (if archived)

**Handle malformed features:**

- Skip features with missing or invalid frontmatter
- Report problematic feature directories
- Continue processing valid features

### Step 3: Apply Filters and Sort

**Status filtering:**

- If status argument provided: show only features matching that status
- If no status filter: show all features

**Sorting:**

- Primary: By status in workflow order (in-progress, to-review, ready, draft, done, archived)
- Secondary: By ID number (ascending)

### Step 4: Gather Additional Information

**For detailed view (`--details`):**

- Count FR-xxx requirements from spec.md
- Count AC-xxx acceptance criteria from spec.md
- Load task progress from tasks.md (if exists)
- Get current git branch for context

### Step 5: Display Results

**Standard format:**

```
# Features Overview

## Summary
Total: 5 | Active: 3 | Completed: 2

## By Status

### In Progress (1)
| ID | Feature | Branch | Created |
|----|---------|--------|---------|
| 003 | payment-flow | feat/payments | 2025-01-02 |

### To Review (1)
| ID | Feature | Branch | Created |
|----|---------|--------|---------|
| 002 | add-2fa | feat/add-2fa | 2025-01-01 |

### Ready (1)
| ID | Feature | Branch | Created |
|----|---------|--------|---------|
| 004 | dashboard | none | 2025-01-03 |

### Done (2)
| ID | Feature | Branch | Created |
|----|---------|--------|---------|
| 001 | user-auth | main | 2024-12-15 |
| 005 | logging | feat/logging | 2024-12-20 |

---
Total: 5 features | Current branch: feat/payments → 003-payment-flow
```

**Detailed format (`--details`):**

```
# Features Overview

## Summary
Total: 5 features | Active: 3 | Completed: 2
Current branch: feat/payments → 003-payment-flow

## By Status

### In Progress (1 feature)

#### 003-payment-flow: Payment Processing Integration
- **Type**: brownfield | **Created**: 2025-01-02
- **Branch**: feat/payments | **Requirements**: 6 FR, 8 AC
- **Progress**: 12/15 tasks completed (80%)
- **Next**: Continue implementation

### To Review (1 feature)

#### 002-add-2fa: Two-Factor Authentication
- **Type**: greenfield | **Created**: 2025-01-01
- **Branch**: feat/add-2fa | **Requirements**: 4 FR, 6 AC
- **Progress**: All tasks completed
- **Next**: Run @spec-validate

### Ready (1 feature)

#### 004-dashboard: Analytics Dashboard
- **Type**: greenfield | **Created**: 2025-01-03
- **Branch**: none | **Requirements**: 8 FR, 12 AC
- **Progress**: 18 tasks planned
- **Next**: Run @spec-implement

### Done (2 features)

#### 001-user-auth: User Authentication System
- **Type**: greenfield | **Created**: 2024-12-15
- **Branch**: main | **Completed**: 2024-12-22
- **Next**: Run @spec-archive

#### 005-logging: Centralized Logging System
- **Type**: brownfield | **Created**: 2024-12-20
- **Branch**: feat/logging | **Completed**: 2025-01-05
- **Next**: Run @spec-archive
```

### Step 6: Provide Workflow Guidance

**Based on current state:**

**Active features needing attention:**

- Features in `to-review`: Ready for `@spec-validate`
- Features in `ready`: Ready for `@spec-implement`
- Features in `draft`: Need `@spec-clarify` or `@spec-plan`

**Current branch context:**

- Show current git branch
- Highlight associated feature (if any)
- Suggest linking branch if working on unlinked feature

**Next actions summary:**

```
## Suggested Next Actions

- 002-add-2fa: @spec-validate (implementation complete)
- 003-payment-flow: @spec-implement (continue, 3 tasks remaining)
- 004-dashboard: @spec-implement (start implementation)
- 001-user-auth: @spec-archive (generate documentation)
- 005-logging: @spec-archive (generate documentation)
```

### Step 7: Handle Edge Cases

**No features found:**

```
# Features Overview

No features found in .specs/ directory.

## Get Started
Run `@spec-init` to create your first feature specification.
```

**Empty .specs/ directory:**

```
# Features Overview

.specs/ directory exists but contains no features.

## Get Started
Run `@spec-init` to create your first feature specification.
```

**Malformed features:**

```
# Features Overview

## Issues Found
- .specs/002-broken/: Missing or invalid spec.md frontmatter
- .specs/invalid/: Does not match {ID}-{feature} pattern

## Valid Features
{show_valid_features}
```

## Display Options

### Compact View (Default)

- Table format with essential information
- Status grouping with counts
- Current branch context
- Summary statistics

### Detailed View (`--details`)

- Expanded information per feature
- Task progress and completion percentages
- Requirements and acceptance criteria counts
- Specific next action recommendations
- Creation and completion dates

### Filtered View (`[status]`)

- Show only features matching specified status
- Maintain same format but filtered results
- Include context about other statuses for reference

## Workflow Integration

### Status Workflow

```
draft → ready → in-progress → to-review → done → archived
```

### Next Action Mapping

- **draft**: `@spec-clarify` (if clarifications needed) or `@spec-plan`
- **ready**: `@spec-tasks` then `@spec-implement`
- **in-progress**: `@spec-implement` (continue)
- **to-review**: `@spec-validate`
- **done**: `@spec-archive`
- **archived**: Complete (no action needed)

### Branch Integration

- Show current git branch and associated feature
- Highlight features without branch associations
- Suggest branch linking for active development

## Error Handling

- **No .specs directory**: Inform user, suggest `@spec-init`
- **Permission issues**: Report access problems
- **Malformed frontmatter**: Skip and report issues
- **Missing files**: Handle gracefully, show what's available
