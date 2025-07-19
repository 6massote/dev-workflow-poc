# Contributing to GitHub Safe Merge & Deploy Workflow

Thank you for your interest in contributing to this project! This document provides guidelines for contributing to the GitHub Safe Merge & Deploy Workflow demo.

## 🚀 Quick Start

1. **Fork the repository**
2. **Clone your fork**: `git clone https://github.com/your-username/dev-workflow-poc.git`
3. **Start development with Docker**: `npm run dev`
4. **Or setup local development**: `npm run install:all && npm run dev:backend & npm run dev:frontend`

## 📋 Development Guidelines

### Code Style

- **JavaScript/Node.js**: Follow ESLint and Prettier configurations
- **React**: Use functional components with hooks
- **Git**: Use conventional commit messages (see below)
- **Documentation**: Keep README and code comments up to date

### Commit Message Format

We use [Conventional Commits](https://www.conventionalcommits.org/) for commit messages:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**Types:**
- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation only changes
- `style`: Changes that do not affect the meaning of the code
- `refactor`: A code change that neither fixes a bug nor adds a feature
- `perf`: A code change that improves performance
- `test`: Adding missing tests or correcting existing tests
- `chore`: Changes to the build process or auxiliary tools

**Examples:**
```
feat: add new validation rule for feature branches
fix: resolve issue with tag validation on empty repositories
docs: update README with new setup instructions
test: add integration tests for health endpoints
```

### Branch Naming

- Feature branches: `feature/description`
- Bug fixes: `fix/description`
- Documentation: `docs/description`
- Hotfixes: `hotfix/description`

## 🧪 Testing

### Running Tests

```bash
# Run all tests
npm test

# Run backend tests only
npm run test:backend

# Run frontend tests only
npm run test:frontend

# Run tests with coverage
cd backend && npm test -- --coverage
cd frontend && npm test -- --coverage
```

### Test Guidelines

- Write tests for all new features
- Ensure existing tests pass before submitting PR
- Aim for >80% code coverage
- Use descriptive test names
- Test both success and error scenarios

## 🔧 Development Workflow

### 1. Setup Local Environment

```bash
# Setup git configuration
npm run setup:git

# Start development with Docker (recommended)
npm run dev

# Or for local development without Docker:
npm run install:all
npm run dev:backend & npm run dev:frontend
```

### 2. Making Changes

1. Create a feature branch from `master`
2. Make your changes
3. Run tests and linting
4. Commit with conventional commit message
5. Push to your fork
6. Create a pull request

### 3. Validation

Before submitting a PR, ensure:

- [ ] All tests pass
- [ ] Code passes linting (`npm run lint`)
- [ ] Code is formatted (`npm run format`)
- [ ] Commit messages follow conventional format
- [ ] Documentation is updated if needed

### 4. Pull Request Process

1. **Title**: Use conventional commit format
2. **Description**: Explain what and why (not how)
3. **Checklist**: Use the provided PR template
4. **Screenshots**: Include for UI changes
5. **Testing**: Describe how to test your changes

## 🐛 Bug Reports

When reporting bugs, please include:

- **Environment**: OS, Node.js version, browser (if applicable)
- **Steps to reproduce**: Clear, step-by-step instructions
- **Expected behavior**: What should happen
- **Actual behavior**: What actually happens
- **Screenshots**: If applicable
- **Console logs**: Any error messages

## 💡 Feature Requests

When requesting features, please include:

- **Use case**: Why is this feature needed?
- **Proposed solution**: How should it work?
- **Alternatives considered**: What other approaches were considered?
- **Mockups**: If it's a UI feature

## 🔒 Security

- **Security issues**: Report privately to maintainers
- **Dependencies**: Keep dependencies up to date
- **Secrets**: Never commit secrets or API keys
- **Validation**: Always validate user input

## 📚 Documentation

### Updating Documentation

- Keep README.md up to date
- Update API documentation when endpoints change
- Add examples for new features
- Include troubleshooting guides

### Documentation Structure

```
docs/
├── ARCHITECTURE.md      # Technical architecture
├── DEPLOYMENT.md        # Deployment guide
├── API.md              # API documentation
└── TROUBLESHOOTING.md  # Common issues and solutions
```

## 🤝 Code Review

### Review Guidelines

- Be constructive and respectful
- Focus on code quality and functionality
- Suggest improvements, don't just point out issues
- Consider security implications
- Check for test coverage

### Review Checklist

- [ ] Code follows project style guidelines
- [ ] Tests are included and pass
- [ ] Documentation is updated
- [ ] No security vulnerabilities introduced
- [ ] Performance impact considered
- [ ] Error handling is appropriate

## 🚀 Release Process

### For Maintainers

1. **Merge PRs**: Only merge PRs that pass all checks
2. **Create Release**: Use release-please for automated releases
3. **Tag Versions**: Follow semantic versioning
4. **Update Changelog**: Release-please handles this automatically

### Release Types

- **Patch**: Bug fixes (0.1.0 → 0.1.1)
- **Minor**: New features (0.1.0 → 0.2.0)
- **Major**: Breaking changes (0.1.0 → 1.0.0)

## 📞 Getting Help

- **Issues**: Use GitHub issues for bugs and feature requests
- **Discussions**: Use GitHub discussions for questions
- **Documentation**: Check the docs folder first
- **Examples**: Look at existing code for patterns

## 🏆 Recognition

Contributors will be recognized in:

- GitHub contributors list
- Release notes (for significant contributions)
- Project documentation

Thank you for contributing to making this project better! 🎉 