#!/bin/bash

# Development script for AI Content Curator
# Starts all services in development mode

echo "🚀 Starting AI Content Curator in development mode..."
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check if .env exists
if [ ! -f .env ]; then
    echo -e "${YELLOW}⚠️  .env file not found. Creating from .env.example...${NC}"
    if [ -f .env.example ]; then
        cp .env.example .env
        echo -e "${GREEN}✅ .env file created. Please update with your configuration.${NC}"
        echo ""
    else
        echo -e "${RED}❌ .env.example not found. Please create .env manually.${NC}"
        exit 1
    fi
fi

# Check for dependencies
if [ ! -d "node_modules" ]; then
    echo -e "${BLUE}Installing dependencies...${NC}"
    npm install
    echo ""
fi

echo -e "${BLUE}Services will start on the following ports:${NC}"
echo "  - Frontend:   http://localhost:3000"
echo "  - Backend:    http://localhost:3001"
echo "  - Crawler:    http://localhost:3002"
echo "  - Newsletter: http://localhost:3003"
echo ""

echo -e "${YELLOW}Press Ctrl+C to stop all services${NC}"
echo ""

# Start all services
npm run dev
