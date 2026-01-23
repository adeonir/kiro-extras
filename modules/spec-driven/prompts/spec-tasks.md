# Spec Tasks Agent

Transform technical plan into organized, trackable task list with dependencies and parallelization.

## Arguments

- `[ID]` - Feature ID (optional if branch is associated)

## Process

### Step 1: Resolve Feature

If ID provided:

- Use that feature directly

If no ID:

- Get current git branch
- Search `.specs/*/spec.md` for matching `branch:` in frontmatter
- If found: use that feature
- If not found:
  - If only one feature exists: use it
  - If multiple: list them and ask user to specify

### Step 2: Load Context and Validate Prerequisites

**Load Required Files:**

- **`spec.md`**: Extract all FR-xxx requirements and AC-xxx acceptance criteria
- **`plan.md`**: Implementation map, component design, and critical files
- **`package.json`**: Detect available scripts (lint, typecheck, test, build)

**Validate Prerequisites:**

- If `spec.md` missing: inform user to run `@spec-init`
- If `plan.md` missing: inform user to run `@spec-plan`
- If spec status not 'ready': suggest updating plan first

### Step 3: Requirements Analysis

**Extract All Requirements:**

- List all FR-xxx functional requirements from spec.md
- List all AC-xxx acceptance criteria from spec.md
- Note any technical considerations or constraints
- Identify integration points and dependencies

**Map to Implementation:**

- Connect each requirement to components from plan.md
- Identify which files need creation/modification
- Note testing requirements for each component
- Plan validation steps for acceptance criteria

### Step 4: Plan Analysis and Task Decomposition

**Study Implementation Map:**

- Understand component dependencies and build sequence
- Identify critical files and their purposes
- Note integration points and data flow
- Review error handling and testing strategies

**Break Down into Atomic Tasks:**

- Each task completable in one focused session (30-90 minutes)
- Include specific file paths and function names
- Reference relevant FR-xxx or AC-xxx items
- Specify expected outcomes and validation criteria

**Task Categories:**

- **Foundation**: Base setup, types, config, dependencies
- **Implementation**: Core feature code, business logic
- **Validation**: Quality checks, tests, verification
- **Documentation**: Docs, comments, guides

### Step 5: Dependency Analysis and Sequencing

**Identify Dependencies:**

- **Sequential**: Tasks that must complete before others can start
- **Parallel**: Tasks that can run simultaneously without conflicts
- **Blocking**: Tasks that prevent others from proceeding

**Assign Dependency Markers:**

- **`[P]`**: Parallel-safe, can run alongside other `[P]` tasks
- **`[B:T001]`**: Blocked by single task T001
- **`[B:T001,T002]`**: Blocked by multiple tasks T001 and T002
- **No marker**: Can run when reached in sequence

### Step 6: Quality Gate Integration

**Detect Available Scripts:**

- Check `package.json` for lint, typecheck, test, build scripts
- Determine package manager (npm, yarn, pnpm) from lockfiles
- Include quality gate tasks at appropriate points

**Quality Gate Commands:**

- Linting: `npm run lint --fix` or equivalent
- Type checking: `npm run typecheck` or equivalent
- Testing: `npm run test` or equivalent
- Build verification: `npm run build` or equivalent

### Step 7: Generate Comprehensive Task List

Create `.specs/{ID}-{feature}/tasks.md`:

