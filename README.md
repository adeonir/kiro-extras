# kiro-extras

Custom prompts for Kiro CLI with git workflow helpers and specification-driven development.

## Available Prompts

### git-helpers

Git workflow helper prompts with confidence-scored code review and test coverage analysis.

| Prompt        | Description                                            |
| ------------- | ------------------------------------------------------ |
| `git-commit`  | Create commits with ticket ID from branch name         |
| `git-review`  | Review changes with confidence scoring + test coverage |
| `git-summary` | Generate MR description to file                        |
| `git-hotfix`  | Create emergency hotfix using git worktree             |
| `git-cleanup` | Clean up merged branches and stale references          |

**Workflow:**

```
@git-review --> @git-commit --> @git-summary
```

**Branch pattern for commits:** `{prefix}_{TICKET-ID}_{description}`

- `ab_XYZ-1234_fixSomething` -> `[XYZ-1234] fix something`

### setup

Project initialization and steering file management with automatic project analysis.

| Prompt          | Description                                                     |
| --------------- | --------------------------------------------------------------- |
| `steer-init`    | Analyze project and generate essential steering files           |
| `steer-analyze` | Generate project-specific steering files from codebase patterns |

**Workflow:**

```
@steer-init --> @steer-analyze --> Review/Customize --> @spec-init --> Development
```

### spec-driven

Specification-driven development workflow with brownfield support.

| Prompt           | Description                                               |
| ---------------- | --------------------------------------------------------- |
| `spec-init`      | Create specification (auto-detects greenfield/brownfield) |
| `spec-clarify`   | Resolve ambiguities marked [NEEDS CLARIFICATION]          |
| `spec-plan`      | Research, explore codebase, generate technical plan       |
| `spec-tasks`     | Generate task list from plan                              |
| `spec-implement` | Execute tasks (T001, T001-T005, --all)                    |
| `spec-validate`  | Validate artifacts at any phase                           |
| `spec-archive`   | Generate documentation and mark as archived               |
| `spec-list`      | List all features by status                               |

**Workflow:**

```
@spec-init --> @spec-clarify --> @spec-plan --> @spec-tasks --> @spec-implement --> @spec-validate --> @spec-archive
```

## Installation

### Option 1: Install All Modules

```bash
# Global installation (default)
./install/all.sh

# Project-level installation
./install/all.sh --project
```

### Option 2: Install Individual Modules

```bash
# Setup module (steering file generation)
./install/setup.sh
./install/setup.sh --project

# Git helpers module
./install/git-helpers.sh
./install/git-helpers.sh --project

# Spec-driven module
./install/spec-driven.sh
./install/spec-driven.sh --project
```

## Requirements

### git-helpers

No external dependencies.

### spec-driven

- `uvx` (uv tool runner) for Serena MCP server
- Install uv: `curl -LsSf https://astral.sh/uv/install.sh | sh`

## Usage

After installation, use prompts directly in Kiro:

### git-helpers

```bash
@git-commit              # Create commit with ticket from branch name
@git-commit -s           # Commit only staged files

@git-review              # Review changes + test coverage in terminal
@git-review main         # Compare against main branch
@git-review --save       # Save to CODE_REVIEW.md

@git-summary             # Generate MR_DETAILS.md

@git-hotfix "fix critical bug"     # Create emergency hotfix with worktree
@git-hotfix "urgent fix" --from develop  # Create from specific branch

@git-cleanup             # Clean up merged branches interactively
@git-cleanup --dry-run   # Show what would be deleted
@git-cleanup --force     # Skip confirmations
```

### spec-driven

**Prompts** (all operations):

```bash
@spec-init add user authentication   # Create specification
@spec-clarify                        # Resolve [NEEDS CLARIFICATION] items
@spec-plan                           # Generate technical plan
@spec-tasks                          # Generate task list
@spec-implement                      # Execute next pending task
@spec-implement T001                 # Execute single task
@spec-implement T001-T005            # Execute task range
@spec-implement --all                # Execute all tasks
@spec-validate                       # Validate implementation
@spec-archive                        # Generate docs and mark as archived
@spec-list                           # List all features by status
```

**Workflow:**

```
@spec-init --> @spec-clarify --> @spec-plan --> @spec-tasks --> @spec-implement --> @spec-validate --> @spec-archive
```

## MCP Server Configuration

The spec-driven workflow uses Serena MCP for semantic code operations.

If you installed at project level, the MCP config is at `.kiro/settings/mcp.json`.

For global installation, add to `~/.kiro/settings/mcp.json`:

```json
{
  "mcpServers": {
    "serena": {
      "command": "uvx",
      "args": [
        "--from",
        "git+https://github.com/oraios/serena",
        "serena",
        "start-mcp-server",
        "--enable-web-dashboard",
        "false"
      ]
    }
  }
}
```

## Directory Structure

```
kiro-extras/
  git-helpers/
    prompts/
      git-commit.md
      git-review.md
      git-summary.md
      git-hotfix.md
      git-cleanup.md
    steering/
      git-helpers.md
  setup/
    prompts/
      steer-init.md
      steer-analyze.md
    steering/
      setup.md
  spec-driven/
    prompts/
      spec-init.md
      spec-clarify.md
      spec-plan.md
      spec-tasks.md
      spec-implement.md
      spec-validate.md
      spec-archive.md
      spec-list.md
    steering/
      spec-driven.md
    settings/
      mcp.json
```

## License

MIT

## Credits

Based on [claude-code-extras](https://github.com/adeonir/claude-code-extras) workflows.
