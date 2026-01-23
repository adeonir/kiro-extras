# Git Commit Agent

Create commits with ticket ID extracted from branch name following project conventions.

## Arguments

- No args: Stage all files and commit
- `-s` or `--staged`: Commit only staged files (skip `git add .`)

## Process

1. **Gather git context**:

   ```bash
   git branch --show-current
   git status --porcelain
   git diff HEAD
   git log --oneline -5
   ```

2. **Extract ticket from branch name**:
   - **Pattern**: `{prefix}_{TICKET-ID}_{description}`
   - **Ticket format**: Uppercase letters + hyphen + numbers (e.g., `XYZ-1234`, `ABC-567`)
   - **Examples**:
     - `ab_XYZ-1234_fixSomething` → Extract `XYZ-1234`
     - `feature_PROJ-99_updateDocs` → Extract `PROJ-99`
     - `main` → No ticket found
   - If no valid ticket pattern found, proceed without prefix

3. **Validate working directory**:
   - Check `git status --porcelain` for changes
   - If no changes and no staged files: inform user and exit
   - If files to commit: proceed

4. **Stage files** (unless `-s/--staged` flag):

   ```bash
   git add .
   ```

   - Skip if `--staged` flag provided
   - Verify files are staged before committing

5. **Analyze changes for commit message**:
   - Read `git diff --cached` to understand staged changes
   - Focus on WHAT is being done, not HOW
   - Base message on actual file changes, not conversation context
   - Look for patterns: new files, modifications, deletions, renames

6. **Generate commit message**:
   - **With ticket**: `[TICKET-ID] description`
   - **Without ticket**: `description`
   - **Description rules**:
     - Convert camelCase from branch to lowercase with spaces
     - Use imperative mood (add, fix, update, remove)
     - Be concise and specific
     - Single line only, no body or type prefix
     - Focus on user/business impact when possible

   **Examples**:
   - `[XYZ-1234] fix user authentication flow`
   - `[ABC-567] add user registration validation`
   - `update documentation for API endpoints`

7. **Create commit**:

   ```bash
   git commit -m "[TICKET-ID] description"
   ```

8. **Verify commit**:

   ```bash
   git log -1 --format="%B"
   git status --porcelain
   ```

   - Show the created commit message
   - Confirm working directory is clean

9. **Handle pre-commit hooks** (if files modified after commit):
   - Check if pre-commit hooks modified files
   - If authorship is safe and only one retry needed:
     ```bash
     git add .
     git commit --amend --no-edit
     ```
   - Maximum one retry to avoid infinite loops
   - Inform user of the amendment

## Message Generation Guidelines

**Focus Areas**:

- **User-facing changes**: "add user profile page", "fix login redirect"
- **Bug fixes**: "resolve null pointer in payment flow"
- **Features**: "implement two-factor authentication"
- **Infrastructure**: "update build configuration", "add error logging"

**Avoid**:

- Technical implementation details
- File-specific changes ("update UserService.ts")
- Vague descriptions ("fix issues", "update code")
- Type prefixes ("feat:", "fix:", "chore:")
- Attribution lines ("Co-authored-by")

**Imperative Mood Examples**:

- Good: "add user authentication"
- Good: "fix payment validation"
- Good: "update API documentation"
- Bad: "added user authentication"
- Bad: "fixing payment validation"
- Bad: "updating API documentation"

## Branch Pattern Examples

| Branch Name                   | Extracted Ticket | Commit Message             |
| ----------------------------- | ---------------- | -------------------------- |
| `ab_XYZ-1234_fixSomething`    | `XYZ-1234`       | `[XYZ-1234] fix something` |
| `xy_ABC-567_addUserAuth`      | `ABC-567`        | `[ABC-567] add user auth`  |
| `feature_PROJ-99_updateDocs`  | `PROJ-99`        | `[PROJ-99] update docs`    |
| `bugfix_TRU-456_resolveLogin` | `TRU-456`        | `[TRU-456] resolve login`  |
| `main`                        | None             | `resolve merge conflicts`  |
| `develop`                     | None             | `update dependencies`      |

## Error Handling

- **No changes to commit**: Inform user, suggest `git status`
- **Merge conflicts**: Detect and inform user to resolve first
- **Pre-commit hook failures**: Show error, don't retry automatically
- **Invalid branch name**: Proceed without ticket prefix
- **Staging failures**: Show git error, don't proceed with commit

## Guidelines

- **Single responsibility**: One logical change per commit
- **Atomic commits**: Complete, working changes only
- **Clear messages**: Describe the change's purpose and impact
- **Consistent format**: Follow project's ticket ID conventions
- **No attribution**: Never add "Co-authored-by" or similar lines
