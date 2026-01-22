#!/bin/bash

# Git Helpers Installation Script
# Usage: ./install/git-helpers.sh [global|project]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KIRO_EXTRAS_DIR="$(dirname "$SCRIPT_DIR")"

install_global() {
    echo "🔧 Installing git-helpers globally..."

    # Create directories
    mkdir -p ~/.kiro/prompts ~/.kiro/steering

    # Copy prompts
    cp "$KIRO_EXTRAS_DIR"/git-helpers/prompts/*.md ~/.kiro/prompts/

    # Copy steering files
    cp "$KIRO_EXTRAS_DIR"/git-helpers/steering/*.md ~/.kiro/steering/

    echo "✅ Git-helpers installed globally"
    echo "   Prompts: ~/.kiro/prompts/"
    echo "   Steering: ~/.kiro/steering/"
}

install_project() {
    echo "🔧 Installing git-helpers in current project..."

    # Create directories
    mkdir -p .kiro/prompts .kiro/steering

    # Copy prompts
    cp "$KIRO_EXTRAS_DIR"/git-helpers/prompts/*.md .kiro/prompts/

    # Copy steering files
    cp "$KIRO_EXTRAS_DIR"/git-helpers/steering/*.md .kiro/steering/

    echo "✅ Git-helpers installed in project"
    echo "   Prompts: .kiro/prompts/"
    echo "   Steering: .kiro/steering/"
}

show_usage() {
    echo "Usage: $0 [--project]"
    echo ""
    echo "Options:"
    echo "  (default)  Install git-helpers globally (~/.kiro/)"
    echo "  --project  Install git-helpers in current project (.kiro/)"
    echo ""
    echo "Available prompts:"
    echo "  @git-commit  - Create commits with ticket ID from branch name"
    echo "  @git-review  - Review changes with confidence scoring"
    echo "  @git-summary - Generate MR description to file"
    echo "  @git-hotfix  - Create emergency hotfix using git worktree"
    echo "  @git-cleanup - Clean up merged branches and stale references"
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
