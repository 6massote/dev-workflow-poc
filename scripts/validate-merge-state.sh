#!/bin/bash

# GitHub Safe Merge & Deploy Workflow - Merge State Validation
# This script validates the merge state to prevent unsafe merges and deployments

set -euo pipefail

# Enable debug mode if DEBUG environment variable is set
if [[ "${DEBUG:-}" == "1" ]]; then
    set -x
fi

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

# GitHub Actions error formatting
github_error() {
    echo "::error::$1"
}

github_warning() {
    echo "::warning::$1"
}

# Get current branch name
get_current_branch() {
    git rev-parse --abbrev-ref HEAD
}

# Get the latest tag
get_latest_tag() {
    git describe --tags --abbrev=0 2>/dev/null || echo ""
}

# Get the commit hash of the latest tag
get_latest_tag_commit() {
    local tag="$1"
    if [[ -n "$tag" ]]; then
        git rev-parse "$tag" 2>/dev/null || echo ""
    else
        echo ""
    fi
}

# Get the commit hash of origin/master
get_origin_master_commit() {
    git rev-parse origin/master 2>/dev/null || echo ""
}

# Check if repository has any tags
has_tags() {
    git tag --list | wc -l | tr -d ' '
}

# Validate feature branch
validate_feature_branch() {
    local current_branch="$1"
    local latest_tag="$2"
    
    log_info "Validating feature branch: $current_branch"
    
    if [[ "$current_branch" == "master" ]]; then
        log_error "This validation should not be run on master branch"
        github_error "Feature branch validation should not be run on master branch"
        return 1
    fi
    
    # Get origin/master commit
    local origin_master_commit
    origin_master_commit=$(get_origin_master_commit)
    
    if [[ -z "$origin_master_commit" ]]; then
        log_error "Cannot determine origin/master commit"
        github_error "Cannot determine origin/master commit. Ensure remote is properly configured."
        return 1
    fi
    
    # If no tags exist, this is the first deployment
    if [[ "$(has_tags)" == "0" ]]; then
        log_warning "No tags found in repository. This appears to be the first deployment."
        github_warning "No tags found in repository. This appears to be the first deployment."
        return 0
    fi
    
    # Get the commit hash of the latest tag
    local latest_tag_commit
    latest_tag_commit=$(get_latest_tag_commit "$latest_tag")
    
    if [[ -z "$latest_tag_commit" ]]; then
        log_error "Cannot determine commit hash for latest tag: $latest_tag"
        github_error "Cannot determine commit hash for latest tag: $latest_tag"
        return 1
    fi
    
    # Check if origin/master points to the same commit as the latest tag
    if [[ "$origin_master_commit" != "$latest_tag_commit" ]]; then
        log_error "origin/master ($origin_master_commit) does not point to the same commit as latest tag ($latest_tag_commit)"
        github_error "origin/master does not point to the same commit as latest tag. This indicates there are pending deployments or uncommitted changes on master."
        log_info "Latest tag: $latest_tag ($latest_tag_commit)"
        log_info "Origin/master: $origin_master_commit"
        return 1
    fi
    
    log_success "Feature branch validation passed"
    return 0
}

# Validate pull request
validate_pull_request() {
    local current_branch="$1"
    
    log_info "Validating pull request for branch: $current_branch"
    
    # Get origin/master commit
    local origin_master_commit
    origin_master_commit=$(get_origin_master_commit)
    
    if [[ -z "$origin_master_commit" ]]; then
        log_error "Cannot determine origin/master commit"
        github_error "Cannot determine origin/master commit. Ensure remote is properly configured."
        return 1
    fi
    
    # Get the merge base between current branch and origin/master
    local merge_base
    merge_base=$(git merge-base HEAD origin/master 2>/dev/null || echo "")
    
    if [[ -z "$merge_base" ]]; then
        log_error "Cannot determine merge base between current branch and origin/master"
        github_error "Cannot determine merge base between current branch and origin/master"
        return 1
    fi
    
    # Check if current branch is up-to-date with origin/master
    if [[ "$merge_base" != "$origin_master_commit" ]]; then
        log_error "Current branch is not up-to-date with origin/master"
        github_error "Current branch is not up-to-date with origin/master. Please rebase or merge the latest changes."
        log_info "Merge base: $merge_base"
        log_info "Origin/master: $origin_master_commit"
        return 1
    fi
    
    log_success "Pull request validation passed"
    return 0
}

