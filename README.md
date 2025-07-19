# GitHub Safe Merge & Deploy Workflow

A production-ready GitHub project demonstrating secure PR merge and deployment workflows using GitHub Actions, release-please, and a fullstack application.

## 🚀 Quick Start

```bash
# Clone the repository
git clone <your-repo-url>
cd dev-workflow-poc

# Start the application with Docker (recommended)
npm run dev

# Or build and start (first time or after changes)
npm run dev:build
```

The application will be available at:
- Frontend: http://localhost:5173
- Backend: http://localhost:3001
- Health Check: http://localhost:3001/health
- Production Frontend: http://localhost:3000

**Alternative: Local Development (without Docker)**
```bash
# Install dependencies
npm run install:all

# Start the application
npm run dev:backend & npm run dev:frontend
```

## 🏗️ Architecture Overview

This project implements a comprehensive CI/CD pipeline with the following key components:

### Merge & Tag Validation System
- **Feature branches**: Ensures `origin/master` points to the same commit as latest tag
- **Pull requests**: Validates current branch is up-to-date with `origin/master`
- **Push to master**: Confirms `master` is exactly one commit ahead of latest tag
- **Edge cases**: Handles repositories with no existing tags gracefully

### Automated Release Process
- Uses `release-please` for semantic versioning
- Automatically creates release PRs based on conventional commits
- Handles both release PR creation and actual releases

### Fullstack Application
- **Backend**: Node.js Express server with health endpoints
- **Frontend**: React + Vite application with real-time status display

## 🔒 Security Guarantees

### What Each Validation Prevents:

1. **Feature Branch Validation**
   - Prevents merging when master has uncommitted changes
   - Ensures all deployments are based on tagged releases

2. **Pull Request Validation**
   - Prevents outdated PRs from being merged
   - Ensures code is based on the latest master

3. **Master Push Validation**
   - Enforces squash merge strategy
   - Prevents multiple commits from being pushed to master
   - Ensures clean release history

## 🛠️ Local Development

### Prerequisites
- Docker and Docker Compose
- Git with proper configuration

### Setup
```bash
# Setup git hooks (optional)
npm run setup:git

# Start with Docker (recommended)
npm run dev

# Or for local development without Docker:
# Install Node.js 18+ (see .nvmrc)
nvm use
npm run install:all
```

### Development Commands
```bash
# Docker Development (recommended)
npm run dev              # Start development environment
npm run dev:build        # Build and start (first time)
npm run dev:down         # Stop containers
npm run dev:logs         # View logs
npm run docker:clean     # Clean up Docker resources

# Local Development (without Docker)
npm run dev:backend      # Start only backend
npm run dev:frontend     # Start only frontend
npm run install:all      # Install all dependencies

# Testing
npm test                 # Run all tests
npm run test:backend     # Run backend tests only
npm run test:frontend    # Run frontend tests only
```

## 🔄 CI/CD Pipeline

### Workflows

1. **Merge Guard** (`.github/workflows/merge-guard.yml`)
   - Validates merge safety on PRs and pushes
   - Runs on multiple operating systems
   - Provides detailed error messages

2. **Release Please** (`.github/workflows/release-please.yml`)
   - Automates semantic versioning
   - Creates release PRs and publishes releases
   - Updates changelog automatically

3. **CI Pipeline** (`.github/workflows/ci.yml`)
   - Runs tests on backend and frontend
   - Builds and validates artifacts
   - Performs integration testing

### Branch Protection Rules

Configure the following branch protection rules for `master`:
- Require pull request reviews
- Require status checks to pass
- Require branches to be up to date
- Include administrators

## 📦 Release Process

### Triggering Releases

1. **Feature Release**: Commit with `feat:` prefix
2. **Bug Fix**: Commit with `fix:` prefix
3. **Breaking Change**: Commit with `BREAKING CHANGE:` in body

### Release Flow
1. Push commits to master with conventional commit format
2. Release-please creates a release PR automatically
3. Review and merge the release PR
4. Release is published with new version tag

### Version Management
- Uses semantic versioning (MAJOR.MINOR.PATCH)
- Version is managed in `.release-please-manifest.json`
- Tags include 'v' prefix (e.g., v1.2.3)

## 🐛 Troubleshooting

### Common Issues

**Validation Script Fails**
```bash
# Enable debug mode
DEBUG=1 ./scripts/validate-merge-state.sh
```

**Release-please Not Working**
- Check commit message format follows conventional commits
- Verify `.github/release-please-config.json` is properly configured
- Ensure workflow has proper permissions

**Local Development Issues**
```bash
# Reset to clean state
git clean -fdx
npm install
```

### Debug Mode
Enable debug output for validation scripts:
```bash
export DEBUG=1
./scripts/validate-merge-state.sh
```

## 📚 Additional Documentation

- [Architecture Deep Dive](docs/ARCHITECTURE.md)
- [Contributing Guidelines](CONTRIBUTING.md)
- [Deployment Guide](docs/DEPLOYMENT.md)

## 🏆 Success Criteria

- ✅ Zero-config clone and run experience
- ✅ All validation scenarios work correctly
- ✅ Release process functions end-to-end
- ✅ Clear documentation with examples
- ✅ Production-ready code quality
- ✅ Comprehensive error handling

## 📄 License

MIT License - see [LICENSE](LICENSE) for details. 