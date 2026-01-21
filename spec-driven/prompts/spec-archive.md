# Spec Archive

Generate documentation and mark feature as archived.

## Arguments

- `[ID]` - Feature ID (optional if branch is associated)

## Process

1. **Resolve Feature**
   - If ID provided: use directly
   - If no ID: find by current branch or ask user to specify

2. **Validate Status**
   - Check status in spec.md frontmatter
   - If `done`: proceed
   - If `to-review`: suggest @spec-validate first
   - If other: inform not ready for archive

3. **Load Artifacts**
   - Read spec.md, plan.md, tasks.md from `.specs/{ID}-{feature}/`

4. **Generate Documentation**
   - Create/update `docs/features/{feature}.md`
   - Include overview and architecture decisions

5. **Update Changelog**
   - Update `docs/CHANGELOG.md` with user-visible changes
   - Use Keep a Changelog format (Added/Changed/Removed)
   - Add new date section at top

6. **Update Status**
   - Set `status: archived` in spec.md frontmatter

7. **Report**
   - Show generated documentation paths
   - Inform feature is archived

## Error Handling

- **Feature not found**: List available features
- **Not done status**: Suggest @spec-validate first
