# Spec Validate Agent

Multi-mode validator for spec-driven workflow artifacts and implementations.

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

### Step 2: Auto-Detect Validation Mode

Check which artifacts exist in `.specs/{ID}-{feature}/`:

| Artifacts Present                  | Mode      | Description                         |
| ---------------------------------- | --------- | ----------------------------------- |
| spec.md only                       | **Spec**  | Validate specification structure    |
| spec.md + plan.md                  | **Plan**  | Validate plan against spec and docs |
| spec.md + plan.md + tasks.md       | **Tasks** | Validate task coverage              |
| All + status in-progress/to-review | **Full**  | Validate implementation             |

### Step 3: Load Context Based on Mode

**Mode Spec:**

- Load `spec.md` only

**Mode Plan:**

- Load `spec.md`, `plan.md`
- Load referenced documentation files from plan
- Check project guidelines (`CLAUDE.md`, `.kiro/steering/*.md`)

**Mode Tasks:**

- Load `spec.md`, `plan.md`, `tasks.md`
- Check `package.json` for quality gate scripts

**Mode Full:**

- Load all artifacts
- Get git status and diff for implementation validation
- Load implemented files for code quality checks

### Step 4: Execute Validation Mode

## Mode: Spec (Specification Structure)

**Validate after `@spec-init`**

### Frontmatter Validation

- Valid YAML frontmatter present
- Required fields: `id`, `feature`, `type`, `status`, `created`
- ID is numeric and matches directory name
- Feature name is kebab-case
- Type is either `greenfield` or `brownfield`
- Status is valid workflow state
- Created date is valid YYYY-MM-DD format

### Content Structure Validation

- Contains `## Overview` section with meaningful description
- Contains `## Functional Requirements` section
- Contains `## Acceptance Criteria` section
- FR-xxx items are properly numbered and sequential
- AC-xxx items are properly numbered and sequential
- Requirements are specific and testable
- Acceptance criteria are measurable

### Type-Specific Validation

**For Brownfield Features:**

- Contains `## Baseline Analysis` section
- Baseline includes current implementation details
- Baseline includes modification points
- Baseline references specific files and functions

### Quality Checks

- No empty sections or placeholder text
- Requirements are clear and unambiguous
- Acceptance criteria are testable
- Technical considerations are documented

### Ambiguity Detection

- Count `[NEEDS CLARIFICATION]` markers
- Count `[RESEARCH NEEDED]` markers
- Count `[DECISION REQUIRED]` markers

---

## Mode: Plan (Technical Plan Validation)

**Validate after `@spec-plan`**

### Plan Structure Validation

- Contains `## Context` with feature reference
- Contains `## Critical Files` section with tables
- Contains `## Architecture Decision` section
- Contains `## Component Design` section
- Contains `## Requirements Traceability` section

### Documentation Compliance

- All referenced documentation files actually exist
- Implementation decisions supported by evidence
- Patterns match existing codebase conventions
- Data formats align with documented examples
- No `[NOT DOCUMENTED - needs verification]` markers remain

### Requirements Coverage

- Every FR-xxx from spec.md appears in traceability table
- Each requirement mapped to specific components
- Each component has clear file path and responsibility
- No requirements left unmapped

### Architecture Validation

- Single, decisive approach chosen (no multiple options)
- Component responsibilities are clear and non-overlapping
- Data flow is documented end-to-end
- Integration points are identified
- Error handling approach is defined

### Critical Files Validation

- Reference files exist and contain relevant patterns
- Files to modify exist and are appropriate targets
- Files to create have clear purposes and locations
- No circular dependencies in file relationships

---

## Mode: Tasks (Task Coverage Validation)

**Validate after `@spec-tasks`**

### Task Structure Validation

- Tasks have sequential IDs (T001, T002, etc.)
- Tasks are properly categorized
- Dependency markers are valid (`[P]`, `[B:T001]`, `[B:T001,T002]`)
- No circular dependencies in task chain

### Requirements Coverage Validation

- Every FR-xxx from spec.md covered by implementation tasks
- Every AC-xxx from spec.md covered by validation tasks
- Requirements coverage table is complete and accurate
- Each task references specific requirements it addresses

### Task Quality Validation

- Tasks are atomic and actionable
- Tasks include specific file paths and actions
- Tasks have clear success criteria
- Tasks are appropriately scoped

