# spec-driven

Specification-driven development workflow for Kiro CLI.

## Workflow

```
@spec-init --> @spec-clarify --> @spec-plan --> @spec-tasks --> @spec-implement --> @spec-validate --> @spec-archive
```

## Agents

| Agent             | Description                                                     |
| ----------------- | --------------------------------------------------------------- |
| `@spec-init`      | Create specification (auto-detects greenfield/brownfield)       |
| `@spec-clarify`   | Resolve ambiguities marked [NEEDS CLARIFICATION]                |
| `@spec-plan`      | Research (if needed), explore codebase, generate technical plan |
| `@spec-tasks`     | Generate task list from plan                                    |
| `@spec-implement` | Execute next task, or specify scope (T001, T001-T005, --all)    |
| `@spec-validate`  | Validate artifacts at any phase (auto-detects mode)             |
| `@spec-archive`   | Generate documentation and mark as archived                     |
| `@spec-list`      | List all features by status                                     |

## Greenfield vs Brownfield

| Type         | Description                   | Spec Contains                                     |
| ------------ | ----------------------------- | ------------------------------------------------- |
| `greenfield` | New feature, no existing code | Overview, User Stories, FR, AC                    |
| `brownfield` | Modification to existing code | Baseline section + Overview, User Stories, FR, AC |

The `@spec-init` agent auto-detects the type based on:

- Keywords in description (improve, refactor, fix = brownfield)
- Existing code in codebase matching the feature description

## Feature Organization

Features are organized by sequential ID:

```
.specs/
  001-user-auth/
  002-add-2fa/
  003-payment-flow/
```

Each spec.md has frontmatter metadata:

```yaml
---
id: 002
feature: add-2fa
type: greenfield | brownfield
status: draft | ready | in-progress | to-review | done | archived
branch: feat/add-2fa
created: 2025-01-03
---
```

## Validation Modes

The `@spec-validate` agent auto-detects which mode to use:

| Artifacts Present                  | Mode  | Description                |
| ---------------------------------- | ----- | -------------------------- |
| spec.md only                       | Spec  | Validate spec structure    |
| spec.md + plan.md                  | Plan  | + documentation compliance |
| spec.md + plan.md + tasks.md       | Tasks | + requirements coverage    |
| All + status in-progress/to-review | Full  | + code validation          |

## Status Lifecycle

```
draft --> ready --> in-progress --> to-review --> done --> archived
  |                                   |
  +--------@spec-clarify--------------+
```

## Task Categories

| Category       | Content                                 |
| -------------- | --------------------------------------- |
| Foundation     | base setup, types, config, dependencies |
| Implementation | core feature code, business logic       |
| Validation     | quality checks, tests, verification     |
| Documentation  | docs, comments, guides                  |

## Task Markers

| Marker          | Meaning                                          |
| --------------- | ------------------------------------------------ |
| `[P]`           | Parallel-safe: can run alongside other [P] tasks |
| `[B:T001]`      | Blocked: depends on T001                         |
| `[B:T001,T002]` | Blocked: depends on T001 and T002                |
| `- [ ]`         | Pending                                          |
| `- [x]`         | Completed                                        |

## Persistent Artifacts

### Working Files (.specs/ - gitignored)

| File       | Created By  | Purpose                                       |
| ---------- | ----------- | --------------------------------------------- |
| `spec.md`  | @spec-init  | Feature requirements and acceptance criteria  |
| `plan.md`  | @spec-plan  | Technical architecture and implementation map |
| `tasks.md` | @spec-tasks | Trackable task list with dependencies         |

### Permanent Files (docs/ - committed)

| File                         | Created By    | Purpose                                     |
| ---------------------------- | ------------- | ------------------------------------------- |
| `docs/research/{topic}.md`   | @spec-plan    | Reusable research findings                  |
| `docs/features/{feature}.md` | @spec-archive | Feature overview and architecture decisions |
| `docs/CHANGELOG.md`          | @spec-archive | Centralized project changelog               |

## Serena MCP Integration

This workflow uses Serena MCP for semantic code operations.

| Phase           | Tool                     | Benefit                 |
| --------------- | ------------------------ | ----------------------- |
| @spec-plan      | find_symbol              | Precise symbol location |
| @spec-plan      | find_referencing_symbols | Impact analysis         |
| @spec-implement | insert_after_symbol      | Semantic edits          |
