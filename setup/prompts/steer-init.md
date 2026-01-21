# Steering Init Agent

Initialize project with essential steering files following Kiro.dev best practices for spec-driven development.

## Arguments

- No arguments required - analyzes current project automatically
- `--force` - Overwrite existing steering files
- `--minimal` - Generate minimal steering files (basic templates only)

## Process

1. **Analyze Project Structure**:

   ```bash
   # Detect project type and technology stack
   find . -name "package.json" -o -name "requirements.txt" -o -name "Cargo.toml" -o -name "pom.xml" -o -name "go.mod"

   # Analyze folder structure
   ls -la src/ app/ lib/ components/ pages/ 2>/dev/null

   # Check existing documentation
   find . -name "README*" -o -name "CHANGELOG*" -o -name "*.md" | head -10
   ```

2. **Extract Project Context**:
   - **Technology Stack**: Parse package.json, requirements.txt, Cargo.toml, etc.
   - **Architecture Patterns**: Analyze folder structure (MVC, component-based, microservices)
   - **Existing Conventions**: Extract naming patterns from codebase
   - **Project Purpose**: Parse README.md, package.json description, git repo info

3. **Generate Steering Files**:
   Create `.kiro/steering/` directory with three essential files:
   - `product.md` - Product context and business requirements
   - `tech.md` - Technical architecture and standards
   - `structure.md` - Code organization and conventions

4. **Validate and Report**:
   - Check if steering files were created successfully
   - Provide summary of detected project characteristics
   - Suggest next steps for spec-driven development

## Steering File Templates

### product.md Structure

```markdown
# Product Context

## Core Value Proposition

[Extracted from README.md, package.json description, or git repo]

## Project Type

[Web Application | Mobile App | CLI Tool | Library | API Service]

## Key Constraints

- [Technical constraints based on detected stack]
- [Performance requirements based on project type]
- [Security considerations for the domain]

## User Personas

[Inferred from project type and purpose]

## Success Metrics

[Relevant metrics based on project type]
```

### tech.md Structure

```markdown
# Technical Architecture

## Technology Stack

[Detected technologies with versions]

## Architectural Patterns

[Inferred from folder structure and dependencies]

## Code Standards

[Detected linting/formatting tools and configurations]

## Performance Requirements

[Based on project type and best practices]

## Development Workflow

[Git workflow, testing strategy, deployment]
```

### structure.md Structure

```markdown
# Code Organization

## Project Structure

[Current folder structure mapped]

## Naming Conventions

[Extracted patterns from existing code]

## Component Patterns

[Identified architectural patterns]

## File Organization Rules

[Where new files should be placed]

## Import/Export Conventions

[Module organization patterns]
```

## Detection Logic

### Technology Stack Detection

```bash
# Frontend Frameworks
package.json: react, vue, angular, svelte, next, nuxt
# Backend Frameworks
package.json: express, fastify, koa, nest
requirements.txt: django, flask, fastapi
Cargo.toml: axum, warp, rocket, actix-web
go.mod: gin, echo, fiber
pom.xml: spring-boot, quarkus

# Databases
package.json: mongoose, prisma, sequelize, typeorm
requirements.txt: sqlalchemy, django-orm, pymongo
Cargo.toml: sqlx, diesel, sea-orm
```

### Architecture Pattern Detection

```bash
# Component-based (React/Vue)
src/components/, src/pages/, src/hooks/

# MVC Pattern
controllers/, models/, views/, routes/

# Domain-driven Design
src/domain/, src/application/, src/infrastructure/

# Microservices
services/, apps/, packages/

# Monorepo
packages/, apps/, libs/
```

### Code Standards Detection

```bash
# Linting/Formatting
.eslintrc*, .prettierrc*, .editorconfig
pyproject.toml, setup.cfg, .flake8
rustfmt.toml, clippy.toml
.golangci.yml, gofmt

# Testing
jest.config.js, vitest.config.js, pytest.ini
Cargo.toml [dev-dependencies]
```

## Output Format

```
🎯 Steering Initialization Complete

📊 Project Analysis:
   Type: React TypeScript Web Application
   Stack: React 18, TypeScript, Tailwind CSS, Vite
   Architecture: Component-based with custom hooks
   Testing: Jest + React Testing Library

📁 Generated Steering Files:
   ✓ .kiro/steering/product.md - Product context and user personas
   ✓ .kiro/steering/tech.md - Technical architecture and standards
   ✓ .kiro/steering/structure.md - Code organization patterns

🚀 Next Steps:
   1. Review and customize generated steering files
   2. Run @spec-init to create your first feature specification
   3. Use @git-review to establish code quality baselines

💡 Pro Tip: Steering files provide context for all Kiro agents.
   Update them as your project evolves to maintain AI accuracy.
```

## Error Handling

- **No project detected**: Guide user to run in project root directory
- **Existing steering files**: Prompt for confirmation unless `--force` used
- **Permission issues**: Check write permissions for `.kiro/` directory
- **Unknown project type**: Generate minimal templates with placeholders

## Integration with Other Prompts

The generated steering files enhance other kiro-extras prompts:

- **git-helpers**: Uses tech.md for commit conventions and code standards
- **spec-driven**: Uses product.md for user context and tech.md for implementation guidance
- **Future prompts**: All prompts benefit from consistent project context

## Best Practices Applied

- **Spec-First Approach**: Steering files enable better specification writing
- **EARS Format Ready**: Product context supports EARS requirements format
- **Modular Architecture**: Separate concerns across three focused files
- **Iterative Refinement**: Files designed for continuous updates
- **Team Collaboration**: Version-controlled context for consistent AI behavior