```markdown
# Tasks: {feature_name}

Feature: {ID}-{feature} | Created: {date}
Total: {count} | Completed: 0 | Remaining: {count}

## Artifacts

- Spec: .specs/{ID}-{feature}/spec.md
- Plan: .specs/{ID}-{feature}/plan.md
- Research: docs/research/{topic}.md (if exists)

## Foundation

- [ ] T001 [P] Create base types and interfaces
  - File: `src/types/{feature}.ts`
  - Define core data structures from plan.md
  - Export interfaces for external use
  - **Validates**: FR-001 data structure requirements

- [ ] T002 [P] Set up configuration and constants
  - File: `src/config/{feature}.ts`
  - Add feature-specific configuration
  - Define error messages and constants
  - **Validates**: Technical considerations from spec

## Implementation

- [ ] T003 [B:T001] Implement core {component} service
  - File: `src/services/{ComponentService}.ts`
  - Follow patterns from {reference_file}
  - Implement methods: {method_list}
  - **Validates**: FR-002, FR-003

- [ ] T004 [B:T003] Add {integration} integration layer
  - File: `src/integrations/{integration}.ts`
  - Connect to external service/API
  - Handle authentication and error cases
  - **Validates**: FR-004 integration requirements

- [ ] T005 [B:T003,T004] Implement main feature logic
  - File: `src/{feature}/{FeatureController}.ts`
  - Orchestrate service calls and data flow
  - Handle business rules and validation
  - **Validates**: FR-005, AC-001, AC-002

## Validation

- [ ] T006 [P] Create unit tests for {component} service
  - File: `src/services/__tests__/{ComponentService}.test.ts`
  - Test all public methods and edge cases
  - Mock external dependencies
  - **Validates**: AC-003, AC-004

- [ ] T007 [B:T004] Add integration tests for {integration}
  - File: `src/integrations/__tests__/{integration}.test.ts`
  - Test external service integration
  - Handle authentication and error scenarios
  - **Validates**: AC-005

- [ ] T008 [B:T005] Create end-to-end feature tests
  - File: `src/__tests__/e2e/{feature}.test.ts`
  - Test complete feature workflow
  - Validate against all acceptance criteria
  - **Validates**: AC-006, AC-007

## Quality Gates

- [ ] T009 [B:T003,T004,T005] Run lint and format
  - Command: `{pkg_manager} run lint --fix`
  - Fix any remaining lint errors manually
  - Ensure code style consistency

- [ ] T010 [B:T006,T007,T008] Run type checking
  - Command: `{pkg_manager} run typecheck`
  - Fix any type errors
  - Ensure type safety across feature

- [ ] T011 [B:T009,T010] Run all tests
  - Command: `{pkg_manager} run test`
  - Ensure all tests pass
  - Verify test coverage meets requirements

## Documentation

- [ ] T012 [B:T011] Update API documentation
  - File: `docs/api/{feature}.md`
  - Document public interfaces and usage
  - Include examples and edge cases
  - **Validates**: Documentation requirements

- [ ] T013 [P] Add inline code comments
  - Add JSDoc comments to public methods
  - Document complex business logic
  - Explain non-obvious implementation decisions

---

**Legend:** [P] = parallel-safe, [B:Txxx] = blocked by task(s)

**Quality Gates:** Run `{pkg_manager} run lint --fix && {pkg_manager} run typecheck` after each implementation milestone.

## Requirements Coverage

| Requirement           | Task(s)    | Validation Method         |
| --------------------- | ---------- | ------------------------- |
| FR-001: {requirement} | T001, T003 | Unit tests in T006        |
| FR-002: {requirement} | T003, T005 | Integration tests in T007 |
| FR-003: {requirement} | T004, T005 | End-to-end tests in T008  |
| AC-001: {criterion}   | T005       | Validated in T008         |
| AC-002: {criterion}   | T005       | Validated in T008         |

## Task Categories Summary

| Category       | Tasks     | Complexity | Parallel Opportunities                |
| -------------- | --------- | ---------- | ------------------------------------- |
| Foundation     | T001-T002 | Low        | Both can run in parallel              |
| Implementation | T003-T005 | High       | Sequential due to dependencies        |
| Validation     | T006-T008 | Medium     | T006 can run early, others sequential |
| Quality Gates  | T009-T011 | Low        | Must run after implementation         |
| Documentation  | T012-T013 | Low        | T013 can run in parallel              |

## Execution Strategy

**Phase 1: Foundation (Parallel)**

- Execute T001 and T002 simultaneously
- Set up basic structure and configuration

**Phase 2: Core Implementation (Sequential)**

- T003 → T004 → T005 in dependency order
- Each task builds on previous work

**Phase 3: Validation (Mixed)**

- T006 can start after T003
- T007 requires T004 completion
- T008 requires T005 completion

**Phase 4: Quality & Documentation (Final)**

- Run quality gates after implementation
- Add documentation and final polish
```

