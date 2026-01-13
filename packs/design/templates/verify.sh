#!/usr/bin/env bash
#
# verify.sh - Design Project Verification Script
#
# This script runs verification checks for design deliverables.
# Unlike code packs, design verification focuses on artifact existence,
# completeness, and documentation quality.
#
# Usage:
#   ./scripts/verify.sh          # Run all checks
#   ./scripts/verify.sh --quick  # Skip documentation checks
#

set -e

# Configuration - Customize these for your project
DESIGN_DIR="${DESIGN_DIR:-design}"
DOCS_DIR="${DOCS_DIR:-docs}"
EXPORTS_DIR="${EXPORTS_DIR:-$DESIGN_DIR/exports}"
TOKENS_FILE="${TOKENS_FILE:-$DESIGN_DIR/tokens.json}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse arguments
QUICK_MODE=false
VERBOSE=false
while [[ $# -gt 0 ]]; do
    case $1 in
        --quick|-q)
            QUICK_MODE=true
            shift
            ;;
        --verbose|-v)
            VERBOSE=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

echo -e "${BLUE}=== Design Project Verification ===${NC}"
echo

# Track results
PASSED=0
FAILED=0
WARNINGS=0

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

run_warning() {
    local name="$1"
    local command="$2"

    echo -e "${BLUE}→ $name${NC}"

    if eval "$command"; then
        echo -e "  ${GREEN}✓ PASS${NC}"
        ((PASSED++))
        return 0
    else
        echo -e "  ${YELLOW}⚠ WARNING${NC}"
        ((WARNINGS++))
        return 0
    fi
}

# 1. Check Design Directory Structure
echo -e "${YELLOW}1. Directory Structure${NC}"
run_check "Design directory exists" "[ -d '$DESIGN_DIR' ]"
run_warning "Components directory exists" "[ -d '$DESIGN_DIR/components' ]"
run_warning "Screens directory exists" "[ -d '$DESIGN_DIR/screens' ]"
echo

# 2. Check Design Tokens
echo -e "${YELLOW}2. Design Tokens${NC}"
if [ -f "$TOKENS_FILE" ]; then
    run_check "Tokens file exists" "[ -f '$TOKENS_FILE' ]"
    run_check "Tokens file is valid JSON" "python3 -c 'import json; json.load(open(\"$TOKENS_FILE\"))' 2>/dev/null || jq . '$TOKENS_FILE' > /dev/null 2>&1"
else
    echo -e "  ${YELLOW}⚠ No tokens file found at $TOKENS_FILE${NC}"
    ((WARNINGS++))
fi
echo

# 3. Check for Exports
echo -e "${YELLOW}3. Asset Exports${NC}"
if [ -d "$EXPORTS_DIR" ]; then
    run_check "Exports directory exists" "[ -d '$EXPORTS_DIR' ]"

    # Count exported assets
    SVG_COUNT=$(find "$EXPORTS_DIR" -name "*.svg" 2>/dev/null | wc -l | tr -d ' ')
    PNG_COUNT=$(find "$EXPORTS_DIR" -name "*.png" 2>/dev/null | wc -l | tr -d ' ')

    echo "   SVG files: $SVG_COUNT"
    echo "   PNG files: $PNG_COUNT"

    if [ "$SVG_COUNT" -gt 0 ] || [ "$PNG_COUNT" -gt 0 ]; then
        echo -e "  ${GREEN}✓ Assets exported${NC}"
        ((PASSED++))
    else
        echo -e "  ${YELLOW}⚠ No exported assets found${NC}"
        ((WARNINGS++))
    fi
else
    echo -e "  ${YELLOW}⚠ Exports directory not found${NC}"
    ((WARNINGS++))
fi
echo

# 4. Check Documentation
if [ "$QUICK_MODE" = false ]; then
    echo -e "${YELLOW}4. Documentation${NC}"

    # Check for component specifications
    if [ -d "$DESIGN_DIR/components" ]; then
        SPEC_COUNT=$(find "$DESIGN_DIR/components" -name "*.md" -o -name "specs.md" 2>/dev/null | wc -l | tr -d ' ')
        if [ "$SPEC_COUNT" -gt 0 ]; then
            echo -e "  ${GREEN}✓ Found $SPEC_COUNT component spec files${NC}"
            ((PASSED++))
        else
            echo -e "  ${YELLOW}⚠ No component specifications found${NC}"
            ((WARNINGS++))
        fi
    fi

    # Check for handoff documentation
    HANDOFF_FILES=$(find "$DOCS_DIR" -name "*handoff*" -o -name "*spec*" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$HANDOFF_FILES" -gt 0 ]; then
        echo -e "  ${GREEN}✓ Found $HANDOFF_FILES handoff documents${NC}"
        ((PASSED++))
    else
        echo -e "  ${YELLOW}⚠ No handoff documentation found${NC}"
        ((WARNINGS++))
    fi
    echo
fi

# 5. Check for Figma/Design Tool Links
echo -e "${YELLOW}5. Design File References${NC}"
FIGMA_REFS=$(grep -r "figma.com" "$DOCS_DIR" "$DESIGN_DIR" 2>/dev/null | wc -l | tr -d ' ')
SKETCH_REFS=$(grep -r "sketch.cloud" "$DOCS_DIR" "$DESIGN_DIR" 2>/dev/null | wc -l | tr -d ' ')

if [ "$FIGMA_REFS" -gt 0 ] || [ "$SKETCH_REFS" -gt 0 ]; then
    echo -e "  ${GREEN}✓ Found design file references${NC}"
    echo "   Figma links: $FIGMA_REFS"
    echo "   Sketch links: $SKETCH_REFS"
    ((PASSED++))
else
    echo -e "  ${YELLOW}⚠ No design file references found in docs${NC}"
    ((WARNINGS++))
fi
echo

# 6. Accessibility Notes Check
echo -e "${YELLOW}6. Accessibility Documentation${NC}"
A11Y_REFS=$(grep -ri "accessibility\|wcag\|contrast\|aria" "$DESIGN_DIR" "$DOCS_DIR" 2>/dev/null | wc -l | tr -d ' ')
if [ "$A11Y_REFS" -gt 5 ]; then
    echo -e "  ${GREEN}✓ Accessibility documented ($A11Y_REFS references)${NC}"
    ((PASSED++))
else
    echo -e "  ${YELLOW}⚠ Limited accessibility documentation ($A11Y_REFS references)${NC}"
    ((WARNINGS++))
fi
echo

# Summary
echo -e "${BLUE}=== Summary ===${NC}"
echo -e "Passed:   ${GREEN}$PASSED${NC}"
echo -e "Warnings: ${YELLOW}$WARNINGS${NC}"
echo -e "Failed:   ${RED}$FAILED${NC}"
echo

if [ $FAILED -gt 0 ]; then
    echo -e "${RED}=== VERIFICATION FAILED ===${NC}"
    exit 1
elif [ $WARNINGS -gt 3 ]; then
    echo -e "${YELLOW}=== VERIFICATION PASSED WITH WARNINGS ===${NC}"
    echo "Consider addressing warnings before handoff."
    exit 0
else
    echo -e "${GREEN}=== ALL CHECKS PASSED ===${NC}"
    exit 0
fi
