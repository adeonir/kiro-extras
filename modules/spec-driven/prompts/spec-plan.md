# Spec Plan Agent

Conduct comprehensive codebase analysis and create detailed technical implementation plan.

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

### Step 2: Load Specification Context

Read `.specs/{ID}-{feature}/spec.md`:

- Extract all FR-xxx functional requirements
- Understand feature scope and acceptance criteria
- Note type (greenfield/brownfield) and baseline information
- Identify technical considerations and constraints

If file doesn't exist, inform user to run `@spec-init` first.

### Step 3: Check for Clarifications

Search for `[NEEDS CLARIFICATION]` markers in the spec.

If found:

- List all items needing clarification
- Suggest running `@spec-clarify` first
- Exit (cannot plan with unclear requirements)

### Step 4: Research External Technologies

Determine if web research is needed:

1. User provided additional research instructions
2. Spec mentions external technologies, libraries, APIs, services
3. Spec references standards or protocols needing verification
4. Complex integrations requiring best practices

**Research Process:**

- Check if `docs/research/{topic}.md` already exists and is recent
- If exists and current: use existing research
- If outdated or missing: conduct web search for:
  - Official documentation and guides
  - Best practices and recommended patterns
  - Known issues, gotchas, or deprecations
  - Version compatibility and migration notes
  - Security considerations
- Save findings to `docs/research/{topic}.md` for reuse

### Step 5: Comprehensive Codebase Exploration

**Documentation Discovery:**

- Search for README.md files in directories related to the feature
- Look for architecture docs in `docs/`, `.docs/`, `architecture/`
- Find diagrams: mermaid blocks in .md files, `.dbml`, `.puml`, `.drawio`
- Check for related specs in `.specs/` that might inform this feature
- Review `CLAUDE.md` and `.kiro/steering/*.md` for project conventions

**Feature Discovery and Analysis:**

- Find entry points (APIs, UI components, CLI commands)
- Locate similar existing features for pattern reference
- Map feature boundaries and configuration points
- Identify integration points and dependencies

**Code Flow Tracing:**

- Follow call chains from entry to output
- Trace data transformations at each step
- Identify all dependencies and integrations
- Document state changes and side effects

**Architecture Analysis:**

- Map abstraction layers (presentation → business logic → data)
- Identify design patterns and architectural decisions
- Document interfaces between components
- Note cross-cutting concerns (auth, logging, caching, error handling)

**Testing Pattern Discovery:**

- Find existing test files and patterns
- Identify testing frameworks and conventions
- Map test coverage approaches
- Document test data and fixture patterns

### Step 6: Critical Files Consolidation

**Reference Files (patterns to follow):**

- Files that demonstrate good patterns for this type of feature
- Examples of similar implementations to copy
- Configuration and setup examples

**Files to Modify:**

- Existing files that need changes for this feature
- Integration points that require updates
- Configuration files needing new entries

**Files to Create:**

- New components, services, or utilities needed
- Test files for new functionality
- Documentation files required

### Step 7: Requirements Mapping and Architecture Design

**Map each FR-xxx to implementation:**

- List all functional requirements from spec
- For each requirement, identify which component(s) will address it
- Specify what files need to be created/modified
- Map integration points and data flow
- Flag any requirements that cannot be mapped (gaps)

**Architecture Decision Making:**

- Based on discovered patterns, choose ONE approach
- Design component structure and responsibilities
- Plan integration with existing code following discovered patterns
- Define data flow and interfaces
- Consider error handling, testing, and security based on existing patterns

### Step 8: Generate Comprehensive Technical Plan

Create `.specs/{ID}-{feature}/plan.md`:

