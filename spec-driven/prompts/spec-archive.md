# Spec Archive Agent

Generate permanent documentation and mark feature as archived after successful completion.

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

### Step 2: Validate Feature Completion

**Load and validate artifacts:**

- **`spec.md`**: Check status is `done` or `to-review`
- **`plan.md`**: Extract architecture decisions and key choices
- **`tasks.md`**: Verify all tasks are completed (`- [x]`)

**Completion checks:**

- All tasks marked as completed
- Feature status indicates completion
- Implementation appears finished

**If not ready for archiving:**

- If status is `to-review`: suggest `@spec-validate` first
- If tasks incomplete: suggest `@spec-implement` to finish
- If other status: inform not ready for archive
- Exit process

### Step 3: Extract Documentation Content

**From `spec.md`:**

- Feature overview and purpose
- Key functional requirements summary
- Important acceptance criteria
- Business value and scope

**From `plan.md`:**

- Architecture decisions and rationale
- Key implementation choices
- Component design and responsibilities
- Integration points and data flow
- Technical considerations and constraints

**From `tasks.md`:**

- Task completion statistics
- Implementation categories and effort
- Quality gates and validation results

### Step 4: Determine Documentation Strategy

**Analyze feature for documentation placement:**

- Check if feature relates to existing documentation in `docs/features/`
- Examples:
  - "add-2fa" relates to existing "auth.md"
  - "user-registration" relates to existing "user-management.md"
  - "payment-integration" might need new "payments.md"

**Documentation strategy:**

- **Update existing**: If feature extends existing functionality
- **Create new**: If feature introduces new domain or major capability

### Step 5: Generate Feature Documentation

**Create or update `docs/features/{feature}.md`:**

```markdown
# {Feature Title}

## Overview

{purpose_and_scope_from_spec}

## Business Value

- {key_business_benefits}
- {user_impact_summary}
- {problem_solved}

## Architecture

### Key Decisions

**{Decision Category}**: {decision_made}

- **Rationale**: {why_this_approach}
- **Alternatives Considered**: {other_options_and_why_rejected}
- **Impact**: {consequences_and_benefits}

### Component Design

| Component       | Responsibility | Location    |
| --------------- | -------------- | ----------- |
| {ComponentName} | {what_it_does} | {file_path} |

### Data Flow

{high_level_data_flow_description}

### Integration Points

- **{External System}**: {how_integrated}
- **{Internal Component}**: {integration_method}

## Implementation

### Key Requirements Delivered

- **FR-001**: {requirement_summary}
- **FR-002**: {requirement_summary}

### Technical Highlights

- {notable_implementation_detail}
- {performance_or_security_consideration}
- {innovative_solution_or_pattern}

### Quality Metrics

- **Tasks Completed**: {completed_count}/{total_count}
- **Quality Gates**: All passed (lint, typecheck, tests)

## Usage

### API/Interface

{public_interfaces_and_usage_examples}

### Configuration

{configuration_options_and_settings}

## Maintenance

### Known Limitations

- {limitation_1}
- {limitation_2}

### Future Enhancements

- {potential_improvement_1}
- {potential_improvement_2}

### Dependencies

- **External**: {external_dependencies}
- **Internal**: {internal_component_dependencies}

---

_Archived: {date} | Spec: .specs/{ID}-{feature}/_
```

### Step 6: Update Centralized Changelog

**Update or create `docs/CHANGELOG.md` using Keep a Changelog format:**

**If file doesn't exist, create with:**

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [{date}] - {Feature Title}

### Added

- {user_visible_addition_1}
- {user_visible_addition_2}

### Changed

- {user_visible_change_1}
- {user_visible_change_2}

### Fixed

- {user_visible_fix_1}
- {user_visible_fix_2}

_Feature: {ID}-{feature} | Completed: {date}_
```

**If file exists, add entry at top:**

```markdown
## [{date}] - {Feature Title}

### Added

- {user_visible_addition_1}
- {user_visible_addition_2}

### Changed

- {user_visible_change_1}

### Fixed

- {user_visible_fix_1}

_Feature: {ID}-{feature} | Completed: {date}_
```

### Step 7: Update Feature Status

**Update `spec.md` frontmatter:**

- Change `status: done` to `status: archived`
- Add `archived: {YYYY-MM-DD}` field
- Preserve all other metadata (id, feature, type, branch, created)

### Step 8: Report Archive Completion

**Archive completion report:**

- **Feature archived**: {ID}-{feature}
- **Documentation created**: docs/features/{feature}.md
- **Changelog updated**: docs/CHANGELOG.md
- **Status updated**: spec.md marked as archived
- **Knowledge preserved**: Key decisions and patterns documented
- **Traceability maintained**: Links to original specifications

## Documentation Quality Standards

### Feature Documentation Quality

**Architecture Section:**

- Clear rationale for major decisions
- Alternatives considered and why rejected
- Impact and consequences documented
- Reusable patterns highlighted

**Implementation Section:**

- Key requirements mapped to deliverables
- Technical highlights and innovations
- Quality metrics and validation results
- Public interfaces and usage examples

**Maintenance Section:**

- Known limitations honestly documented
- Future enhancement opportunities identified
- Dependencies clearly listed

### Changelog Quality

**Entry Content:**

- Focus on user-visible changes
- Business value and impact
- Clear categorization (Added/Changed/Fixed)
- Completion date and feature reference

**Organization:**

- Chronological order (newest first)
- Consistent formatting using Keep a Changelog format
- Clear categorization by change type
- Easy scanning and reference

## Archive Guidelines

### When to Archive

**Ready for archiving:**

- Feature status is `done`
- All tasks completed successfully
- Implementation validated and tested
- Quality gates passed

**Not ready for archiving:**

- Status is `to-review` (suggest `@spec-validate` first)
- Tasks still pending or in progress
- Implementation issues unresolved
- Quality gates failing

### Documentation Scope

**Include in documentation:**

- Key architecture decisions and rationale
- Reusable patterns and components
- Integration approaches and lessons learned
- Business value and user impact
- Technical innovations and achievements

**Exclude from documentation:**

- Implementation details better left in code
- Temporary workarounds or hacks
- Internal development process details
- Sensitive or security-related information

## Error Handling

- **Feature not found**: List available features or suggest `@spec-init`
- **Status not done**: Suggest appropriate next step (`@spec-validate`, `@spec-implement`)
- **Missing artifacts**: Inform which files are missing and suggest regenerating
- **Documentation conflicts**: Ask user how to handle existing documentation
