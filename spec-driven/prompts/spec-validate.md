# Spec Validate Agent

Validate feature artifacts at any workflow phase. Automatically detects which artifacts exist and runs appropriate validation mode.

## Arguments

- `[ID]` - Feature ID (optional if branch is associated)

## Process

### Step 1: Resolve Feature

If ID provided:
- Use that feature directly

If no ID:
- Get current git branch
- Search `.specs/*/spec.md` for matching `branch:` in frontmatter
- If found, use that feature
- If not found:
  - If only one feature exists, use it
  - If multiple, list them and ask user to specify

### Step 2: Detect Validation Mode

Check which artifacts exist in `.specs/{ID}-{feature}/`:

| Artifacts Present | Mode | Description |
|-------------------|------|-------------|
| spec.md only | **Spec** | Validate spec structure |
| spec.md + plan.md | **Plan** | + documentation compliance |
| spec.md + plan.md + tasks.md | **Tasks** | + requirements coverage |
| All + status is in-progress/to-review | **Full** | + code validation |

### Step 3: Load Context

Based on detected mode, read:
- **Mode Spec**: `spec.md`
- **Mode Plan**: `spec.md`, `plan.md`, docs files from plan.md references
- **Mode Tasks**: `spec.md`, `plan.md`, `tasks.md`
- **Mode Full**: All artifacts + `git diff`

### Step 4: Run Validation

**Mode Spec Checks:**
- Has valid YAML frontmatter (id, feature, type, status, created)
- Contains `## Overview` section
- Contains `## Functional Requirements` with FR-xxx items
- Contains `## Acceptance Criteria` with AC-xxx items
- If type: brownfield, contains `## Baseline` section
- Count `[NEEDS CLARIFICATION]` markers

**Mode Plan Checks (+ Spec):**
- Contains `## Critical Files` section with tables
- Contains `## Architecture Decision` section
- Contains `## Requirements Traceability` table
- References existing files in codebase
- Documentation compliance check

**Mode Tasks Checks (+ Plan):**
- Has sequential task IDs (T001, T002...)
- All tasks have valid markers ([P] or [B:Txxx])
- Each FR-xxx has at least one task
- Each AC-xxx has validation approach

**Mode Full Checks (+ Tasks):**
- Acceptance criteria status (Satisfied/Partial/Missing)
- Architecture compliance
- Code issues (confidence >= 80 only)
- Planning gaps (new files not in plan)

### Step 5: Present Results

```markdown
## Validation: {ID}-{feature}

### Mode: {spec|plan|tasks|full}

### Artifact Structure
| File | Status | Issues |
|------|--------|--------|

### Consistency
| Check | Status |
|-------|--------|

### Acceptance Criteria (Mode Full)
| AC | Status | Notes |
|----|--------|-------|

### Summary
- Status: **{Ready|Needs fixes|Needs clarification}**
```

### Step 6: Determine Outcome

**Mode Full:**
- If all checks pass:
  - Update spec.md frontmatter to `status: done`
  - Suggest `@spec-archive`

- If any checks fail:
  - Keep status as `to-review`
  - List issues and suggest `@spec-implement`

### Step 7: Report

Summary with next steps:

| Mode | If Valid | If Issues |
|------|----------|----------|
| Spec | Run @spec-plan | Run @spec-clarify |
| Plan | Run @spec-tasks | Fix plan inconsistencies |
| Tasks | Run @spec-implement | Fix coverage gaps |
| Full | Run @spec-archive | Run @spec-implement |