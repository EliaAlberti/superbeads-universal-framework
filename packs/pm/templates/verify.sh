#!/usr/bin/env bash
#
# verify.sh - PM Project Verification Script
#
# This script runs verification checks for PM deliverables.
# Unlike code packs, PM verification focuses on document completeness,
# quality standards, and linkage between artifacts.
#
# Usage:
#   ./scripts/verify.sh          # Run all checks
#   ./scripts/verify.sh --quick  # Skip detailed quality checks
#

set -e

# Configuration - Customize these for your project
DOCS_DIR="${DOCS_DIR:-docs}"
STORIES_DIR="${STORIES_DIR:-$DOCS_DIR/stories}"
PRD_DIR="${PRD_DIR:-$DOCS_DIR/prd}"
ROADMAP_DIR="${ROADMAP_DIR:-$DOCS_DIR/roadmap}"
METRICS_DIR="${METRICS_DIR:-$DOCS_DIR/metrics}"

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

echo -e "${BLUE}=== PM Project Verification ===${NC}"
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

# 1. Check Directory Structure
echo -e "${YELLOW}1. Directory Structure${NC}"
run_check "Docs directory exists" "[ -d '$DOCS_DIR' ]"
run_warning "Stories directory exists" "[ -d '$STORIES_DIR' ]"
run_warning "PRD directory exists" "[ -d '$PRD_DIR' ]"
echo

# 2. Check for User Stories
echo -e "${YELLOW}2. User Stories${NC}"
if [ -d "$STORIES_DIR" ]; then
    STORY_COUNT=$(find "$STORIES_DIR" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    echo "   Stories found: $STORY_COUNT"

    if [ "$STORY_COUNT" -gt 0 ]; then
        echo -e "  ${GREEN}✓ User stories exist${NC}"
        ((PASSED++))

        # Check for acceptance criteria
        AC_COUNT=$(grep -r "Given\|When\|Then" "$STORIES_DIR" 2>/dev/null | wc -l | tr -d ' ')
        if [ "$AC_COUNT" -gt 0 ]; then
            echo -e "  ${GREEN}✓ Acceptance criteria found (Given/When/Then)${NC}"
            ((PASSED++))
        else
            echo -e "  ${YELLOW}⚠ No Given/When/Then acceptance criteria found${NC}"
            ((WARNINGS++))
        fi
    else
        echo -e "  ${YELLOW}⚠ No user stories found${NC}"
        ((WARNINGS++))
    fi
else
    echo -e "  ${YELLOW}⚠ Stories directory not found${NC}"
    ((WARNINGS++))
fi
echo

# 3. Check INVEST Criteria in Stories
if [ "$QUICK_MODE" = false ] && [ -d "$STORIES_DIR" ]; then
    echo -e "${YELLOW}3. Story Quality (INVEST)${NC}"

    # Check for story format
    STORY_FORMAT=$(grep -r "As a\|I want\|So that" "$STORIES_DIR" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$STORY_FORMAT" -gt 0 ]; then
        echo -e "  ${GREEN}✓ Story format found ($STORY_FORMAT occurrences)${NC}"
        ((PASSED++))
    else
        echo -e "  ${YELLOW}⚠ No standard story format found${NC}"
        ((WARNINGS++))
    fi

    # Check for estimates
    ESTIMATES=$(grep -ri "story points\|estimate\|points:" "$STORIES_DIR" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$ESTIMATES" -gt 0 ]; then
        echo -e "  ${GREEN}✓ Story estimates found${NC}"
        ((PASSED++))
    else
        echo -e "  ${YELLOW}⚠ No story estimates found${NC}"
        ((WARNINGS++))
    fi
    echo
fi

# 4. Check PRDs
echo -e "${YELLOW}4. PRD Documentation${NC}"
if [ -d "$PRD_DIR" ]; then
    PRD_COUNT=$(find "$PRD_DIR" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    echo "   PRDs found: $PRD_COUNT"

    if [ "$PRD_COUNT" -gt 0 ]; then
        echo -e "  ${GREEN}✓ PRD documentation exists${NC}"
        ((PASSED++))

        # Check for key sections
        for section in "Problem" "Success Metrics" "Requirements" "Scope"; do
            SECTION_COUNT=$(grep -ri "$section" "$PRD_DIR" 2>/dev/null | wc -l | tr -d ' ')
            if [ "$SECTION_COUNT" -gt 0 ]; then
                [ "$VERBOSE" = true ] && echo "   Found: $section"
            fi
        done
    else
        echo -e "  ${YELLOW}⚠ No PRDs found${NC}"
        ((WARNINGS++))
    fi
else
    echo -e "  ${YELLOW}⚠ PRD directory not found${NC}"
    ((WARNINGS++))
fi
echo

# 5. Check Metrics Documentation
echo -e "${YELLOW}5. Metrics & Success Criteria${NC}"
METRICS_REFS=$(grep -ri "metric\|KPI\|OKR\|success" "$DOCS_DIR" 2>/dev/null | wc -l | tr -d ' ')
if [ "$METRICS_REFS" -gt 5 ]; then
    echo -e "  ${GREEN}✓ Metrics documented ($METRICS_REFS references)${NC}"
    ((PASSED++))
else
    echo -e "  ${YELLOW}⚠ Limited metrics documentation ($METRICS_REFS references)${NC}"
    ((WARNINGS++))
fi
echo

# 6. Check Roadmap
echo -e "${YELLOW}6. Roadmap Documentation${NC}"
if [ -d "$ROADMAP_DIR" ]; then
    ROADMAP_COUNT=$(find "$ROADMAP_DIR" -name "*.md" -o -name "*.json" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$ROADMAP_COUNT" -gt 0 ]; then
        echo -e "  ${GREEN}✓ Roadmap documentation exists${NC}"
        ((PASSED++))
    else
        echo -e "  ${YELLOW}⚠ Roadmap directory empty${NC}"
        ((WARNINGS++))
    fi
else
    # Check for roadmap in docs root
    ROADMAP_FILES=$(find "$DOCS_DIR" -maxdepth 1 -name "*roadmap*" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$ROADMAP_FILES" -gt 0 ]; then
        echo -e "  ${GREEN}✓ Roadmap file exists${NC}"
        ((PASSED++))
    else
        echo -e "  ${YELLOW}⚠ No roadmap documentation found${NC}"
        ((WARNINGS++))
    fi
fi
echo

# 7. Check Cross-References
echo -e "${YELLOW}7. Document Linkage${NC}"
# Check for internal links in markdown
INTERNAL_LINKS=$(grep -r "\[.*\](.*\.md)" "$DOCS_DIR" 2>/dev/null | wc -l | tr -d ' ')
if [ "$INTERNAL_LINKS" -gt 5 ]; then
    echo -e "  ${GREEN}✓ Documents are linked ($INTERNAL_LINKS cross-references)${NC}"
    ((PASSED++))
else
    echo -e "  ${YELLOW}⚠ Limited cross-referencing between documents${NC}"
    ((WARNINGS++))
fi

# Check for design links
DESIGN_LINKS=$(grep -ri "figma\|design\|prototype" "$DOCS_DIR" 2>/dev/null | wc -l | tr -d ' ')
if [ "$DESIGN_LINKS" -gt 0 ]; then
    echo -e "  ${GREEN}✓ Design references found${NC}"
    ((PASSED++))
else
    echo -e "  ${YELLOW}⚠ No design references found${NC}"
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
    echo "Consider addressing warnings before proceeding."
    exit 0
else
    echo -e "${GREEN}=== ALL CHECKS PASSED ===${NC}"
    exit 0
fi
