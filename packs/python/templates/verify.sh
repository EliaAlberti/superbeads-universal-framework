#!/usr/bin/env bash
#
# verify.sh - Python Project Verification Script
#
# This script runs all verification checks for a Python project.
# It checks linting, type checking, and tests.
#
# Usage:
#   ./scripts/verify.sh          # Run all checks
#   ./scripts/verify.sh --quick  # Skip slow tests
#

set -e

# Configuration - Customize these for your project
SRC_DIR="${SRC_DIR:-src}"
TEST_DIR="${TEST_DIR:-tests}"
PYTHON_VERSION="${PYTHON_VERSION:-3.11}"

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

echo -e "${BLUE}=== Python Project Verification ===${NC}"
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

# 1. Check Python version
echo -e "${YELLOW}1. Environment Check${NC}"
echo "   Python: $(python --version 2>&1)"
echo

# 2. Linting with ruff
echo -e "${YELLOW}2. Linting${NC}"
if command -v ruff &> /dev/null; then
    run_check "ruff check" "ruff check $SRC_DIR $TEST_DIR"
    run_check "ruff format --check" "ruff format --check $SRC_DIR $TEST_DIR"
else
    echo -e "  ${YELLOW}⚠ ruff not installed, skipping${NC}"
fi
echo

# 3. Type checking with mypy
echo -e "${YELLOW}3. Type Checking${NC}"
if command -v mypy &> /dev/null; then
    run_check "mypy" "mypy $SRC_DIR"
else
    echo -e "  ${YELLOW}⚠ mypy not installed, skipping${NC}"
fi
echo

# 4. Tests with pytest
echo -e "${YELLOW}4. Tests${NC}"
if command -v pytest &> /dev/null; then
    if [ "$QUICK_MODE" = true ]; then
        run_check "pytest (quick)" "pytest $TEST_DIR -x -q --ignore=$TEST_DIR/integration"
    else
        run_check "pytest" "pytest $TEST_DIR -v --cov=$SRC_DIR --cov-report=term-missing"
    fi
else
    echo -e "  ${YELLOW}⚠ pytest not installed, skipping${NC}"
fi
echo

# 5. Security check (optional)
echo -e "${YELLOW}5. Security${NC}"
if command -v bandit &> /dev/null; then
    run_check "bandit" "bandit -r $SRC_DIR -q"
else
    echo -e "  ${YELLOW}⚠ bandit not installed, skipping${NC}"
fi
echo

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