# Validate push to master
validate_master_push() {
    local current_branch="$1"
    local latest_tag="$2"
    
    log_info "Validating push to master"
    
    if [[ "$current_branch" != "master" ]]; then
        log_error "This validation should only be run on master branch"
        github_error "Master push validation should only be run on master branch"
        return 1
    fi
    
    # If no tags exist, this is the first push to master
    if [[ "$(has_tags)" == "0" ]]; then
        log_warning "No tags found in repository. This appears to be the first push to master."
        github_warning "No tags found in repository. This appears to be the first push to master."
        return 0
    fi
    
    # Get the commit hash of the latest tag
    local latest_tag_commit
    latest_tag_commit=$(get_latest_tag_commit "$latest_tag")
    
    if [[ -z "$latest_tag_commit" ]]; then
        log_error "Cannot determine commit hash for latest tag: $latest_tag"
        github_error "Cannot determine commit hash for latest tag: $latest_tag"
        return 1
    fi
    
    # Check if master is exactly one commit ahead of the latest tag
    local master_commit
    master_commit=$(git rev-parse HEAD)
    
    # Get the parent of the current master commit
    local master_parent
    master_parent=$(git rev-parse HEAD^ 2>/dev/null || echo "")
    
    if [[ -z "$master_parent" ]]; then
        log_error "Cannot determine parent commit of master"
        github_error "Cannot determine parent commit of master"
        return 1
    fi
    
    # Check if the parent of master matches the latest tag commit
    if [[ "$master_parent" != "$latest_tag_commit" ]]; then
        log_error "Master is not exactly one commit ahead of the latest tag"
        github_error "Master is not exactly one commit ahead of the latest tag. This enforces squash merge strategy."
        log_info "Latest tag: $latest_tag ($latest_tag_commit)"
        log_info "Master parent: $master_parent"
        log_info "Master commit: $master_commit"
        return 1
    fi
    
    log_success "Master push validation passed"
    return 0
}

# Main validation logic
main() {
    log_info "Starting merge state validation"
    
    # Ensure we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        log_error "Not in a git repository"
        github_error "Not in a git repository"
        exit 1
    fi
    
    # Fetch latest changes
    log_info "Fetching latest changes from remote"
    git fetch --depth=0 origin
    
    # Get current branch and latest tag
    local current_branch
    current_branch=$(get_current_branch)
    
    local latest_tag
    latest_tag=$(get_latest_tag)
    
    log_info "Current branch: $current_branch"
    log_info "Latest tag: ${latest_tag:-none}"
    
    # Determine validation type based on context
    local validation_type="${VALIDATION_TYPE:-}"
    
    if [[ -z "$validation_type" ]]; then
        # Auto-detect validation type based on branch and context
        if [[ "$current_branch" == "master" ]]; then
            validation_type="master_push"
        elif [[ -n "${GITHUB_EVENT_NAME:-}" && "${GITHUB_EVENT_NAME:-}" == "pull_request" ]]; then
            validation_type="pull_request"
        else
            validation_type="feature_branch"
        fi
    fi
    
    log_info "Validation type: $validation_type"
    
    # Run appropriate validation
    case "$validation_type" in
        "feature_branch")
            validate_feature_branch "$current_branch" "$latest_tag"
            ;;
        "pull_request")
            validate_pull_request "$current_branch"
            ;;
        "master_push")
            validate_master_push "$current_branch" "$latest_tag"
            ;;
        *)
            log_error "Unknown validation type: $validation_type"
            github_error "Unknown validation type: $validation_type"
            exit 1
            ;;
    esac
    
    if [[ $? -eq 0 ]]; then
        log_success "All validations passed"
        exit 0
    else
        log_error "Validation failed"
        exit 1
    fi
}

# Run main function
main "$@" 