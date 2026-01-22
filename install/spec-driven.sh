#!/bin/bash

# Spec-Driven Installation Script
# Usage: ./install/spec-driven.sh [global|project]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KIRO_EXTRAS_DIR="$(dirname "$SCRIPT_DIR")"

install_global() {
    echo "🔧 Installing spec-driven globally..."

    # Create directories
    mkdir -p ~/.kiro/prompts ~/.kiro/steering ~/.kiro/settings

    # Copy prompts
    cp "$KIRO_EXTRAS_DIR"/spec-driven/prompts/*.md ~/.kiro/prompts/

    # Copy steering files
    cp "$KIRO_EXTRAS_DIR"/spec-driven/steering/*.md ~/.kiro/steering/

    # Copy MCP settings
    cp "$KIRO_EXTRAS_DIR"/spec-driven/settings/mcp.json ~/.kiro/settings/

    echo "✅ Spec-driven installed globally"
    echo "   Prompts: ~/.kiro/prompts/"
    echo "   Steering: ~/.kiro/steering/"
    echo "   Settings: ~/.kiro/settings/"
}

install_project() {
    echo "🔧 Installing spec-driven in current project..."

    # Create directories
    mkdir -p .kiro/prompts .kiro/steering .kiro/settings

    # Copy prompts
    cp "$KIRO_EXTRAS_DIR"/spec-driven/prompts/*.md .kiro/prompts/

    # Copy steering files
    cp "$KIRO_EXTRAS_DIR"/spec-driven/steering/*.md .kiro/steering/

    # Copy MCP settings
    cp "$KIRO_EXTRAS_DIR"/spec-driven/settings/mcp.json .kiro/settings/

    echo "✅ Spec-driven installed in project"
    echo "   Prompts: .kiro/prompts/"
    echo "   Steering: .kiro/steering/"
    echo "   Settings: .kiro/settings/"
}

show_usage() {
    echo "Usage: $0 [--project]"
    echo ""
    echo "Options:"
    echo "  (default)  Install spec-driven globally (~/.kiro/)"
    echo "  --project  Install spec-driven in current project (.kiro/)"
    echo ""
    echo "Available prompts:"
    echo "  @spec-init      - Create specification (auto-detects greenfield/brownfield)"
    echo "  @spec-clarify   - Resolve ambiguities marked [NEEDS CLARIFICATION]"
    echo "  @spec-plan      - Research, explore codebase, generate technical plan"
    echo "  @spec-tasks     - Generate task list from plan"
    echo "  @spec-implement - Execute tasks (T001, T001-T005, --all)"
    echo "  @spec-validate  - Validate artifacts at any phase"
    echo "  @spec-archive   - Generate documentation and mark as archived"
    echo "  @spec-list      - List all features by status"
    echo ""
    echo "Requirements:"
    echo "  - uvx (uv tool runner) for Serena MCP server"
    echo "  - Install uv: curl -LsSf https://astral.sh/uv/install.sh | sh"
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
