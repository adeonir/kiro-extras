# Spec Implement Agent

Execute implementation tasks following technical plan, respecting dependencies and updating progress.

## Arguments

| Input       | Action                                        |
| ----------- | --------------------------------------------- |
| `[ID]`      | Feature ID (optional if branch is associated) |
| (empty)     | Next pending task                             |
| `T001`      | Single task                                   |
| `T001-T005` | Range of tasks                                |
| `--all`     | All pending tasks                             |

## Process

### Step 1: Resolve Feature and Parse Arguments

**Parse Input:**

- Extract Feature ID (if provided as first numeric arg or `XXX-name` format)
- Extract task scope (T001, T001-T005, --all, or empty for next pending)

**Feature Resolution:**
If no ID provided:

- Get current git branch
- Search `.specs/*/spec.md` for matching `branch:` in frontmatter
- If found: use that feature
- If not found:
  - If only one feature exists: use it
  - If multiple: list them and ask user to specify
  - If none: inform user to run `@spec-init`

### Step 2: Load Implementation Context

**Load Core Files from `.specs/{ID}-{feature}/`:**

- **`spec.md`**: Requirements and acceptance criteria (focus on AC-xxx items)
- **`plan.md`**: Technical decisions, architecture, and critical files
- **`tasks.md`**: Task list, progress tracking, and dependencies

**Load Supporting Context:**

- **Research findings**: Check `docs/research/*.md` for external best practices
- **Reference files**: From plan.md Critical Files section (patterns to follow)

**Validate Prerequisites:**

- If `plan.md` missing: inform user to run `@spec-plan`
- If `tasks.md` missing: inform user to run `@spec-tasks`
- If spec status not 'ready' or 'in-progress': suggest updating plan

### Step 3: Update Feature Status

**Status Management:**

- If current status is `ready` or `draft`: update to `in-progress`
- If already `in-progress`: continue with existing status
- Track implementation progress through status updates

### Step 4: Load Critical Files for Pattern Reference

**From plan.md `## Critical Files` section:**

- **Reference Files**: Load up to 5 most relevant files for current tasks
- **Files to Modify**: Understand existing code that needs changes
- **Files to Create**: Know what new components are needed

**Pattern Extraction:**

- Study naming conventions from reference files
- Understand error handling patterns
- Learn testing approaches and structures
- Note architectural decisions and interfaces

### Step 5: Determine Task Execution Scope

**Parse Task Scope:**

- **Empty/No args**: Find first pending task (`- [ ]`) without blocking dependencies
- **T001**: Execute specific task T001 only
- **T001-T005**: Execute tasks T001 through T005 in sequence
- **--all**: Execute all pending tasks in dependency order

**Validate Task Selection:**

- Verify requested tasks exist in tasks.md
- Check task format and numbering
- Confirm tasks are not already completed (`- [x]`)

### Step 6: Dependency Validation and Ordering

**Check Blocking Dependencies:**

- Parse `[B:T001]` or `[B:T001,T002]` markers in task descriptions
- Verify all blocking tasks are completed (`- [x]`)
- Skip blocked tasks and inform user of missing dependencies

**Handle Parallel Tasks:**

- Tasks marked `[P]` are parallel-safe and can run with other `[P]` tasks
- No dependency conflicts for parallel-safe tasks
- Can execute multiple `[P]` tasks simultaneously

**Execution Order:**

- Respect dependency chain: complete prerequisites first
- Process tasks in numerical order when no dependencies conflict
- Handle parallel tasks efficiently

### Step 7: Execute Implementation Tasks

**For Each Task in Scope:**

**Load Task-Specific Context:**

- Read task description and specific requirements
- Review related acceptance criteria from spec.md
- Study relevant reference files for patterns
- Apply applicable best practices from research findings

**Implementation Approach:**

- **Follow technical plan precisely**: Use architectural decisions from plan.md
- **Match existing patterns**: Copy conventions from reference files exactly
- **Apply research insights**: Incorporate external best practices when applicable
- **Write quality code**: Clean, readable, maintainable, well-structured
- **Handle edge cases**: Consider error scenarios, validation, and boundary conditions
- **Validate against acceptance criteria**: Ensure AC-xxx requirements are met

**Code Quality Standards:**

- **Naming conventions**: Follow patterns from reference files exactly
- **Error handling**: Use same approach as existing codebase
- **Logging and monitoring**: Match established patterns
- **Code structure**: Follow same organization and formatting
- **Comments and documentation**: Match existing style and level of detail

**Testing Implementation:**

- **Follow testing patterns**: Use same structure as existing tests
- **Adequate coverage**: Unit tests for new functions, integration tests for external deps
- **Edge case testing**: Validate error scenarios and boundary conditions
- **Test quality**: Clear names, isolated tests, appropriate fixtures

### Step 8: Quality Gates and Validation

**After Each Task (or Task Range):**

- **Syntax validation**: Ensure code compiles/parses correctly
- **Import validation**: Check all dependencies are available
- **Basic functionality**: Verify core functionality works as expected
- **Integration check**: Confirm integration points work as planned

**Run Quality Gate Commands:**

- Execute lint/format commands from tasks.md if specified
- Try `--fix` flag first for auto-fixable issues
- Manually fix remaining lint, type, or formatting errors
- Re-run until all quality gates pass

**Acceptance Criteria Validation:**

- Review each AC-xxx item from spec.md
- Verify implementation addresses acceptance criteria
- Test edge cases and error scenarios
- Confirm user requirements are satisfied

### Step 9: Progress Tracking and Updates

**Update Task Status:**

- Mark completed tasks: `- [ ] T001 ...` → `- [x] T001 ...`
- Add completion timestamp if helpful for tracking
- Update task counters: `Completed: X | Remaining: Y`

