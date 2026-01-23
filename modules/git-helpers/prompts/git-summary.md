# MR Details Agent

Generate comprehensive Merge Request title and description, save to `MR_DETAILS.md`.

## Arguments

User may specify:

- No argument: Auto-detect base branch (main > master > develop > development)
- `base-branch`: Use specified branch as base for comparison

## Process

1. **Determine base branch**:
   - If provided: use specified branch
   - If not: auto-detect in order: `main` -> `master` -> `develop` -> `development`
   - Validate branch exists locally

2. **Gather comprehensive git context**:

   ```bash
   git branch --show-current
   git diff {base}...HEAD --stat
   git diff {base}...HEAD --name-status
   git log {base}..HEAD --oneline --format="%h %s"
   git diff {base}...HEAD
   ```

3. **Extract ticket information**:
   - **Branch pattern**: `{prefix}_{TICKET-ID}_{description}`
   - **Ticket format**: Uppercase letters + hyphen + numbers
   - **Examples**:
     - `ab_XYZ-1234_fixSomething` → `XYZ-1234`
     - `xy_ABC-567_addNewFeature` → `ABC-567`
   - **Fallback**: Scan commit messages for ticket references
   - If no ticket found, proceed without prefix

4. **Analyze changes comprehensively**:
   - **Commit analysis**: Review all commits for logical grouping
   - **File analysis**: Categorize added, modified, deleted files
   - **Code analysis**: Understand functional changes from diff
   - **Impact assessment**: User-facing vs internal changes
   - **Change patterns**: Feature, bugfix, refactor, documentation

5. **Generate MR title**:
   - **Format**: `[TICKET-ID] brief description` or `brief description`
   - **Style**: Lowercase, imperative mood
   - **Length**: Keep under 72 characters for git compatibility
   - **Examples**:
     - `[XYZ-1234] fix login button responsiveness`
     - `[ABC-567] add user profile management`
     - `update API documentation for v2 endpoints`

6. **Generate structured description**:

   **Summary Section** (User/Product Perspective):
   - Present tense: adds, fixes, improves, removes
   - Business value and user impact
   - What problem this solves or feature it provides
   - Non-technical language

   **Changes Section** (Developer/Technical Perspective):
   - Past tense, lowercase: added, refactored, updated
   - Organize by area/component when multiple areas affected (GraphQL, State Management, API, Tests, etc.)
   - Use simple list for single-area changes
   - Technical implementation details
   - File-level and architectural changes
   - Code structure modifications

   **Technical Details Section** (Optional):
   - Implementation notes and architectural decisions
   - Performance considerations
   - Design patterns used
   - Important technical context

   **Notes Section** (Optional):
   - Breaking changes or migration requirements
   - Dependencies or deployment considerations
   - Known limitations or follow-up work
   - Important reviewer considerations

   **Screenshots Section** (Optional):
   - Only for UI/visual changes
   - Before/after comparison table
   - Placeholder for image URLs

7. **Write to MR_DETAILS.md**:

   ```markdown
   # [TICKET-ID] Brief description

   ## Summary

   - User-focused description of what this adds/fixes/improves
   - Business value and impact explanation
   - Problem solved or feature provided

   ## Changes

   - technical change 1 (past tense, lowercase)
   - technical change 2 (past tense, lowercase)
   - architectural or structural modifications

   OR (when multiple areas affected):

   **Component/Area Name**

   - technical change 1 (past tense, lowercase)
   - technical change 2 (past tense, lowercase)

   **Another Component/Area**

   - architectural or structural modifications
   - file-level changes with context

   ## Technical Details

   > Only include if implementation notes needed

   - Implementation approach and architectural decisions
   - Performance considerations or optimizations
   - Design patterns or technical context

   ## Notes

   > Only include if extra context needed

   Additional explanations, migration steps, or reviewer notes.

   ## Screenshots

   > Only include for visual changes

   | Before         | After         |
   | -------------- | ------------- |
   | ![before](url) | ![after](url) |
   ```

8. **Validate and confirm**:
   - Check title length (< 72 characters)
   - Verify all major changes are covered
   - Ensure summary explains user value
   - Confirm technical accuracy
   - Display file location and brief summary

## Content Guidelines

### Title Generation

- **Maximum 72 characters** for git compatibility
- **Imperative mood**: "add", "fix", "update", "remove"
- **Lowercase**: Convert camelCase from branch names
- **Specific but concise**: Capture the main change
- **Examples**:
  - Branch: `feature_AUTH-123_addTwoFactorAuth` → `[AUTH-123] add two-factor authentication`
  - Branch: `bugfix_PAY-456_fixValidation` → `[PAY-456] fix payment validation`

### Summary Section (User Value)

- **Present tense**: "Adds", "Fixes", "Improves", "Removes"
- **User perspective**: What the user gains or experiences
- **Business impact**: Why this change matters
- **Problem-solution**: What issue this resolves
- **Examples**:
  - "Adds two-factor authentication to improve account security"
  - "Fixes payment flow to prevent transaction failures"
  - "Improves dashboard loading speed by 60%"
  - "Updated AuthService.ts and added middleware"

### Changes Section (Technical Details)

- **Past tense, lowercase**: "added", "refactored", "updated"
- **Organization**: Use simple list for single-area changes; group by component/area when multiple areas affected
- **Technical specifics**: Implementation details
- **File/architecture changes**: What was built or modified
- **Code structure**: How the solution was implemented
- **Examples (simple)**:
  - "added JWT token validation middleware"
  - "refactored user service to use repository pattern"
  - "updated database schema for user preferences"
- **Examples (grouped)**:
  - **Authentication**: "added JWT token validation middleware"
  - **User Service**: "refactored user service to use repository pattern"
  - **Database**: "updated schema for user preferences"
  - **Performance**: "implemented caching layer for dashboard queries"

### Technical Details Section (Optional)

- **Implementation notes**: Architectural decisions and approach
- **Performance considerations**: Optimizations or trade-offs
- **Design patterns**: Patterns used and why
- **Technical context**: Important background for reviewers
- **Examples**:
  - "Application ID is fetched once during initialization, avoiding repeated calls"
  - "Uses optional chaining to safely handle empty arrays"
  - "Validates application ID exists before making requests"

## Change Detection Patterns

**Feature Addition**:

- New files, functions, classes, components
- New API endpoints or routes
- New UI elements or pages
- New configuration options

**Bug Fixes**:

- Error handling improvements
- Validation corrections
- Logic fixes and edge cases
- Performance optimizations

**Refactoring**:

- Code structure improvements
- Dependency updates
- Architecture changes
- Test enhancements

**Documentation**:

- README updates
- Code comments
- API documentation
- Configuration examples

## Quality Assurance

**Before writing MR_DETAILS.md**:

- All significant changes covered in Changes section
- Summary clearly explains user/business value
- Title is concise and under 72 characters
- Technical details match actual code changes
- Ticket ID format is correct (if present)
- File paths and function names are accurate
- Appropriate sections included (skip empty ones)

**After writing**:

- Display file location: `MR_DETAILS.md`
- Show title and character count
- Summarize key points covered
- Suggest improvements if needed