### Dependency Logic Validation

- Parallel tasks (`[P]`) are truly independent
- Blocking dependencies (`[B:Txxx]`) are logical
- No tasks blocked by non-existent tasks
- Execution order makes architectural sense

### Quality Gate Integration

- Quality gate tasks included at appropriate points
- Commands reference actual package.json scripts
- Testing tasks cover all new functionality
- Documentation tasks address all public interfaces

---

## Mode: Full (Implementation Validation)

**Validate after `@spec-implement` (partial or complete)**

### Implementation Progress Validation

- Task completion status accurately reflects implementation
- All completed tasks have corresponding code changes
- No tasks marked complete without implementation
- Feature status matches implementation progress

### Acceptance Criteria Validation

For each AC-xxx from spec.md:

- **Satisfied**: Fully implemented and verifiable
- **Partial**: Partially implemented, needs completion
- **Missing**: Not yet implemented
- **Not Applicable**: No longer relevant

### Code Quality Validation

- Implementation follows patterns from reference files
- Code style matches existing codebase conventions
- Error handling follows established patterns
- Logging and monitoring are appropriately implemented

### Requirements Validation

- Each completed FR-xxx requirement is demonstrably implemented
- Implementation matches specification requirements
- Edge cases and error scenarios are handled
- Integration points work as planned

### Testing Validation

- Unit tests exist for all new functions/methods
- Integration tests cover external dependencies
- Test coverage meets project standards
- Tests are well-structured and maintainable

### Architecture Compliance

- Implementation follows planned architecture
- Components have expected responsibilities
- Data flow matches planned design
- Integration points work as specified

### Quality Gate Validation

- Linting passes without errors
- Type checking passes without errors
- All tests pass
- Build succeeds without warnings

---

### Step 5: Generate Validation Report

Create comprehensive validation report:

```markdown
# Validation Report: {feature_name}

**Mode**: {validation_mode} | **Date**: {date} | **Status**: {pass/fail/partial}

## Summary

- **Feature**: {ID}-{feature}
- **Artifacts Validated**: {list_of_files}
- **Checks Performed**: {total_checks}
- **Passed**: {passed_count}
- **Failed**: {failed_count}
- **Warnings**: {warning_count}

## Validation Results

### Passed Checks

- Specification structure is valid and complete
- All functional requirements are properly numbered
- Technical plan maps all requirements to components
- Task dependencies are logical and non-circular
- {other_passed_checks}

### Failed Checks

- Missing acceptance criteria for FR-003
- Task T005 has circular dependency with T007
- AC-002 is not yet implemented
- {other_failed_checks}

### Warnings

- FR-001 acceptance criteria could be more specific
- Task T008 might be too large for single session
- Consider adding integration tests for external API
- {other_warnings}

## Acceptance Criteria Status (Full Mode Only)

| Criterion                   | Status       | Implementation              | Notes                    |
| --------------------------- | ------------ | --------------------------- | ------------------------ |
| AC-001: User can login      | Satisfied | LoginService.authenticate() | Tests passing            |
| AC-002: Password validation | Partial   | Basic validation only       | Missing complexity rules |
| AC-003: Session management  | Missing   | Not implemented             | Planned for T009         |

## Requirements Coverage (Tasks/Full Mode)

| Requirement              | Implementation Tasks | Validation Tasks | Status         |
| ------------------------ | -------------------- | ---------------- | -------------- |
| FR-001: Authentication   | T003, T004           | T007             | Complete    |
| FR-002: Authorization    | T005                 | T008             | In Progress |
| FR-003: Session handling | T006                 | T009             | Pending     |

## Code Quality Issues (Full Mode Only)

### High Confidence Issues (≥80)

- **[85] [src/auth/LoginService.ts:42]** Potential null pointer exception
  - Fix: Add null check before accessing user.profile
- **[90] [src/auth/PasswordValidator.ts:15]** Security vulnerability
  - Fix: Use bcrypt for password hashing instead of plain text

### Warnings (50-79)

- **[65] [src/auth/SessionManager.ts:28]** Consider using Map instead of object
  - Improvement: Better performance for frequent lookups

## Planning Gaps (Full Mode Only)

### Files Created Not in Plan

- `src/utils/ValidationHelper.ts` - Consider adding to plan
- `src/types/AuthTypes.ts` - Should be documented

### Files Modified Not in Plan

- `src/config/database.ts` - Unexpected change, verify necessity

## Recommendations

### Immediate Actions Required

1. **Fix FR-003**: Add specific acceptance criteria for session handling
2. **Resolve T005 dependency**: Remove circular dependency with T007
3. **Implement AC-002**: Complete password validation with complexity rules
4. **Security fix**: Replace plain text password storage with bcrypt

### Suggested Improvements

1. **Enhance AC-001**: Add specific timeout and security requirements
2. **Split T008**: Consider breaking authorization task into smaller pieces
3. **Add integration tests**: Cover external authentication service
4. **Update plan**: Document newly created utility files

## Next Steps

{mode_specific_recommendations}
```

