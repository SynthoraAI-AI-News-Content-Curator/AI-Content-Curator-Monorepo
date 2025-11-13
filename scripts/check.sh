#!/bin/bash

# Check script for AI Content Curator
# Runs all quality checks (lint, typecheck, test)

set -e  # Exit on error

echo "🔍 Running all checks..."
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

FAILED=0

# Lint check
echo -e "${BLUE}1. Running linter...${NC}"
if npm run lint; then
    echo -e "${GREEN}✅ Linting passed${NC}"
else
    echo -e "${RED}❌ Linting failed${NC}"
    FAILED=1
fi
echo ""

# Type check
echo -e "${BLUE}2. Running type checker...${NC}"
if npm run typecheck; then
    echo -e "${GREEN}✅ Type checking passed${NC}"
else
    echo -e "${RED}❌ Type checking failed${NC}"
    FAILED=1
fi
echo ""

# Format check
echo -e "${BLUE}3. Checking code formatting...${NC}"
if npm run format:check; then
    echo -e "${GREEN}✅ Formatting check passed${NC}"
else
    echo -e "${RED}❌ Formatting check failed. Run 'npm run format' to fix${NC}"
    FAILED=1
fi
echo ""

# Build check
echo -e "${BLUE}4. Running build...${NC}"
if npm run build; then
    echo -e "${GREEN}✅ Build successful${NC}"
else
    echo -e "${RED}❌ Build failed${NC}"
    FAILED=1
fi
echo ""

# Tests
echo -e "${BLUE}5. Running tests...${NC}"
if npm test; then
    echo -e "${GREEN}✅ All tests passed${NC}"
else
    echo -e "${RED}❌ Some tests failed${NC}"
    FAILED=1
fi
echo ""

# Security audit
echo -e "${BLUE}6. Running security audit...${NC}"
if npm audit --audit-level=moderate; then
    echo -e "${GREEN}✅ No security vulnerabilities found${NC}"
else
    echo -e "${RED}⚠️  Security vulnerabilities detected. Run 'npm audit fix' to resolve${NC}"
    # Don't fail the check for audit issues, just warn
fi
echo ""

# Final result
echo "================================"
if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✨ All checks passed!${NC}"
    echo "================================"
    exit 0
else
    echo -e "${RED}❌ Some checks failed. Please fix the issues above.${NC}"
    echo "================================"
    exit 1
fi
