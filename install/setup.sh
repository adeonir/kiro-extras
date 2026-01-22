#!/bin/bash

# Setup Installation Script
# Usage: ./install/setup.sh [global|project]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KIRO_EXTRAS_DIR="$(dirname "$SCRIPT_DIR")"

install_global() {
    echo "🔧 Installing setup globally..."

    # Create directories
    mkdir -p ~/.kiro/prompts ~/.kiro/steering

    # Copy prompts
    cp "$KIRO_EXTRAS_DIR"/modules/setup/prompts/*.md ~/.kiro/prompts/

    # Copy steering files
    cp "$KIRO_EXTRAS_DIR"/modules/setup/steering/*.md ~/.kiro/steering/

    echo "✅ Setup installed globally"
    echo "   Prompts: ~/.kiro/prompts/"
    echo "   Steering: ~/.kiro/steering/"
}

install_project() {
    echo "🔧 Installing setup in current project..."

    # Create directories
    mkdir -p .kiro/prompts .kiro/steering

    # Copy prompts
    cp "$KIRO_EXTRAS_DIR"/modules/setup/prompts/*.md .kiro/prompts/

    # Copy steering files
    cp "$KIRO_EXTRAS_DIR"/modules/setup/steering/*.md .kiro/steering/

    echo "✅ Setup installed in project"
    echo "   Prompts: .kiro/prompts/"
    echo "   Steering: .kiro/steering/"
}

show_usage() {
    echo "Usage: $0 [--project]"
    echo ""
    echo "Options:"
    echo "  (default)  Install setup globally (~/.kiro/)"
    echo "  --project  Install setup in current project (.kiro/)"
    echo ""
    echo "Available prompts:"
    echo "  @steer-init    - Analyze project and generate essential steering files"
    echo "  @steer-analyze - Generate project-specific steering files from codebase patterns"
    echo ""
    echo "Workflow:"
    echo "  @steer-init --> @steer-analyze --> Review/Customize --> @spec-init --> Development"
    echo ""
    echo "Generated steering files:"
    echo "  - product.md: Product context and business requirements"
    echo "  - tech.md: Technical architecture and standards"
    echo "  - structure.md: Code organization and conventions"
    echo "  - Plus project-specific patterns (React, API, testing, etc.)"
}

case "$1" in
    --project)
        install_project
        ;;
    ""|--global)
        install_global
        ;;
    *)
        show_usage
        exit 1
        ;;
esac
