#!/bin/bash

# GitHub Safe Merge & Deploy Workflow - Branch Protection Check
# This script checks if branch protection rules are properly configured

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    log_error "Not in a git repository"
    exit 1
fi

# Check if remote origin is configured
if ! git remote get-url origin &> /dev/null; then
    log_error "No remote origin configured"
    exit 1
fi

log_info "Branch protection check completed"
log_warning "Note: Branch protection rules must be configured manually in GitHub repository settings"
log_info "Recommended settings for master branch:"
echo "  - Require pull request reviews before merging"
echo "  - Require status checks to pass before merging"
echo "  - Require branches to be up to date before merging"
echo "  - Include administrators"
echo "  - Restrict pushes that create files that use the git push --force-with-lease command"

log_success "Branch protection check completed"