### Step 8: Validation and Quality Check

**Completeness Validation:**

- All FR-xxx requirements covered by implementation tasks
- All AC-xxx criteria have validation tasks
- All components from plan.md included in tasks
- All critical files addressed with specific tasks
- Testing tasks for all new functionality

**Dependency Validation:**

- No circular dependencies in task chain
- Parallel tasks are truly independent
- Blocking dependencies clearly specified
- Logical execution sequence maintained

**Task Quality Validation:**

- Each task is atomic and actionable
- File paths and specifics included
- Success criteria clearly defined
- Reasonable scope for focused work session

### Step 9: Update Status and Report

**Update Feature Status:**

- Update `spec.md` frontmatter: `status: ready` (ready for implementation)

**Report to User:**

- **Task list created**: `.specs/{ID}-{feature}/tasks.md`
- **Total tasks**: X tasks across Y categories
- **Foundation tasks**: Z setup and configuration tasks
- **Implementation tasks**: A core functionality tasks
- **Validation tasks**: B testing and quality tasks
- **Documentation tasks**: C documentation tasks
- **Parallel opportunities**: D tasks can run simultaneously
- **Estimated effort**: E hours based on task complexity
- **Next step**: `@spec-implement` to start execution

**Summary Table:**

```
| Category | Tasks | Complexity | Dependencies |
|----------|-------|------------|--------------|
| Foundation | T001-T002 | Low | None (parallel) |
| Implementation | T003-T005 | High | Sequential chain |
| Validation | T006-T008 | Medium | Mixed dependencies |
| Quality Gates | T009-T011 | Low | After implementation |
| Documentation | T012-T013 | Low | T013 parallel-safe |
```

## Task Generation Guidelines

### Task Granularity Standards

**Atomic Tasks (Ideal):**

- Create single file with specific purpose
- Implement specific method or class
- Add specific test suite with clear scope
- Update specific configuration or documentation
- Complete in 30-90 minutes of focused work

**Too Large (Avoid):**

- "Implement entire feature"
- "Add all tests for feature"
- "Complete all integration work"
- "Finish all documentation"

**Too Small (Avoid):**

- "Add single line of code"
- "Import single dependency"
- "Fix single typo"
- "Add single comment"

### Dependency Management Best Practices

**Parallel-Safe Tasks `[P]`:**

- Independent file creation (types, configs)
- Separate test suites for different components
- Documentation tasks that don't conflict
- Setup tasks that don't share resources

**Sequential Dependencies `[B:Txxx]`:**

- Implementation depends on types/interfaces
- Integration depends on core services
- Tests depend on implementation being complete
- Quality gates depend on code being ready

**Multiple Dependencies `[B:T001,T002]`:**

- Feature logic depends on service AND integration
- End-to-end tests depend on multiple components
- Final validation depends on all implementation

### Quality Integration Strategy

**Built-in Quality Gates:**

- Lint and format checks after implementation phases
- Type checking after major structural changes
- Test execution after test creation
- Build verification before feature completion

**Continuous Validation:**

- Reference acceptance criteria in task descriptions
- Include validation steps in task outcomes
- Plan verification methods for each requirement
- Ensure testability of all functionality

### Requirements Traceability

**Every Implementation Task Should:**

- Reference specific FR-xxx requirements it addresses
- Include validation method or test reference
- Specify expected outcome and success criteria
- Connect to overall feature goals and acceptance criteria

**Every Validation Task Should:**

- Reference specific AC-xxx criteria it validates
- Include test cases or verification methods
- Specify pass/fail criteria
- Connect to functional requirements being tested
