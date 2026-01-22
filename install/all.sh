#!/bin/bash

# Install All Modules Script
# Usage: ./install/all.sh [global|project]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

install_all() {
    local scope="$1"
    local scope_name="globally"

    if [ "$scope" = "--project" ]; then
        scope_name="in current project"
    fi

    echo "🚀 Installing all kiro-extras modules ($scope_name)..."
    echo ""

    # Install each module
    "$SCRIPT_DIR/steer-tools.sh" "$scope"
    echo ""
    "$SCRIPT_DIR/git-helpers.sh" "$scope"
    echo ""
    "$SCRIPT_DIR/spec-driven.sh" "$scope"
    echo ""

    echo "🎉 All modules installed successfully!"
    echo ""
    echo "Available workflows:"
    echo "  Setup:      @steer-init --> @steer-analyze"
    echo "  Git:        @git-review --> @git-commit --> @git-summary"
    echo "  Spec-driven: @spec-init --> @spec-clarify --> @spec-plan --> @spec-tasks --> @spec-implement"
    echo ""
    echo "Complete workflow:"
    echo "  @steer-init --> @steer-analyze --> @spec-init --> Development --> @git-review --> @git-commit"
}

show_usage() {
    echo "Usage: $0 [--project]"
    echo ""
    echo "This script installs all kiro-extras modules:"
    echo "  - steer-tools: Project initialization and steering file generation"
    echo "  - git-helpers: Git workflow automation with code review"
    echo "  - spec-driven: Specification-driven development workflow"
    echo ""
    echo "Options:"
    echo "  (default)  Install all modules globally (~/.kiro/)"
    echo "  --project  Install all modules in current project (.kiro/)"
    echo ""
    echo "Individual installation:"
    echo "  ./install/steer-tools.sh [--project]"
    echo "  ./install/git-helpers.sh [--project]"
    echo "  ./install/spec-driven.sh [--project]"
}

case "$1" in
    --project)
        install_all "--project"
        ;;
    ""|--global)
        install_all ""
        ;;
    *)
        show_usage
        exit 1
        ;;
esac