```markdown
# Technical Plan: {feature_name}

## Context

- Feature: {ID}-{feature}
- Created: {date}
- Spec: .specs/{ID}-{feature}/spec.md

## Research Summary

> From docs/research/{topic}.md (if applicable)

Key findings:

- {external_best_practice_1}
- {technology_consideration_1}
- {security_or_performance_insight}

## Documentation Context

> Sources reviewed: {list of READMEs, diagrams, specs consulted}

Key insights:

- {pattern_discovered_in_docs}
- {architectural_constraint_found}
- {implicit_requirement_from_diagrams}

## Critical Files

### Reference Files (patterns to follow)

| File   | Purpose                      | Key Patterns                |
| ------ | ---------------------------- | --------------------------- |
| {path} | {why this is a good example} | {specific patterns to copy} |

### Files to Modify

| File   | Changes Needed           | Reason              |
| ------ | ------------------------ | ------------------- |
| {path} | {specific modifications} | {why these changes} |

### Files to Create

| File   | Purpose               | Responsibility             |
| ------ | --------------------- | -------------------------- |
| {path} | {what this file does} | {specific role in feature} |

## Codebase Patterns

> Extracted from exploration with file:line references

**Architecture Style:** {pattern_name}

- {pattern_description_with_examples}

**Naming Conventions:**

- {convention_1}: {example_from_codebase}
- {convention_2}: {example_from_codebase}

**Error Handling Pattern:**

- {approach_used}: {file:line example}

**Testing Patterns:**

- {test_style}: {example_location}
- {fixture_approach}: {example_usage}

## Architecture Decision

**Chosen Approach:** {selected_solution}

**Rationale:**

- Follows existing {pattern} pattern found in {file}
- Integrates with {existing_component} via {interface}
- Supports {requirement} through {mechanism}
- Maintains consistency with {architectural_decision}

**Alternatives Considered:**

- {alternative_1}: Rejected because {reason}
- {alternative_2}: Rejected because {reason}

## Component Design

| Component | File   | Responsibility | Dependencies    |
| --------- | ------ | -------------- | --------------- |
| {name}    | {path} | {what it does} | {what it needs} |
| {name}    | {path} | {what it does} | {what it needs} |

## Implementation Map

### Phase 1: Foundation

- {file_to_create}: {purpose_and_basic_structure}
- {file_to_modify}: {specific_changes_needed}

### Phase 2: Core Logic

- {file_to_create}: {business_logic_implementation}
- {integration_point}: {how_to_connect_with_existing}

### Phase 3: Integration & Testing

- {file_to_modify}: {final_integration_changes}
- {test_files}: {testing_approach_and_coverage}

## Data Flow

**Entry Point:** {where_requests_start}
↓
**Validation:** {validation_layer_and_rules}
↓
**Business Logic:** {core_processing_components}
↓
**Data Layer:** {persistence_or_external_calls}
↓
**Response:** {output_format_and_transformation}

## Requirements Traceability

| Requirement   | Component   | Files        | Implementation Notes         |
| ------------- | ----------- | ------------ | ---------------------------- |
| FR-001: {req} | {component} | {file_paths} | {how_it_will_be_implemented} |
| FR-002: {req} | {component} | {file_paths} | {how_it_will_be_implemented} |

## Technical Considerations

**Error Handling:**

- {approach_based_on_existing_patterns}
- {specific_error_scenarios_to_handle}
- {logging_and_monitoring_strategy}

**Testing Strategy:**

- Unit tests: {approach_and_location}
- Integration tests: {scope_and_tools}
- {specific_test_cases_for_edge_cases}

**Security:**

- {authentication_approach}
- {authorization_requirements}
- {data_validation_and_sanitization}

**Performance:**

- {expected_load_and_optimization_needs}
- {caching_strategy_if_applicable}
- {database_query_optimization}

## Dependencies

**External:**

- {library_or_service}: {version_and_purpose}
- {api_or_integration}: {usage_and_constraints}

**Internal:**

- {existing_component}: {how_it_will_be_used}
- {shared_utility}: {integration_approach}

## Migration Notes (Brownfield Only)

**Breaking Changes:**

- {change_description}: {impact_and_mitigation_strategy}

**Deployment Sequence:**

1. {step_1_with_rationale}
2. {step_2_with_dependencies}
3. {step_3_with_validation}

## Open Questions

- [ ] {question_requiring_clarification}
- [ ] {technical_decision_needing_input}
- [ ] {external_dependency_to_confirm}
```

### Step 9: Validation and Quality Assurance

**Completeness Check:**

- ✅ All FR-xxx requirements mapped to components
- ✅ All components have clear responsibilities and file locations
- ✅ Data flow documented end-to-end
- ✅ Integration points identified and planned
- ✅ Error handling approach defined
- ✅ Testing strategy specified

**Documentation Verification:**

- ✅ All referenced documentation actually consulted
- ✅ Implementation decisions supported by codebase evidence
- ✅ Patterns match existing conventions exactly
- ✅ Data formats align with documented examples

**Architecture Validation:**

- ✅ Single, decisive approach chosen (no multiple options)
- ✅ Seamless integration with existing codebase
- ✅ Testable and maintainable design
- ✅ Performance and security considerations addressed

### Step 10: Update Status and Report

Update `.specs/{ID}-{feature}/spec.md` frontmatter: `status: ready`

Inform the user:

- **Research conducted**: {topics} (if applicable)
- **Plan created**: `.specs/{ID}-{feature}/plan.md`
- **Components designed**: X components
- **Files to create**: Y files
- **Files to modify**: Z files
- **Requirements coverage**: All FR-xxx mapped
- **Key architectural decisions**: {brief_summary}
- **Next step**: `@spec-tasks` to generate implementation task list

## Guidelines

- **Be decisive**: Choose ONE approach, don't present multiple options
- **Be specific**: Include exact file paths, function names, concrete steps
- **Be complete**: Cover all aspects needed for implementation
- **Follow conventions**: Match existing codebase patterns exactly
- **Think ahead**: Consider edge cases, error handling, testing, security
- **Document everything**: Every decision should have supporting evidence
- **Verify assumptions**: Check documentation and code, don't assume
- **Map all requirements**: Every FR-xxx must appear in traceability table