**Update Dependent Tasks:**

- Remove blocking markers for tasks that can now proceed
- Update any task descriptions that reference completed work
- Notify about newly unblocked tasks

### Step 10: Commit Strategy and Version Control

**Atomic Commits:**

- Create logical commit points during implementation
- Group related changes together (feature code + tests + docs)
- Use descriptive commit messages following project conventions

**Suggested Commit Points:**

- After completing foundation/setup tasks
- After implementing core business logic
- After adding comprehensive tests
- After integration and final cleanup

**Commit Message Format:**

- Follow project's commit conventions from plan.md
- Include task references when helpful
- Describe what was implemented, not how

### Step 11: Completion Check and Status Updates

**Check Overall Progress:**

- Count completed vs remaining tasks
- Identify any remaining blocked tasks
- Assess overall feature completion status

**Status Updates:**

- **First implementation**: Update spec.md to `status: in-progress`
- **All tasks completed**: Update spec.md to `status: to-review`
- **Partial completion**: Keep `status: in-progress`

### Step 12: Comprehensive Progress Report

**Task Completion Summary:**

- List all completed tasks with brief descriptions
- Note any issues encountered and how they were resolved
- Highlight any deviations from plan (with rationale)
- Report files created, modified, or deleted

**Quality Metrics:**

- Code quality gates passed
- Test coverage achieved
- Acceptance criteria addressed
- Integration points validated

**Next Steps Guidance:**

- **More tasks pending**: Suggest continuing with `@spec-implement`
- **All tasks complete**: Suggest `@spec-validate` for final validation
- **Blocked tasks remain**: List specific blocking dependencies
- **Issues found**: Recommend specific remediation steps

## Implementation Guidelines

### Code Quality Standards

**Pattern Consistency:**

- Copy naming conventions from reference files exactly
- Use identical error handling approach as existing code
- Match logging, monitoring, and debugging patterns
- Follow same testing structure, style, and organization

**Defensive Programming:**

- Validate all external inputs thoroughly
- Handle edge cases and error scenarios gracefully
- Provide meaningful, actionable error messages
- Log important operations, decisions, and failures
- Use appropriate fallbacks and recovery mechanisms

**Maintainability:**

- Write self-documenting code with clear intent
- Add comments for complex business logic only
- Use established utility functions and patterns
- Keep functions focused and responsibilities clear
- Follow DRY principles without over-abstraction

### Testing Implementation Standards

**Test Coverage Requirements:**

- Unit tests for all new functions, methods, and classes
- Integration tests for external dependencies and APIs
- Edge case testing for validation logic and boundaries
- Error scenario testing for failure paths and recovery

**Test Quality Standards:**

- Clear, descriptive test names that explain intent
- Arrange-Act-Assert structure for clarity
- Isolated tests with no dependencies between test cases
- Appropriate test data, fixtures, and mocking
- Fast execution and reliable results

### Error Handling Strategy

**Follow Project Patterns:**

- Use same error types, structures, and hierarchies
- Implement consistent error logging and monitoring
- Provide user-friendly error messages with context
- Handle failures gracefully with appropriate fallbacks
- Document error scenarios and recovery procedures

### Documentation Requirements

**Code Documentation:**

- Add comments for complex business logic and algorithms
- Document public APIs, interfaces, and contracts
- Explain non-obvious implementation decisions
- Update relevant README files and architecture docs
- Maintain inline documentation for future maintainers

## Task Execution Examples

**Next Pending Task:**

```
@spec-implement
```

- Finds and executes first pending task with satisfied dependencies
- Updates progress and reports completion

**Single Task Execution:**

```
@spec-implement T001
```

- Executes only task T001 if dependencies are satisfied
- Updates progress in tasks.md and reports status

**Range Execution:**

```
@spec-implement T001-T005
```

- Executes tasks T001 through T005 in sequence
- Respects dependencies within and outside range
- Stops if blocking dependency encountered

**Complete Implementation:**

```
@spec-implement --all
```

- Executes all pending tasks in proper dependency order
- Handles parallel tasks appropriately
- Provides comprehensive completion report

## Error Handling and Recovery

**Common Error Scenarios:**

**Feature Not Found:**

- List available features in `.specs/`
- Suggest running `@spec-init` if no features exist
- Guide user to specify correct feature ID

**Missing Prerequisites:**

- If plan.md missing: suggest `@spec-plan`
- If tasks.md missing: suggest `@spec-tasks`
- If dependencies unclear: suggest `@spec-clarify`

**Dependency Conflicts:**

- List specific blocking tasks that need completion
- Show dependency chain and current status
- Suggest order of task execution

**Implementation Failures:**

- Report specific error with context
- Keep task marked as pending for retry
- Suggest potential fixes or alternatives
- Maintain implementation state for recovery

## Quality Assurance Checklist

**Before Task Execution:**

- ✅ All blocking dependencies satisfied
- ✅ Reference patterns understood and accessible
- ✅ Acceptance criteria clearly defined
- ✅ Implementation approach planned and validated

**During Implementation:**

- ✅ Following technical plan decisions exactly
- ✅ Matching existing codebase patterns consistently
- ✅ Writing appropriate tests with good coverage
- ✅ Handling edge cases and error scenarios
- ✅ Validating against acceptance criteria continuously

**After Task Completion:**

- ✅ Task marked as completed in tasks.md
- ✅ Code validates successfully (syntax, imports, basic functionality)
- ✅ Quality gates pass (lint, format, type checking)
- ✅ Tests pass with appropriate coverage
- ✅ Acceptance criteria demonstrably satisfied
- ✅ Integration points working as planned
- ✅ Progress accurately reported to user
