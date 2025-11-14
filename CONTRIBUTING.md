# Contributing to AI Content Curator

Thank you for your interest in contributing to the AI Content Curator project! This document provides guidelines and instructions for contributing.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Testing Requirements](#testing-requirements)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Reporting Bugs](#reporting-bugs)
- [Suggesting Enhancements](#suggesting-enhancements)

## Code of Conduct

This project adheres to a Code of Conduct that all contributors are expected to follow. Please read [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) before contributing.

## Getting Started

### Prerequisites

- **Node.js** 18.x or higher
- **npm** 9.x or higher
- **MongoDB** 6.x or higher (or MongoDB Atlas account)
- **Redis** (optional, for caching)
- **Docker** (optional, for containerized development)
- **Python** 3.8+ (optional, for Python crawler)

### Initial Setup

1. **Fork the repository**
   ```bash
   # Click the "Fork" button on GitHub
   ```

2. **Clone your fork**
   ```bash
   git clone https://github.com/YOUR_USERNAME/AI-Content-Curator-Monorepo.git
   cd AI-Content-Curator-Monorepo
   ```

3. **Add upstream remote**
   ```bash
   git remote add upstream https://github.com/SynthoraAI-AI-News-Content-Curator/AI-Content-Curator-Monorepo.git
   ```

4. **Install dependencies**
   ```bash
   npm install
   ```

5. **Set up environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

6. **Build all workspaces**
   ```bash
   npm run build
   ```

## Development Workflow

### Creating a Feature Branch

```bash
# Update your main branch
git checkout main
git pull upstream main

# Create a feature branch
git checkout -b feature/your-feature-name
```

### Running Development Servers

```bash
# Run all services
npm run dev

# Or run individual services
npm run dev:backend
npm run dev:frontend
npm run dev:crawler
npm run dev:newsletters
```

### Using Make Commands

```bash
# View all available commands
make help

# Install dependencies
make install

# Run tests
make test

# Build all services
make build

# Clean build artifacts
make clean
```

## Coding Standards

### TypeScript/JavaScript

- **Style Guide**: Follow the [Airbnb JavaScript Style Guide](https://github.com/airbnb/javascript)
- **Linting**: Use ESLint (run `npm run lint`)
- **Formatting**: Use Prettier (run `npm run format`)
- **Type Safety**: Ensure all TypeScript code is strictly typed

#### File Naming Conventions

- **Components**: PascalCase (e.g., `ArticleCard.tsx`)
- **Utilities**: camelCase (e.g., `apiClient.ts`)
- **Models**: camelCase with `.model.ts` suffix (e.g., `user.model.ts`)
- **Services**: camelCase with `.service.ts` suffix (e.g., `crawler.service.ts`)
- **Tests**: Same as source file with `.spec.ts` or `.test.ts` suffix

#### Code Organization

```typescript
// 1. External imports
import React from 'react';
import { Schema, model } from 'mongoose';

// 2. Internal imports (absolute paths)
import { ApiClient } from '@/lib/apiClient';

// 3. Type definitions
interface User {
  id: string;
  email: string;
}

// 4. Constants
const API_BASE_URL = process.env.API_URL;

// 5. Main code
export class UserService {
  // ...
}
```

### Python

- **Style Guide**: Follow [PEP 8](https://www.python.org/dev/peps/pep-0008/)
- **Type Hints**: Use type hints for all functions
- **Docstrings**: Use Google-style docstrings

## Testing Requirements

All contributions must include appropriate tests:

### Unit Tests

- Test individual functions and components
- Aim for >80% code coverage
- Use Jest for TypeScript/JavaScript
- Use pytest for Python

```bash
# Run all tests
npm test

# Run tests for specific workspace
npm run test:backend
npm run test:frontend
npm run test:crawler

# Run with coverage
npm run test:coverage
```

### Integration Tests

- Test interactions between services
- Mock external dependencies
- Use `mongodb-memory-server` for database tests

### End-to-End Tests

- Use Playwright for frontend E2E tests
- Test critical user workflows

```bash
npm run test:e2e
```

## Commit Guidelines

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification.

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation changes
- **style**: Code style changes (formatting, semicolons, etc.)
- **refactor**: Code refactoring
- **perf**: Performance improvements
- **test**: Adding or updating tests
- **chore**: Maintenance tasks
- **ci**: CI/CD changes

### Examples

```bash
feat(frontend): add dark mode toggle to settings page

Implement a theme switcher component that allows users to toggle
between light and dark modes. The preference is saved to localStorage.

Closes #123
```

```bash
fix(crawler): handle timeout errors in Puppeteer scraper

Add proper error handling and retry logic for timeout errors
when scraping dynamic content.

Fixes #456
```

## Pull Request Process

### Before Submitting

1. **Update your branch**
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

2. **Run all checks**
   ```bash
   npm run lint
   npm run format
   npm run typecheck
   npm test
   npm run build
   ```

3. **Update documentation**
   - Update README.md if adding features
   - Add JSDoc/TSDoc comments
   - Update API documentation if applicable

### Submitting the PR

1. **Push your changes**
   ```bash
   git push origin feature/your-feature-name
   ```

2. **Create Pull Request**
   - Use a clear, descriptive title
   - Fill out the PR template completely
   - Link related issues
   - Add screenshots/videos for UI changes
   - Mark as draft if work in progress

3. **Code Review**
   - Address reviewer feedback promptly
   - Keep discussions professional and constructive
   - Update your branch if main has changed

### PR Checklist

- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex logic
- [ ] Documentation updated
- [ ] Tests added/updated and passing
- [ ] No console errors or warnings
- [ ] Build succeeds
- [ ] Commits follow conventional commits format

## Reporting Bugs

### Before Reporting

1. Check existing issues for duplicates
2. Ensure you're using the latest version
3. Verify the bug is reproducible

### Bug Report Template

Use the bug report template when creating an issue. Include:

- Clear, descriptive title
- Steps to reproduce
- Expected behavior
- Actual behavior
- Screenshots/logs
- Environment details (OS, Node version, browser, etc.)

## Suggesting Enhancements

### Enhancement Proposal Template

- **Problem**: Describe the problem you're trying to solve
- **Solution**: Describe your proposed solution
- **Alternatives**: Describe alternatives you've considered
- **Additional Context**: Add any other context or screenshots

## Project-Specific Guidelines

### Monorepo Structure

This is an npm workspaces monorepo with the following structure:

```
AI-Content-Curator-Monorepo/
├── backend/          # Express.js + Next.js API
├── frontend/         # Next.js frontend
├── crawler/          # Web crawler service
├── newsletters/      # Newsletter service
└── python_crawler/   # Python-based crawler
```

### Adding Dependencies

```bash
# Add to root workspace
npm install -W package-name

# Add to specific workspace
npm install package-name -w backend
npm install package-name -w frontend
```

### Database Migrations

- Create migration scripts in `backend/src/migrations/`
- Document migration steps in the migration file
- Test migrations on a copy of production data

### API Changes

- Update OpenAPI/Swagger documentation
- Maintain backward compatibility when possible
- Document breaking changes in PR description

## Questions?

If you have questions:

1. Check the [README.md](README.md)
2. Search existing issues
3. Ask in discussions
4. Contact maintainers

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.

Thank you for contributing! 🎉
