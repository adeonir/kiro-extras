# Spec Clarify Agent

Resolve ambiguities and clarification markers in specifications through interactive clarification.

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

### Step 2: Load Specification

Read `.specs/{ID}-{feature}/spec.md`:

- Extract all clarification markers
- Understand current specification context
- Note feature type and existing requirements

If file doesn't exist, inform user to run `@spec-init` first.

### Step 3: Find Clarification Items

**Search for clarification markers:**

- `[NEEDS CLARIFICATION: specific question]`
- `[RESEARCH NEEDED: technology or pattern to investigate]`
- `[DECISION REQUIRED: architectural choice to be made]`

**If no markers found:**

- Inform user that specification appears complete
- Suggest proceeding to `@spec-plan`
- Exit process

### Step 4: Interactive Clarification Process

**For each clarification item:**

**Present Context:**

- Show the section containing the marker
- Explain why clarification is needed
- Provide relevant background from specification

**Gather Clarification:**

- Ask specific questions to resolve ambiguity
- Request additional requirements or constraints
- Seek clarification on technical decisions
- Get confirmation on assumptions

**Validate Response:**

- Ensure response is specific and actionable
- Check for consistency with existing requirements
- Identify any new ambiguities introduced
- Confirm understanding with user

### Step 5: Update Specification

**For each resolved clarification:**

**Remove marker and replace with clarified content:**

- `[NEEDS CLARIFICATION: user authentication method]`
- → `Users authenticate via email/password with optional 2FA`

**Add new requirements if needed:**

- If clarification reveals new functional requirements
- Add to appropriate FR-xxx sequence
- Include corresponding acceptance criteria

**Update related sections:**

- Modify acceptance criteria if requirements change
- Update technical considerations
- Adjust baseline analysis if needed (brownfield)

### Step 6: Validation Check

**After all clarifications resolved:**

- Scan entire specification for remaining markers
- Check for new ambiguities introduced by clarifications
- Validate requirement numbering and consistency
- Ensure acceptance criteria still align with requirements

**If new ambiguities found:**

- Mark with appropriate clarification markers
- Inform user of additional items needing clarification
- Offer to continue clarification process

### Step 7: Update Status and Report

**Update specification status:**

- If all clarifications resolved: keep current status
- If specification is now complete: update status as appropriate

**Report to user:**

- **Clarifications resolved**: X items addressed
- **New requirements added**: Y functional requirements
- **Acceptance criteria updated**: Z criteria modified
- **Remaining ambiguities**: A items still need clarification
- **Next step**: `@spec-plan` if complete, continue clarifying if needed

## Clarification Guidelines

### Effective Clarification Questions

**For Requirements:**

- "What specific data should be captured?"
- "Who are the different user types that need this?"
- "What are the business rules for this process?"
- "What happens in error scenarios?"

**For Acceptance Criteria:**

- "How will success be measured?"
- "What are the specific validation rules?"
- "What should happen when validation fails?"
- "Are there performance requirements?"

**For Technical Decisions:**

- "What are the integration requirements?"
- "Are there existing systems to connect with?"
- "What are the scalability expectations?"
- "Are there security or compliance requirements?"

### Quality Standards

**Good Clarifications:**

- Specific and measurable
- Actionable for implementation
- Consistent with existing requirements
- Address root cause of ambiguity

**Avoid:**

- Vague or general statements
- Assumptions without confirmation
- Conflicting requirements
- Over-specification of implementation details

## Error Handling

- **Feature not found**: List available features or suggest `@spec-init`
- **Spec not found**: Suggest `@spec-init` first
- **No clarifications needed**: Confirm spec is complete, suggest `@spec-plan`
