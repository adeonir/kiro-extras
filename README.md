# kiro-extras

Custom agents for Kiro CLI migrated from Claude Code plugins.

## Available Agents

### git-helpers

Git workflow helper agents with confidence-scored code review and test coverage analysis.

| Agent          | Description                                            |
| -------------- | ------------------------------------------------------ |
| `@git-commit`  | Create commits with ticket ID from branch name         |
| `@git-review`  | Review changes with confidence scoring + test coverage |
| `@git-summary` | Generate MR description to file                        |

**Workflow:**

```
@git-review --> @git-commit --> @git-summary
```

**Branch pattern for commits:** `{prefix}_{TICKET-ID}_{description}`

- `ab_XYZ-1234_fixSomething` -> `[XYZ-1234] fix something`

### spec-driven

Specification-driven development workflow with brownfield support.

| Agent             | Description                                               |
| ----------------- | --------------------------------------------------------- |
| `@spec-init`      | Create specification (auto-detects greenfield/brownfield) |
| `@spec-clarify`   | Resolve ambiguities marked [NEEDS CLARIFICATION]          |
| `@spec-plan`      | Research, explore codebase, generate technical plan       |
| `@spec-tasks`     | Generate task list from plan                              |
| `@spec-implement` | Execute tasks (T001, T001-T005, --all)                    |
| `@spec-validate`  | Validate artifacts at any phase                           |
| `@spec-archive`   | Generate documentation and mark as archived               |
| `@spec-list`      | List all features by status                               |

**Workflow:**

```
@spec-init --> @spec-clarify --> @spec-plan --> @spec-tasks --> @spec-implement --> @spec-validate --> @spec-archive
```

## Installation

### Option 1: Global Installation (All Projects)

Copy agents to your global Kiro agents directory:

```bash
# Create directory if it doesn't exist
mkdir -p ~/.kiro/agents

# Copy git-helpers agents
cp kiro-extras/git-helpers/agents/*.json ~/.kiro/agents/

# Copy spec-driven agents
cp kiro-extras/spec-driven/agents/*.json ~/.kiro/agents/

# Copy steering files (optional but recommended)
mkdir -p ~/.kiro/steering
cp kiro-extras/git-helpers/steering/*.md ~/.kiro/steering/
cp kiro-extras/spec-driven/steering/*.md ~/.kiro/steering/
```

### Option 2: Project-Level Installation

Copy to your project's `.kiro` directory:

```bash
# In your project root
mkdir -p .kiro/agents .kiro/steering .kiro/settings

# Copy agents
cp /path/to/kiro-extras/git-helpers/agents/*.json .kiro/agents/
cp /path/to/kiro-extras/spec-driven/agents/*.json .kiro/agents/

# Copy steering files
cp /path/to/kiro-extras/git-helpers/steering/*.md .kiro/steering/
cp /path/to/kiro-extras/spec-driven/steering/*.md .kiro/steering/

# Copy MCP config (for spec-driven with Serena)
cp /path/to/kiro-extras/spec-driven/settings/mcp.json .kiro/settings/
```

## Requirements

### git-helpers

No external dependencies.

### spec-driven

- `uvx` (uv tool runner) for Serena MCP server
- Install uv: `curl -LsSf https://astral.sh/uv/install.sh | sh`

## Usage

After installation, use agents with the `@` prefix in Kiro:

```
@git-commit              # Create commit with ticket from branch name
@git-commit -s           # Commit only staged files

@git-review         # Review changes + test coverage in terminal
@git-review main    # Compare against main branch
@git-review --save  # Save to CODE_REVIEW.md

@git-summary             # Generate MR_DETAILS.md

@spec-init add user authentication
@spec-plan
@spec-tasks
@spec-implement
@spec-validate
@spec-archive
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
    agents/
      commit.json
      review.json
      summary.json
    steering/
      git-helpers.md
  spec-driven/
    agents/
      init.json
      clarify.json
      plan.json
      tasks.json
      implement.json
      validate.json
      archive.json
      specs.json
    steering/
      spec-driven.md
    settings/
      mcp.json
```

## License

MIT

## Credits

Migrated from [claude-code-extras](https://github.com/adeonir/claude-code-extras) plugins.
