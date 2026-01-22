# Git Hotfix Agent

Create hotfix using git worktree for isolated emergency fixes without disrupting current work.

## Arguments

- `<description>` - Brief hotfix description (required)
- `--from <branch>` - Source branch for hotfix (default: main)

## Process

1. **Validate environment**:

   ```bash
   git status --porcelain
   git branch --show-current
   ```

   - Warn if current branch has uncommitted changes
   - Show current branch for context

2. **Determine source branch**:
   - Use `--from` argument if provided
   - Otherwise detect main branch: `git symbolic-ref refs/remotes/origin/HEAD` or fallback to `main`

3. **Create worktree**:

   ```bash
   # Generate unique name
   TIMESTAMP=$(date +%Y%m%d-%H%M%S)
   WORKTREE_NAME="hotfix-${TIMESTAMP}"
   WORKTREE_PATH="../${WORKTREE_NAME}"

   # Create worktree from source branch
   git worktree add ${WORKTREE_PATH} ${SOURCE_BRANCH}
   ```

4. **Setup hotfix branch**:

   ```bash
   cd ${WORKTREE_PATH}

   # Create hotfix branch
   HOTFIX_BRANCH="hotfix/${description//[^a-zA-Z0-9]/-}"
   git checkout -b ${HOTFIX_BRANCH}
   ```

5. **Guide user**:
   - Show worktree location and branch name
   - Provide instructions for making changes
   - Explain cleanup process

## Output Format

```
🔥 Hotfix worktree created:
   Location: ../hotfix-20250121-190033
   Branch: hotfix/fix-critical-bug
   Source: main

📝 Next steps:
   1. cd ../hotfix-20250121-190033
   2. Make your hotfix changes
   3. git add . && git commit -m "hotfix: fix critical bug"
   4. git push origin hotfix/fix-critical-bug
   5. Create MR in GitLab
   6. After merge, run: git worktree remove ../hotfix-20250121-190033

💡 Your current work in the main directory remains untouched.
```

## Cleanup Instructions

After hotfix is merged:

```bash
# Remove worktree
git worktree remove ../hotfix-20250121-190033

# Delete local hotfix branch (if needed)
git branch -d hotfix/fix-critical-bug

# Update main branch
git checkout main
git pull origin main
```

## Error Handling

- **No description provided**: Show usage and exit
- **Invalid source branch**: List available branches and exit
- **Worktree path exists**: Generate alternative name with suffix
- **Git worktree not supported**: Show git version requirements (>= 2.5)
