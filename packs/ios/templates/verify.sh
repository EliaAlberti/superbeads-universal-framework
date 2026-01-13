#!/bin/bash
# SuperBeads iOS Verification Script
# Runs build and test verification for iOS projects
# Usage: ./scripts/verify.sh [options]

set -e

# Configuration - Update these for your project
SCHEME="${SCHEME:-YourAppScheme}"
DESTINATION="${DESTINATION:-platform=iOS Simulator,name=iPhone 15}"
PROJECT_TYPE="${PROJECT_TYPE:-xcodeproj}"  # xcodeproj or xcworkspace

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Parse arguments
BUILD_ONLY=false
QUICK=false
VERBOSE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --build-only)
            BUILD_ONLY=true
            shift
            ;;
        --quick)
            QUICK=true
            shift
            ;;
        --verbose)
            VERBOSE=true
            shift
            ;;
        --help)
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  --build-only    Only run build verification"
            echo "  --quick         Run unit tests only (skip UI tests)"
            echo "  --verbose       Show detailed output"
            echo "  --help          Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Logging
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

log_fail() {
    echo -e "${RED}[✗]${NC} $1"
}

# Find project file
find_project() {
    if [ -f "*.xcworkspace" ] 2>/dev/null; then
        PROJECT_TYPE="xcworkspace"
        PROJECT_FILE=$(ls *.xcworkspace | head -1)
    elif [ -f "*.xcodeproj" ] 2>/dev/null; then
        PROJECT_TYPE="xcodeproj"
        PROJECT_FILE=$(ls *.xcodeproj | head -1)
    else
        # Look in subdirectories
        PROJECT_FILE=$(find . -maxdepth 2 -name "*.xcworkspace" | head -1)
        if [ -z "$PROJECT_FILE" ]; then
            PROJECT_FILE=$(find . -maxdepth 2 -name "*.xcodeproj" | head -1)
            PROJECT_TYPE="xcodeproj"
        else
            PROJECT_TYPE="xcworkspace"
        fi
    fi

    if [ -z "$PROJECT_FILE" ]; then
        log_error "No Xcode project or workspace found"
        exit 1
    fi

    log_info "Found project: $PROJECT_FILE"
}

# Build project
run_build() {
    log_info "Building project..."

    if [ "$PROJECT_TYPE" = "xcworkspace" ]; then
        PROJECT_FLAG="-workspace"
    else
        PROJECT_FLAG="-project"
    fi

    BUILD_CMD="xcodebuild $PROJECT_FLAG \"$PROJECT_FILE\" -scheme \"$SCHEME\" -destination \"$DESTINATION\" build"

    if [ "$VERBOSE" = true ]; then
        eval $BUILD_CMD
    else
        eval $BUILD_CMD 2>&1 | grep -E "(error:|warning:|BUILD SUCCEEDED|BUILD FAILED)" || true
    fi

    if [ ${PIPESTATUS[0]} -eq 0 ]; then
        log_success "Build passed"
        return 0
    else
        log_fail "Build failed"
        return 1
    fi
}

# Run tests
run_tests() {
    local test_type="$1"
    log_info "Running $test_type tests..."

    if [ "$PROJECT_TYPE" = "xcworkspace" ]; then
        PROJECT_FLAG="-workspace"
    else
        PROJECT_FLAG="-project"
    fi

    TEST_CMD="xcodebuild $PROJECT_FLAG \"$PROJECT_FILE\" -scheme \"$SCHEME\" -destination \"$DESTINATION\" test"

    if [ "$test_type" = "unit" ]; then
        # Filter to only unit tests if possible
        TEST_CMD="$TEST_CMD -only-testing:${SCHEME}Tests"
    fi

    if [ "$VERBOSE" = true ]; then
        eval $TEST_CMD
    else
        eval $TEST_CMD 2>&1 | grep -E "(Test Suite|Test Case|passed|failed|error:)" || true
    fi

    if [ ${PIPESTATUS[0]} -eq 0 ]; then
        log_success "$test_type tests passed"
        return 0
    else
        log_fail "$test_type tests failed"
        return 1
    fi
}

# Main verification
main() {
    echo "======================================"
    echo "SuperBeads iOS Verification"
    echo "======================================"
    echo ""

    # Find project
    find_project

    # Track results
    BUILD_RESULT=0
    UNIT_RESULT=0
    UI_RESULT=0

    # Run build
    if ! run_build; then
        BUILD_RESULT=1
    fi

    # Stop if build-only
    if [ "$BUILD_ONLY" = true ]; then
        if [ $BUILD_RESULT -eq 0 ]; then
            echo ""
            log_success "Verification passed (build only)"
            exit 0
        else
            echo ""
            log_fail "Verification failed"
            exit 1
        fi
    fi

    # Run tests
    if [ $BUILD_RESULT -eq 0 ]; then
        if ! run_tests "unit"; then
            UNIT_RESULT=1
        fi

        if [ "$QUICK" = false ]; then
            if ! run_tests "ui"; then
                UI_RESULT=1
            fi
        fi
    fi

    # Summary
    echo ""
    echo "======================================"
    echo "Verification Summary"
    echo "======================================"

    if [ $BUILD_RESULT -eq 0 ]; then
        log_success "Build: PASSED"
    else
        log_fail "Build: FAILED"
    fi

    if [ $UNIT_RESULT -eq 0 ]; then
        log_success "Unit Tests: PASSED"
    else
        log_fail "Unit Tests: FAILED"
    fi

    if [ "$QUICK" = false ]; then
        if [ $UI_RESULT -eq 0 ]; then
            log_success "UI Tests: PASSED"
        else
            log_fail "UI Tests: FAILED"
        fi
    else
        log_warn "UI Tests: SKIPPED (--quick)"
    fi

    echo ""

    # Exit with appropriate code
    if [ $BUILD_RESULT -eq 0 ] && [ $UNIT_RESULT -eq 0 ] && ([ "$QUICK" = true ] || [ $UI_RESULT -eq 0 ]); then
        log_success "All verifications passed"
        exit 0
    else
        log_fail "Verification failed"
        exit 1
    fi
}

# Run main
main
