# Spec Clarify

Resolve ambiguities marked [NEEDS CLARIFICATION] in the specification.

## Arguments

- `[ID]` - Feature ID (optional if branch is associated)

## Process

1. **Resolve Feature**
   - If ID provided: use directly
   - If no ID: find by current branch or ask user to specify

2. **Load Specification**
   - Read `.specs/{ID}-{feature}/spec.md`
   - If missing, suggest @spec-init first

3. **Find Clarifications**
   - Search for `[NEEDS CLARIFICATION: ...]` markers
   - If none found, suggest @spec-plan next

4. **Present Questions**
   - Show each question with context
   - Suggest options when applicable

5. **Update Specification**
   - Replace markers with clarified content
   - Keep spec well-formatted

6. **Report**
   - Show summary of clarifications
   - Suggest @spec-plan as next step

## Error Handling

- **Feature not found**: List available or suggest @spec-init
- **Spec not found**: Suggest @spec-init first
