# Steering Analyze Agent

Analyze project codebase and generate specific steering files tailored to the project's patterns, conventions, and architecture.

## Arguments

- No arguments required - performs deep analysis of current project
- `--domain <domain>` - Focus analysis on specific domain (frontend, backend, api, etc.)
- `--update` - Update existing specific steering files with new analysis
- `--verbose` - Include detailed analysis and reasoning in output

## Process

1. **Deep Codebase Analysis**:

   ```bash
   # Analyze code patterns and conventions
   find src/ -name "*.ts" -o -name "*.js" -o -name "*.py" -o -name "*.rs" | head -50

   # Extract architectural patterns
   grep -r "export.*class\|export.*function\|def \|impl \|struct " src/ | head -20

   # Analyze import/export patterns
   grep -r "import.*from\|from.*import\|use " src/ | head -20

   # Check testing patterns
   find . -name "*test*" -o -name "*spec*" | head -10
   ```

2. **Pattern Recognition**:
   - **Component Patterns**: React hooks, Vue composables, custom patterns
   - **API Patterns**: REST conventions, GraphQL schemas, error handling
   - **Data Patterns**: State management, database models, validation
   - **Testing Patterns**: Test structure, mocking strategies, coverage
   - **Build Patterns**: Bundling, deployment, environment configs

3. **Generate Specific Steering Files**:
   Create targeted steering files based on detected patterns:
   - Framework-specific patterns (React, Vue, FastAPI, etc.)
   - Architecture-specific conventions (MVC, Clean Architecture, etc.)
   - Domain-specific rules (authentication, payments, etc.)
   - Testing and quality patterns

4. **Integration Analysis**:
   - How components interact with each other
   - API integration patterns
   - State management flows
   - Error handling strategies

## Generated Steering Files

### Frontend Projects (React/Vue/Angular)

#### component-patterns.md

```markdown
# Component Patterns

## Component Architecture

[Detected patterns: Functional components, custom hooks, etc.]

## State Management

[Redux, Zustand, Context API patterns found]

## Styling Conventions

[Tailwind, CSS Modules, styled-components patterns]

## Testing Patterns

[Jest, React Testing Library, E2E patterns]
```

#### api-integration.md

```markdown
# API Integration Patterns

## HTTP Client Configuration

[Axios, fetch, custom client patterns]

## Error Handling

[Global error handlers, retry logic, user feedback]

## Data Fetching

[React Query, SWR, custom hooks patterns]

## Authentication Flow

[JWT handling, refresh tokens, protected routes]
```

### Backend Projects (Node.js/Python/Rust)

#### api-design.md

```markdown
# API Design Patterns

## Route Structure

[RESTful conventions, nested resources, versioning]

## Middleware Patterns

[Authentication, logging, validation, CORS]

## Error Handling

[Global error handlers, custom exceptions, status codes]

## Database Integration

[ORM patterns, query optimization, migrations]
```

#### security-patterns.md

```markdown
# Security Implementation

## Authentication Strategy

[JWT, sessions, OAuth integration patterns]

## Input Validation

[Schema validation, sanitization, type checking]

## Authorization Patterns

[RBAC, permissions, resource-based access]

## Security Headers

[CORS, CSP, rate limiting implementations]
```

### Full-Stack Projects

#### architecture-patterns.md

```markdown
# Architecture Patterns

## Project Structure

[Monorepo, microservices, layered architecture]

## Communication Patterns

[API contracts, event-driven, message queues]

## Data Flow

[Frontend to backend, state synchronization]

## Deployment Patterns

[Docker, CI/CD, environment management]
```

## Analysis Logic

### Framework Detection

```bash
# React Patterns
grep -r "useState\|useEffect\|React\." src/
grep -r "jsx\|tsx" package.json

# Vue Patterns
grep -r "ref\|reactive\|computed" src/
grep -r "vue" package.json

# FastAPI Patterns
grep -r "@app\.\|FastAPI\|Depends" src/
grep -r "fastapi" requirements.txt

# Express Patterns
grep -r "app\.\|express\(\)" src/
grep -r "express" package.json
```

### Architecture Pattern Detection

```bash
# Clean Architecture
find src/ -name "*domain*" -o -name "*application*" -o -name "*infrastructure*"

# MVC Pattern
find src/ -name "*controller*" -o -name "*model*" -o -name "*view*"

# Component-based
find src/ -name "*component*" -o -name "*hook*" -o -name "*service*"

# Microservices
find . -name "docker-compose*" -o -name "Dockerfile*" | wc -l
```

### Code Convention Analysis

```bash
# Naming Conventions
grep -r "^export.*function\|^export.*class" src/ | head -10

# Import Patterns
grep -r "^import.*from" src/ | head -10

# Error Handling
grep -r "try.*catch\|except\|Result<\|Option<" src/ | head -10

# Testing Conventions
find . -name "*.test.*" -o -name "*.spec.*" | head -5
```

## Output Format

```
Deep Project Analysis Complete

Detected Patterns:
   Framework: React 18 with TypeScript
   Architecture: Component-based with custom hooks
   State: Zustand + React Query
   Styling: Tailwind CSS with component variants
   Testing: Jest + React Testing Library + Playwright

Generated Specific Steering Files:
   .kiro/steering/react-patterns.md - Component and hook conventions
   .kiro/steering/api-integration.md - Data fetching and error handling
   .kiro/steering/testing-strategy.md - Test organization and patterns
   .kiro/steering/styling-conventions.md - Tailwind and component styling

Key Insights:
   • Custom hook pattern: useApi, useAuth, useLocalStorage
   • Error boundary implementation for component isolation
   • Consistent API response handling with custom types
   • Page-level component organization with shared layouts

Next Steps:
   1. Review generated steering files for accuracy
   2. Customize patterns to match team preferences
   3. Use @spec-init with enhanced project context

Pro Tip: Run @steer-analyze --update periodically as your
   codebase evolves to keep steering files current.
```

## Integration with Existing Steering

The specific steering files complement the foundational ones:

### Foundational (from @steer-init)

- `product.md` - Business context and requirements
- `tech.md` - Technology stack and architecture
- `structure.md` - Basic code organization

### Specific (from @steer-analyze)

- `react-patterns.md` - React-specific conventions
- `api-integration.md` - API handling patterns
- `testing-strategy.md` - Testing approach and tools
- `styling-conventions.md` - UI/styling patterns

## Domain-Specific Analysis

### --domain frontend

Focus on UI components, state management, routing, and user interactions.

### --domain backend

Focus on API design, database patterns, authentication, and business logic.

### --domain api

Focus on endpoint design, request/response patterns, and integration contracts.

### --domain testing

Focus on test organization, mocking strategies, and quality assurance patterns.

## Error Handling

- **No code patterns detected**: Generate minimal template files with placeholders
- **Mixed patterns detected**: Document multiple approaches and suggest standardization
- **Outdated patterns**: Flag deprecated patterns and suggest modern alternatives
- **Inconsistent conventions**: Highlight inconsistencies and recommend unified approach

## Best Practices Applied

- **Pattern Recognition**: Uses AST analysis and regex patterns for accuracy
- **Context Preservation**: Maintains existing project conventions while suggesting improvements
- **Incremental Updates**: Updates specific files without affecting foundational steering
- **Team Collaboration**: Documents actual patterns for team consistency
- **Evolution Support**: Designed to track pattern changes over time
