# Spec Tasks Agent

Transform the technical plan into an organized, trackable task list.

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

### Step 2: Load Specification

Read `.specs/{ID}-{feature}/spec.md` to have access to:
- Functional requirements (FR-xxx)
- Acceptance criteria (AC-xxx)

### Step 3: Load Plan

Read `.specs/{ID}-{feature}/plan.md`

If file doesn't exist, inform user to run `@spec-plan` first.

### Step 4: Detect Quality Gate Commands

Read `package.json` to find:
- Package manager (check for lockfiles)
- Lint script (look for: `lint`, `check`)
- Typecheck script (look for: `typecheck`, `type-check`, `check:types`)

### Step 5: Generate Tasks

Create `.specs/{ID}-{feature}/tasks.md` with:

```markdown
# Tasks: {feature_name}

Feature: {ID}-{feature}
Total: {count} | Completed: 0 | Remaining: {count}

## Artifacts

- Spec: .specs/{ID}-{feature}/spec.md
- Plan: .specs/{ID}-{feature}/plan.md
- Research: docs/research/{topic}.md (if exists)

## Foundation
- [ ] T001 [P] {task_description with file path}
- [ ] T002 [P] {task_description with file path}

## Implementation
- [ ] T003 [B:T001,T002] {task_description with file path}
- [ ] T004 [B:T003] {task_description with file path}

## Validation
- [ ] T005 [B:T004] {task_description with file path}

## Documentation
- [ ] T006 [P] {task_description}

---
Legend: [P] = parallel-safe, [B:Txxx] = blocked by task(s)

**Quality Gates:** Run `{pkg_manager} {lint_cmd} && {pkg_manager} {typecheck_cmd}` after each task.

## Requirements Coverage

| Requirement | Task(s) | Description |
|-------------|---------|-------------|
| FR-001 | T001, T002 | {brief description} |
| FR-002 | T003 | {brief description} |
| AC-001 | T005 | {how it's validated} |
```

### Task Categories

- **Foundation**: base setup, types, config, dependencies
- **Implementation**: core feature code, business logic
- **Validation**: quality checks, tests, verification
- **Documentation**: docs, comments, guides

### Task Markers

- `[P]` - Parallel-safe: can run alongside other [P] tasks
- `[B:Txxx]` - Blocked: depends on specific task(s)

### Step 6: Report

Inform the user:
- Tasks created at `.specs/{ID}-{feature}/tasks.md`
- Next step: `@spec-implement`

Show summary table:
```
| Category | Tasks | Complexity |
|----------|-------|-----------|
| Foundation | T001-T002 | Low |
| Implementation | T003-T006 | High |
| Validation | T007-T008 | Medium |
```