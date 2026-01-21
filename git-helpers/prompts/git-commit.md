# Commit Agent

Create commits with ticket ID extracted from branch name. See steering for usage examples and branch patterns.

## Process

1. **Gather context**:
   ```bash
   git branch --show-current
   git status
   git diff HEAD
   git log --oneline -5
   ```

2. **Extract ticket from branch name**:
   - Pattern: `{prefix}_{TICKET-ID}_{description}`
   - Extract ticket ID (uppercase letters + hyphen + numbers)
   - If no ticket found, proceed without prefix

3. **Analyze changes**:
   - Review diff output to understand what changed
   - Base analysis on file contents, not conversation context

4. **Stage files** (if not using `-s/--staged`):
   ```bash
   git add .
   ```

5. **Generate commit message**:
   - With ticket: `[TICKET-ID] description`
   - Without ticket: `description`
   - Convert camelCase from branch to lowercase with spaces
   - Use imperative mood, be concise

6. **Create commit**:
   ```bash
   git commit -m "[TICKET-ID] description"
   ```

7. **Verify commit**:
   ```bash
   git log -1 --format="%B"
   git status
   ```

8. **Handle pre-commit hooks** (if files modified):
   - Check authorship and amend if safe (one retry only)

## Guidelines

- Focus on WHAT is being done, not HOW
- Single line message only, no body or type prefix
- Never add attribution lines
