#!/usr/bin/env bash
#
# verify.sh - Next.js/React Project Verification Script
#
# This script runs all verification checks for a web project.
# It checks linting, type checking, tests, and build.
#
# Usage:
#   ./scripts/verify.sh          # Run all checks
#   ./scripts/verify.sh --quick  # Skip build step
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse arguments
QUICK_MODE=false
while [[ $# -gt 0 ]]; do
    case $1 in
        --quick|-q)
            QUICK_MODE=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

echo -e "${BLUE}=== Next.js Project Verification ===${NC}"
echo

# Track results
PASSED=0
FAILED=0

run_check() {
    local name="$1"
    local command="$2"

    echo -e "${BLUE}→ $name${NC}"

    if eval "$command"; then
        echo -e "  ${GREEN}✓ PASS${NC}"
        ((PASSED++))
        return 0
    else
        echo -e "  ${RED}✗ FAIL${NC}"
        ((FAILED++))
        return 1
    fi
}

# Detect package manager
if [ -f "pnpm-lock.yaml" ]; then
    PM="pnpm"
elif [ -f "bun.lockb" ]; then
    PM="bun"
elif [ -f "yarn.lock" ]; then
    PM="yarn"
else
    PM="npm"
fi

echo -e "${YELLOW}Using package manager: ${PM}${NC}"
echo

# 1. Check Node version
echo -e "${YELLOW}1. Environment Check${NC}"
echo "   Node: $(node --version 2>&1)"
echo "   Package Manager: ${PM}"
echo

# 2. Linting
echo -e "${YELLOW}2. Linting${NC}"
if [ -f "package.json" ] && grep -q '"lint"' package.json; then
    run_check "ESLint" "${PM} run lint"
else
    echo -e "  ${YELLOW}⚠ No lint script found, skipping${NC}"
fi
echo

# 3. Type checking
echo -e "${YELLOW}3. Type Checking${NC}"
if [ -f "package.json" ] && grep -q '"typecheck"' package.json; then
    run_check "TypeScript" "${PM} run typecheck"
elif [ -f "tsconfig.json" ]; then
    run_check "TypeScript" "npx tsc --noEmit"
else
    echo -e "  ${YELLOW}⚠ No TypeScript config found, skipping${NC}"
fi
echo

# 4. Tests
echo -e "${YELLOW}4. Tests${NC}"
if [ -f "package.json" ] && grep -q '"test"' package.json; then
    if [ "$QUICK_MODE" = true ]; then
        run_check "Vitest (quick)" "${PM} run test -- --run"
    else
        run_check "Vitest" "${PM} run test -- --run"
    fi
else
    echo -e "  ${YELLOW}⚠ No test script found, skipping${NC}"
fi
echo

# 5. Build (skip in quick mode)
if [ "$QUICK_MODE" = false ]; then
    echo -e "${YELLOW}5. Build${NC}"
    if [ -f "package.json" ] && grep -q '"build"' package.json; then
        run_check "Next.js Build" "${PM} run build"
    else
        echo -e "  ${YELLOW}⚠ No build script found, skipping${NC}"
    fi
    echo
fi

# Summary
echo -e "${BLUE}=== Summary ===${NC}"
echo -e "Passed: ${GREEN}$PASSED${NC}"
echo -e "Failed: ${RED}$FAILED${NC}"
echo

if [ $FAILED -gt 0 ]; then
    echo -e "${RED}=== VERIFICATION FAILED ===${NC}"
    exit 1
else
    echo -e "${GREEN}=== ALL CHECKS PASSED ===${NC}"
    exit 0
fi
