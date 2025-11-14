#!/bin/bash

# Setup script for AI Content Curator
# This script sets up the development environment

set -e  # Exit on error

echo "🚀 Setting up AI Content Curator..."
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check Node.js version
echo -e "${BLUE}Checking Node.js version...${NC}"
NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
    echo -e "${RED}❌ Node.js 18 or higher is required. Current version: $(node -v)${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Node.js version: $(node -v)${NC}"
echo ""

# Check npm version
echo -e "${BLUE}Checking npm version...${NC}"
echo -e "${GREEN}✅ npm version: $(npm -v)${NC}"
echo ""

# Install dependencies
echo -e "${BLUE}Installing dependencies...${NC}"
npm install
echo -e "${GREEN}✅ Dependencies installed${NC}"
echo ""

# Check for .env file
if [ ! -f .env ]; then
    echo -e "${BLUE}Creating .env file from .env.example...${NC}"
    if [ -f .env.example ]; then
        cp .env.example .env
        echo -e "${GREEN}✅ .env file created${NC}"
        echo -e "${RED}⚠️  Please update .env with your actual configuration${NC}"
    else
        echo -e "${RED}❌ .env.example not found${NC}"
    fi
else
    echo -e "${GREEN}✅ .env file already exists${NC}"
fi
echo ""

# Build all workspaces
echo -e "${BLUE}Building all workspaces...${NC}"
npm run build
echo -e "${GREEN}✅ Build complete${NC}"
echo ""

# Run tests
echo -e "${BLUE}Running tests...${NC}"
npm test || echo -e "${RED}⚠️  Some tests failed. Please review.${NC}"
echo ""

echo -e "${GREEN}✨ Setup complete!${NC}"
echo ""
echo "Next steps:"
echo "1. Update .env with your configuration"
echo "2. Start MongoDB (or use MongoDB Atlas)"
echo "3. Start Redis (optional, for caching)"
echo "4. Run 'npm run dev' to start development servers"
echo ""
echo "For more information, see README.md"
