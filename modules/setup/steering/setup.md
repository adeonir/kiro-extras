# setup

Project initialization and steering file management for Kiro CLI following official best practices.

## Overview

The setup module provides project initialization capabilities that analyze your codebase and generate essential steering files following Kiro.dev best practices for spec-driven development.

## Prompt

| Prompt          | Description                                                     |
| --------------- | --------------------------------------------------------------- |
| `steer-init`    | Analyze project and generate essential steering files           |
| `steer-analyze` | Generate project-specific steering files from codebase patterns |

## Workflow

```
@steer-init --> @steer-analyze --> Review/Customize --> @spec-init --> Development
```

## Generated Steering Files

### product.md - Product Context

- Core value proposition and project purpose
- User personas and target audience
- Key constraints and business requirements
- Success metrics and acceptance criteria

### tech.md - Technical Architecture

- Technology stack and versions
- Architectural patterns and design decisions
- Code standards and development workflow
- Performance requirements and constraints

### structure.md - Code Organization

- Project folder structure and conventions
- Naming patterns and file organization
- Component architecture and module patterns
- Import/export conventions

## Project Analysis

The `@steer-init` prompt automatically detects:

### Technology Stacks

- **Frontend**: React, Vue, Angular, Svelte, Next.js, Nuxt.js
- **Backend**: Express, FastAPI, Django, Flask, Axum, Spring Boot
- **Mobile**: React Native, Flutter, Swift, Kotlin
- **Desktop**: Electron, Tauri, Qt

### Architecture Patterns

- **Component-based**: React/Vue component architecture
- **MVC**: Model-View-Controller pattern
- **Domain-driven**: DDD with domain/application/infrastructure layers
- **Microservices**: Service-oriented architecture
- **Monorepo**: Multi-package repository structure

### Development Tools

- **Linting**: ESLint, Prettier, Flake8, Clippy, golangci-lint
- **Testing**: Jest, Vitest, pytest, cargo test, Go test
- **Build**: Vite, Webpack, Rollup, cargo, Go build
- **Package Management**: npm, yarn, pnpm, pip, cargo, go mod

## Best Practices Integration

### Kiro.dev Standards

- **Spec-First Development**: Steering files enable better specification writing
- **EARS Format Support**: Product context supports EARS requirements syntax
- **Modular Architecture**: Separate concerns across focused files
- **Team Collaboration**: Version-controlled context for consistent AI behavior

### Quality Assurance

- **Iterative Refinement**: Files designed for continuous updates
- **Context Accuracy**: Regular analysis ensures steering files stay current
- **AI Consistency**: Shared context improves AI-generated code quality

## Usage Examples

### Basic Initialization

```bash
@steer-init
# Analyzes current project and generates all steering files
```

### Force Overwrite

```bash
@steer-init --force
# Overwrites existing steering files with fresh analysis
```

### Minimal Setup

```bash
@steer-init --minimal
# Generates basic template files for manual customization
```

## Integration with Other Modules

### git-helpers

- Uses `tech.md` for commit message conventions
- Applies code standards from steering files
- Leverages project context for better code reviews

### spec-driven

- Uses `product.md` for user stories and requirements
- Applies `tech.md` constraints to implementation plans
- Follows `structure.md` patterns for code organization

## File Locations

Steering files are created in the standard Kiro location:

```
.kiro/steering/
├── product.md      # Product context and business requirements
├── tech.md         # Technical architecture and standards
└── structure.md    # Code organization and conventions
```

## Maintenance

### Keeping Steering Files Current

- Re-run `@steer-init` when major architecture changes occur
- Update manually when business requirements evolve
- Review quarterly to ensure accuracy with project evolution

### Team Synchronization

- Commit steering files to version control
- Include in code review process for changes
- Document updates in team communication channels

## Troubleshooting

### Common Issues

- **Permission denied**: Ensure write access to project directory
- **No project detected**: Run from project root directory
- **Existing files conflict**: Use `--force` flag to overwrite

### Best Results

- Run from project root directory
- Ensure package.json/requirements.txt/Cargo.toml exists
- Have README.md with project description
- Include existing documentation for better context extraction
