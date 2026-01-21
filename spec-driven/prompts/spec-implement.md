# Spec Implement Agent

Execute tasks from the task list, respecting dependencies and updating progress.

## Arguments

| Input | Action |
|-------|--------|
| `[ID]` | Feature ID (optional if branch is associated) |
| (empty) | Next pending task |
| `T001` | Single task |
| `T001-T005` | Range of tasks |
| `--all` | All pending tasks |

## Process

### Step 1: Resolve Feature

Parse arguments to extract:
- Feature ID (if provided as first numeric arg or `XXX-name` format)
- Task scope (T001, T001-T005, --all, or empty)

If no ID:
- Get current git branch
- Search `.specs/*/spec.md` for matching `branch:` in frontmatter
- If found, use that feature
- If not found:
  - If only one feature exists, use it
  - If multiple, list them and ask user to specify

### Step 2: Load Context

Read from `.specs/{ID}-{feature}/`:
- `spec.md` - Requirements (extract Acceptance Criteria section)
- `plan.md` - Technical decisions and Critical Files
- `tasks.md` - Task list and progress

Check `docs/research/` for any referenced research files.

If plan.md or tasks.md don't exist, inform user to run `@spec-plan` and `@spec-tasks` first.

### Step 3: Update Status

If status is `ready` or `draft`:
- Update spec.md frontmatter to `status: in-progress`

### Step 4: Load Critical Files

From plan.md, identify the `## Critical Files` section.

For the tasks about to execute:
- Read the **Reference Files** relevant to current tasks (max 5 files)
- These provide patterns and conventions to follow

### Step 5: Parse Scope

Determine which tasks to execute based on arguments.

### Step 6: Validate Dependencies

For each task to execute:
- If marked `[P]`, can proceed
- If marked `[B:Txxx]`, check if Txxx is completed
- Skip blocked tasks, inform user

### Step 7: Execute Tasks

For each task:
- Follow the technical plan precisely
- Follow patterns from reference files
- Apply best practices from research.md when applicable
- Match existing codebase conventions
- Write clean, well-structured code
- Handle edge cases and errors appropriately
- Validate implementation against acceptance criteria

### Step 8: Run Quality Gates

After each task (or range of tasks):
- Run the quality gate commands from tasks.md
- If lint fails, try `--fix` flag first
- Fix remaining lint or type errors manually
- Re-run until passing

### Step 9: Update Progress

- Mark tasks as completed: `- [x] T001 ...`
- Update counters: `Completed: X | Remaining: Y`

### Step 10: Check Completion

After execution, check if ALL tasks are completed.

If all tasks done:
- Update spec.md frontmatter to `status: to-review`
- Inform user that implementation is complete

### Step 11: Report

After execution:
- Show tasks completed
- Show files created/modified
- Show remaining tasks (if any)
- Suggest commit message
- If all done: suggest `@spec-validate`
- If tasks remain: suggest continuing with `@spec-implement`

## Error Handling

- **Feature not found**: List available features or suggest `@spec-init`
- **Plan/tasks not found**: Inform user to run previous commands
- **Dependency blocked**: List which tasks need to complete first
- **Implementation error**: Report issue, keep task unchecked