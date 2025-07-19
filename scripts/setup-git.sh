#!/bin/bash

# GitHub Safe Merge & Deploy Workflow - Git Setup Helper
# This script helps set up git configuration for local development

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

# Check if git is installed
check_git_installed() {
    if ! command -v git &> /dev/null; then
        log_error "Git is not installed. Please install git first."
        exit 1
    fi
    log_success "Git is installed"
}

# Setup git configuration
setup_git_config() {
    log_info "Setting up git configuration"
    
    # Set user name if not already set
    if [[ -z "$(git config --global user.name 2>/dev/null || echo '')" ]]; then
        log_warning "Git user.name is not set"
        read -p "Enter your git user.name: " git_name
        if [[ -n "$git_name" ]]; then
            git config --global user.name "$git_name"
            log_success "Set git user.name to: $git_name"
        fi
    else
        log_info "Git user.name is already set: $(git config --global user.name)"
    fi
    
    # Set user email if not already set
    if [[ -z "$(git config --global user.email 2>/dev/null || echo '')" ]]; then
        log_warning "Git user.email is not set"
        read -p "Enter your git user.email: " git_email
        if [[ -n "$git_email" ]]; then
            git config --global user.email "$git_email"
            log_success "Set git user.email to: $git_email"
        fi
    else
        log_info "Git user.email is already set: $(git config --global user.email)"
    fi
    
    # Set default branch name
    git config --global init.defaultBranch master
    
    # Set pull strategy
    git config --global pull.rebase false
    
    # Set push strategy
    git config --global push.default current
    
    log_success "Git configuration completed"
}

# Setup git hooks (optional)
setup_git_hooks() {
    log_info "Setting up git hooks"
    
    # Create .git/hooks directory if it doesn't exist
    mkdir -p .git/hooks
    
    # Create pre-commit hook
    cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
# Pre-commit hook for merge-guard-demo

set -e

echo "Running pre-commit checks..."

# Run validation script if it exists
if [[ -f "scripts/validate-merge-state.sh" ]]; then
    echo "Running merge state validation..."
    ./scripts/validate-merge-state.sh
fi

echo "Pre-commit checks passed"
EOF
    
    # Make the hook executable
    chmod +x .git/hooks/pre-commit
    
    log_success "Git hooks configured"
}

# Setup remote origin if not already set
setup_remote_origin() {
    log_info "Checking remote origin configuration"
    
    if ! git remote get-url origin &> /dev/null; then
        log_warning "No remote origin configured"
        read -p "Enter your GitHub repository URL (or press Enter to skip): " repo_url
        if [[ -n "$repo_url" ]]; then
            git remote add origin "$repo_url"
            log_success "Added remote origin: $repo_url"
        fi
    else
        log_info "Remote origin is already configured: $(git remote get-url origin)"
    fi
}

# Setup branch protection check
setup_branch_protection_check() {
    log_info "Setting up branch protection check"
    
    # Create the branch protection check script
    cat > scripts/check-branch-protection.sh << 'EOF'
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
EOF
    
    # Make the script executable
    chmod +x scripts/check-branch-protection.sh
    
    log_success "Branch protection check script created"
}

# Main setup function
main() {
    log_info "Starting git setup for merge-guard-demo"
    
    # Check prerequisites
    check_git_installed
    
    # Setup git configuration
    setup_git_config
    
    # Setup remote origin
    setup_remote_origin
    
    # Setup git hooks
    setup_git_hooks
    
    # Setup branch protection check
    setup_branch_protection_check
    
    log_success "Git setup completed successfully!"
    log_info "Next steps:"
    echo "  1. Configure branch protection rules in GitHub repository settings"
    echo "  2. Run 'npm install' to install dependencies"
    echo "  3. Run 'npm run dev' to start the development environment"
}

# Run main function
main "$@" 