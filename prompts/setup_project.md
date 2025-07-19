# GitHub Safe Merge & Deploy Workflow - Project Requirements

Create a complete, production-ready GitHub project demonstrating secure PR merge and deployment workflows using GitHub Actions, release-please, and a fullstack application.

## Core Objectives
- Prevent unsafe merges and deployments
- Enforce consistent branching strategy
- Automate semantic versioning and releases
- Demonstrate fullstack CI/CD best practices

## 1. ✅ Merge & Tag Validation System

### Primary Script: `scripts/validate-merge-state.sh`
**Validation Logic:**
- **Feature branches**: Verify `origin/master` points to the same commit as latest tag (no pending deployments)
- **Pull requests**: Ensure current branch is up-to-date with `origin/master`
- **Push to master**: Confirm `master` is exactly one commit ahead of latest tag (enforces squash merge)
- **Edge case**: Handle repositories with no existing tags gracefully

**Technical Requirements:**
- Use `::error::` for GitHub Actions error formatting
- Exit with code 1 on validation failures
- Include helpful error messages explaining what went wrong
- Add debug mode with `set -x` option for troubleshooting

### Additional Scripts:
- `scripts/setup-git.sh`: Helper for local development setup
- `scripts/check-branch-protection.sh`: Validate branch protection rules are configured

## 2. ✅ GitHub Actions Workflows

### `.github/workflows/merge-guard.yml`
**Triggers:**
- `pull_request` events targeting `master`
- `push` events to `master`
- `push` events to feature branches (configurable)

**Requirements:**
- Use `fetch-depth: 0` for full git history
- Run on multiple OS (ubuntu-latest, optionally windows/mac)
- Cache git references for performance
- Set appropriate permissions (contents: read minimum)

### Additional Workflow Considerations:
- Add workflow concurrency controls to prevent race conditions
- Include timeout settings for long-running validations
- Add workflow status badges to README

## 3. ✅ Automated Release with release-please

### `.github/workflows/release-please.yml`
**Configuration:**
- Use `google-github-actions/release-please-action@v4`
- Trigger on `push` to `master`
- Handle both release PR creation and actual releases
- Include permissions for writing releases and updating PRs

### `.github/release-please-config.json`
```json
{
  "release-type": "node",
  "package-name": "merge-guard-demo", 
  "include-v-in-tag": true,
  "changelog-sections": [
    {"type": "feat", "section": "Features"},
    {"type": "fix", "section": "Bug Fixes"},
    {"type": "chore", "section": "Miscellaneous", "hidden": false}
  ]
}
```

### `.release-please-manifest.json`
- Initialize with version "0.1.0"
- Explain version management strategy

## 4. ✅ Fullstack Demo Application

### Backend (`backend/`)
**Requirements:**
- Minimal Node.js Express server
- Health endpoint: GET `/health` → `{ status: 'ok', timestamp: Date.now(), version: process.env.npm_package_version }`
- Environment-based configuration
- Basic error handling and logging
- Port 3001 (configurable via ENV)

**Additional Endpoints:**
- GET `/api/status` → Application metadata
- Basic CORS configuration for frontend integration

**package.json scripts:**
- `start`: Production server
- `dev`: Development with nodemon
- `test`: Basic health check test

### Frontend (`frontend/`)
**Requirements:**
- React + Vite setup
- Component displaying backend health status
- Environment-based API URL configuration
- Basic error handling and loading states
- Port 5173 (Vite default)

**Additional Features:**
- Simple UI showing connection status
- Display version information from backend
- Basic styling (CSS modules or Tailwind)

**vite.config.js:**
- Proxy configuration for local development
- Build optimization settings

## 5. ✅ Comprehensive CI Pipeline

### `.github/workflows/ci.yml`
**Multi-job structure:**
```yaml
jobs:
  backend-test:
    # Backend validation
  frontend-build:  
    # Frontend build and basic tests
  integration-test:
    # Optional: Basic integration testing
```

**Additional CI Features:**
- Dependency vulnerability scanning
- Code quality checks (ESLint, Prettier)
- Test coverage reporting
- Artifact uploading for built assets
- Matrix testing across Node.js versions

## 6. ✅ Comprehensive Documentation

### README.md Structure
**Required Sections:**
1. **Quick Start**: Clone and run instructions
2. **Architecture Overview**: Workflow explanation with diagrams
3. **Security Guarantees**: What each validation prevents
4. **Local Development**: Setup and testing procedures  
5. **CI/CD Pipeline**: Detailed workflow explanations
6. **Release Process**: How to trigger releases
7. **Troubleshooting**: Common issues and solutions

**Additional Documentation:**
- `CONTRIBUTING.md`: Development guidelines
- `docs/ARCHITECTURE.md`: Technical deep-dive
- `docs/DEPLOYMENT.md`: Production deployment guide

## 7. ✅ Additional Production Features

### Security & Quality
- `.gitignore` for Node.js projects
- `.nvmrc` for Node.js version consistency
- `package-lock.json` committed for reproducible builds
- Basic security headers in Express app
- Environment variable validation

### Development Experience
- VS Code workspace settings (`.vscode/settings.json`)
- Prettier and ESLint configuration
- Husky pre-commit hooks (optional)
- Docker setup for containerized development

### Monitoring & Observability
- Basic logging configuration
- Health check endpoints for monitoring
- Performance timing in API responses

## Success Criteria
- ✅ Zero-config clone and run experience
- ✅ All validation scenarios work correctly
- ✅ Release process functions end-to-end
- ✅ Clear documentation with examples
- ✅ Production-ready code quality
- ✅ Comprehensive error handling

## Implementation Notes
- Test all validation scenarios with actual commits/PRs
- Include example PR demonstrating workflow
- Verify branch protection rules work with validation
- Test release-please integration thoroughly
- Ensure cross-platform compatibility (Windows/Mac/Linux)