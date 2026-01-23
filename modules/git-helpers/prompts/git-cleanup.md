# Git Cleanup Agent

Clean up merged branches and stale references to keep repository organized.

## Arguments

- `--dry-run` - Show what would be deleted without actually deleting
- `--force` - Skip confirmation prompts
- `--remote` - Also clean up remote tracking branches

## Process

1. **Gather repository state**:

   ```bash
   git branch --show-current
   git fetch --prune
   git branch --merged
   git branch -r --merged
   ```

2. **Identify branches to clean**:
   - **Local merged branches**: `git branch --merged` excluding protected branches
   - **Remote tracking branches**: `git branch -r --merged` if `--remote` flag used
   - **Stale references**: Already handled by `git fetch --prune`

3. **Protected branches** (never delete):
   - `main`, `master`, `develop`, `dev`
   - Current branch
   - Any branch matching pattern: `release/*`, `hotfix/*`

4. **Show cleanup summary**:

   ```
   Branches to clean up:

   Local merged branches:
   feature/old-feature (merged 5 days ago)
   bugfix/minor-fix (merged 2 days ago)

   Remote tracking branches: (if --remote used)
   origin/feature/completed-task (merged 1 week ago)

   Protected (will skip):
   main (protected)
   develop (protected)
   feature/current-work (current branch)
   ```

5. **Confirmation and cleanup**:
   - Show confirmation unless `--force` used
   - Delete branches one by one with status
   - Report final cleanup summary

## Cleanup Actions

### Local Branches

```bash
# For each merged branch (excluding protected)
git branch -d ${BRANCH_NAME}
```

### Remote Tracking Branches (if --remote)

```bash
# For each stale remote tracking branch
git branch -dr ${REMOTE_BRANCH}
```

### Additional Cleanup

```bash
# Remove stale remote references (already done by fetch --prune)
git remote prune origin

# Clean up reflog (optional, conservative)
git reflog expire --expire=30.days --all
git gc --prune=30.days.ago
```

## Output Format

### Dry Run

```
Git Cleanup (DRY RUN)

Would delete 3 local branches:
  - feature/old-feature (merged 5 days ago)
  - bugfix/minor-fix (merged 2 days ago)
  - task/completed-item (merged 1 week ago)

Would delete 2 remote tracking branches:
  - origin/feature/done-task (merged 3 days ago)
  - origin/bugfix/resolved (merged 1 week ago)

Protected branches (skipped): main, develop, feature/current-work

Run without --dry-run to execute cleanup.
```

### Actual Cleanup

```
Git Cleanup Complete

Deleted 3 local branches:
  - feature/old-feature
  - bugfix/minor-fix
  - task/completed-item

Deleted 2 remote tracking branches:
  - origin/feature/done-task
  - origin/bugfix/resolved

Protected 3 branches: main, develop, feature/current-work

Repository cleaned up successfully!
```

## Safety Features

- **Always fetch first**: Ensure we have latest remote state
- **Merged-only**: Only delete branches that are fully merged
- **Protected patterns**: Never delete important branches
- **Confirmation**: Ask before deleting (unless --force)
- **Detailed logging**: Show what was deleted and why

## Error Handling

- **Not in git repository**: Show error and exit
- **Network issues**: Continue with local cleanup only
- **Branch deletion fails**: Show error but continue with others
- **No branches to clean**: Show "Repository already clean" message