### Step 6: Mode-Specific Recommendations

**After Spec Validation:**

- **If valid**: Ready for `@spec-plan`
- **If clarifications needed**: Run `@spec-clarify`
- **If warnings**: Consider improvements, then proceed

**After Plan Validation:**

- **If valid**: Ready for `@spec-tasks`
- **If issues found**: Fix plan inconsistencies and re-validate
- **If documentation gaps**: Update plan with missing evidence

**After Tasks Validation:**

- **If valid**: Ready for `@spec-implement`
- **If coverage gaps**: Update tasks to cover all requirements
- **If dependency issues**: Resolve circular or illogical dependencies

**After Full Validation:**

- **If complete**: Update status to `done`, ready for `@spec-archive`
- **If implementation gaps**: Continue with `@spec-implement`
- **If partial**: Address critical issues, then continue implementation

### Step 7: Update Feature Status

**Based on validation results:**

**Spec Mode:**

- Keep current status
- Suggest next step based on validation outcome

**Plan Mode:**

- Update to `ready` if validation passes completely
- Keep current status if issues need resolution

**Tasks Mode:**

- Confirm `ready` status if validation passes
- Flag issues that need task list updates

**Full Mode:**

- Update to `done` if all validations pass and implementation is complete
- Update to `to-review` if implementation is complete but has minor issues
- Keep `in-progress` if significant work remains

### Step 8: Report Validation Results

**Summary Report:**

- **Mode executed**: {validation_mode}
- **Overall result**: Pass/Fail/Partial
- **Critical issues**: {count} requiring immediate attention
- **Warnings**: {count} suggested improvements
- **Acceptance criteria**: {satisfied}/{total} complete (full mode)
- **Next recommended action**: {specific_next_step}

**Detailed Breakdown:**

- **Structure validation**: {pass/fail}
- **Requirements coverage**: {pass/fail}
- **Implementation quality**: {pass/fail} (full mode only)
- **Documentation compliance**: {pass/fail}
- **Code quality**: {issues_found} issues (full mode only)

**Action Items:**

1. {highest_priority_fix}
2. {second_priority_fix}
3. {suggested_improvement}

## Validation Standards

### Quality Thresholds

**Critical Issues (Must Fix):**

- Missing or invalid required sections
- Unmapped functional requirements
- Circular task dependencies
- Failed quality gates (lint, typecheck, tests)
- Security vulnerabilities (confidence ≥80)
- Unimplemented acceptance criteria

**Warnings (Should Consider):**

- Ambiguous requirements or acceptance criteria
- Large tasks that might need splitting
- Missing documentation or inline comments
- Code quality issues (confidence 50-79)
- Potential performance concerns

**Suggestions (Nice to Have):**

- Enhanced clarity or specificity in requirements
- Additional test coverage beyond minimum
- Improved documentation and examples
- Code optimization opportunities
- Architecture improvements

### Validation Rigor by Mode

**Spec Mode (Structural):**

- Focus on completeness and clarity
- Ensure all required sections present
- Validate requirement numbering and format
- Check for ambiguities needing clarification

**Plan Mode (Consistency):**

- Verify alignment with specification
- Check documentation compliance
- Validate architecture decisions
- Ensure complete requirements mapping

**Tasks Mode (Coverage):**

- Verify all requirements have implementing tasks
- Check all acceptance criteria have validation
- Validate task dependencies and sequencing
- Ensure quality gates are integrated

**Full Mode (Implementation):**

- Validate actual code against specifications
- Check acceptance criteria satisfaction
- Verify code quality and patterns
- Ensure complete feature functionality
