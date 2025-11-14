#!/bin/bash

# Clean script for AI Content Curator
# Removes build artifacts and dependencies

set -e  # Exit on error

echo "🧹 Cleaning AI Content Curator..."
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Clean node_modules
echo -e "${BLUE}Removing node_modules...${NC}"
find . -name "node_modules" -type d -prune -exec rm -rf '{}' +
echo -e "${GREEN}✅ node_modules removed${NC}"
echo ""

# Clean build artifacts
echo -e "${BLUE}Removing build artifacts...${NC}"
find . -name "dist" -type d -prune -exec rm -rf '{}' +
find . -name "build" -type d -prune -exec rm -rf '{}' +
find . -name ".next" -type d -prune -exec rm -rf '{}' +
find . -name "coverage" -type d -prune -exec rm -rf '{}' +
find . -name ".nyc_output" -type d -prune -exec rm -rf '{}' +
echo -e "${GREEN}✅ Build artifacts removed${NC}"
echo ""

# Clean logs
echo -e "${BLUE}Removing log files...${NC}"
find . -name "*.log" -type f -delete
echo -e "${GREEN}✅ Log files removed${NC}"
echo ""

# Clean test artifacts
echo -e "${BLUE}Removing test artifacts...${NC}"
find . -name "playwright-report" -type d -prune -exec rm -rf '{}' +
find . -name "test-results" -type d -prune -exec rm -rf '{}' +
echo -e "${GREEN}✅ Test artifacts removed${NC}"
echo ""

# Clean TypeScript build info
echo -e "${BLUE}Removing TypeScript build info...${NC}"
find . -name "*.tsbuildinfo" -type f -delete
echo -e "${GREEN}✅ TypeScript build info removed${NC}"
echo ""

echo -e "${GREEN}✨ Cleanup complete!${NC}"
echo ""
echo "To reinstall dependencies, run: npm install"
