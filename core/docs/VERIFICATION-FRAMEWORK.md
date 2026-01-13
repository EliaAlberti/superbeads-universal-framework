# Verification Framework

> **Observable completion signals for any task**

Verification isn't "looks good"—it's observable proof that work is complete. Every task needs a signal that can be checked objectively.

---

## The Observable Completion Principle

### Bad: Subjective

```
"The code looks clean"
"The design feels right"
"The document seems complete"
```

### Good: Observable

```
"Build passes with zero warnings"
"All 5 screens match Figma specs"
"Document includes all 10 required sections"
```

---

## Verification Types

| Type | Signal | Applies To | Example |
|------|--------|------------|---------|
| **Output Exists** | File/artifact created | Any | "report.pdf exists" |
| **Build Passes** | Build command exits 0 | Code | "xcodebuild succeeds" |
| **Tests Pass** | Test suite green | Code | "12/12 tests pass" |
| **API Success** | API returns 2xx | Integration | "POST returns 201" |
| **Checklist Complete** | All items checked | Structured | "5/5 criteria met" |
| **Human Confirms** | Supervisor approves | Decisions | "PM approves scope" |
| **Script Passes** | Custom script exits 0 | Custom | "./check-links.sh passes" |
| **Diff Match** | Output matches expected | Any | "Output matches snapshot" |

---

## Verification Script Template

Every project has a `verify.sh` that runs all checks:

```bash
#!/bin/bash
# verify.sh - Universal verification script
#
# Usage:
#   ./verify.sh              Run all verifications
#   ./verify.sh --quick      Skip slow checks
#   ./verify.sh --verbose    Show detailed output
#   ./verify.sh --task ID    Verify specific task

set -e

# ═══════════════════════════════════════════════════════════
# CONFIGURATION
# ═══════════════════════════════════════════════════════════

QUICK_MODE=false
VERBOSE=false
TASK_ID=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --quick) QUICK_MODE=true; shift ;;
        --verbose) VERBOSE=true; shift ;;
        --task) TASK_ID="$2"; shift 2 ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

log() {
    if [ "$VERBOSE" = true ]; then
        echo "$1"
    fi
}

# ═══════════════════════════════════════════════════════════
# CORE CHECKS
# ═══════════════════════════════════════════════════════════

check_outputs_exist() {
    echo "📁 Checking outputs..."

    local missing=0

    if [ -f ".superbeads/expected-outputs.txt" ]; then
        while IFS= read -r output; do
            # Skip empty lines and comments
            [[ -z "$output" || "$output" =~ ^# ]] && continue

            if [ ! -e "$output" ]; then
                echo "   ✗ Missing: $output"
                missing=$((missing + 1))
            else
                log "   ✓ Found: $output"
            fi
        done < ".superbeads/expected-outputs.txt"
    fi

    if [ $missing -gt 0 ]; then
        echo "   ✗ $missing outputs missing"
        return 1
    fi

    echo "   ✓ All outputs exist"
}

check_acceptance_criteria() {
    echo "📋 Checking acceptance criteria..."

    if [ -n "$TASK_ID" ]; then
        local task_file=".superbeads/tasks/${TASK_ID}.json"
        if [ -f "$task_file" ]; then
            # Extract and display criteria
            local criteria=$(jq -r '.context.acceptance_criteria[]' "$task_file" 2>/dev/null)
            echo "   Task: $TASK_ID"
            echo "   Criteria:"
            echo "$criteria" | while read -r criterion; do
                echo "   □ $criterion"
            done
            echo ""
            echo "   ⚠ Manual verification required"
        fi
    else
        echo "   ⚠ No task specified, manual verification required"
    fi
}

check_no_todos() {
    echo "📝 Checking for TODO/FIXME..."

    local count=$(grep -r "TODO\|FIXME" --include="*.swift" --include="*.py" --include="*.ts" --include="*.js" . 2>/dev/null | wc -l | tr -d ' ')

    if [ "$count" -gt 0 ]; then
        echo "   ⚠ Found $count TODO/FIXME comments"
        if [ "$VERBOSE" = true ]; then
            grep -r "TODO\|FIXME" --include="*.swift" --include="*.py" --include="*.ts" --include="*.js" . 2>/dev/null | head -10
        fi
    else
        echo "   ✓ No TODO/FIXME found"
    fi
}

# ═══════════════════════════════════════════════════════════
# PACK EXTENSIONS
# ═══════════════════════════════════════════════════════════

load_pack_verifications() {
    for pack_verify in .superbeads/packs/*/verify.sh; do
        if [ -f "$pack_verify" ]; then
            local pack_name=$(dirname "$pack_verify" | xargs basename)
            echo ""
            echo "📦 Running $pack_name pack verification..."
            source "$pack_verify"
        fi
    done
}

# ═══════════════════════════════════════════════════════════
# EXECUTION
# ═══════════════════════════════════════════════════════════

main() {
    echo ""
    echo "═══════════════════════════════════════════════════════"
    echo "🔍 SUPERBEADS VERIFICATION"
    echo "═══════════════════════════════════════════════════════"
    echo ""

    local failed=0

    # Core checks
    check_outputs_exist || failed=$((failed + 1))
    check_acceptance_criteria
    check_no_todos

    # Pack-specific checks
    load_pack_verifications

    echo ""
    echo "═══════════════════════════════════════════════════════"

    if [ $failed -eq 0 ]; then
        echo "✅ VERIFICATION PASSED"
    else
        echo "❌ VERIFICATION FAILED ($failed checks failed)"
        exit 1
    fi

    echo "═══════════════════════════════════════════════════════"
    echo ""
}

main "$@"
```

---

## Pack-Specific Verification

Each pack provides its own verification additions:

### iOS Pack (`packs/ios/templates/verify.sh`)

```bash
# iOS Pack Verification Extensions

check_ios_build() {
    echo "🔨 Building iOS project..."

    local scheme=$(jq -r '.packs.settings.ios.scheme // "App"' .superbeads/settings.json)
    local platform=$(jq -r '.packs.settings.ios.platform // "iOS Simulator"' .superbeads/settings.json)

    xcodebuild -scheme "$scheme" \
               -destination "platform=$platform,name=iPhone 15" \
               -quiet \
               build

    echo "   ✓ Build passed"
}

check_ios_tests() {
    echo "🧪 Running iOS tests..."

    if [ "$QUICK_MODE" = true ]; then
        echo "   ⏩ Skipping tests (quick mode)"
        return 0
    fi

    local scheme=$(jq -r '.packs.settings.ios.scheme // "App"' .superbeads/settings.json)

    xcodebuild -scheme "$scheme" \
               -destination "platform=iOS Simulator,name=iPhone 15" \
               -quiet \
               test

    echo "   ✓ Tests passed"
}

# Run iOS checks
check_ios_build
check_ios_tests
```

### Python Pack (`packs/python/templates/verify.sh`)

```bash
# Python Pack Verification Extensions

check_python_lint() {
    echo "🔍 Linting Python code..."

    if command -v ruff &> /dev/null; then
        ruff check .
    elif command -v flake8 &> /dev/null; then
        flake8 .
    fi

    echo "   ✓ Lint passed"
}

check_python_types() {
    echo "📝 Checking types..."

    if command -v mypy &> /dev/null; then
        mypy .
    fi

    echo "   ✓ Type check passed"
}

check_python_tests() {
    echo "🧪 Running Python tests..."

    if [ "$QUICK_MODE" = true ]; then
        echo "   ⏩ Skipping tests (quick mode)"
        return 0
    fi

    pytest

    echo "   ✓ Tests passed"
}

# Run Python checks
check_python_lint
check_python_types
check_python_tests
```

---

## Verification Patterns by Domain

### Code Domain

| Check | Command | Passes When |
|-------|---------|-------------|
| Build | `xcodebuild` / `npm run build` | Exit 0, no errors |
| Lint | `eslint` / `ruff` | No errors |
| Types | `tsc` / `mypy` | No type errors |
| Unit Tests | `pytest` / `jest` | All tests pass |
| UI Tests | `xcodebuild test` | All tests pass |

### Research Domain

| Check | Signal | Passes When |
|-------|--------|-------------|
| Sources | Count sources | >= minimum required |
| Coverage | Topics covered | All topics addressed |
| Citations | Citation format | All properly formatted |
| Length | Word/page count | Within range |

### Design Domain

| Check | Signal | Passes When |
|-------|--------|-------------|
| Completeness | Screen count | All screens designed |
| Consistency | Component audit | All use design system |
| Accessibility | Contrast check | WCAG AA compliance |
| Responsiveness | Breakpoints | All sizes covered |

### Writing Domain

| Check | Signal | Passes When |
|-------|--------|-------------|
| Structure | Section count | All sections present |
| Length | Word count | Within target range |
| Links | Link checker | All links valid |
| Grammar | Spell check | No errors |

### PM Domain

| Check | Signal | Passes When |
|-------|--------|-------------|
| Stories | Story count | All stories written |
| Criteria | AC per story | >= 3 criteria each |
| Estimates | Points assigned | All estimated |
| Dependencies | Dependency map | No cycles |

---

## Completion Signals by Task Type

### Feature Task

```json
{
  "completion_signal": "Build passes, all acceptance criteria verified in app"
}
```

### Fix Task

```json
{
  "completion_signal": "Bug no longer reproducible, regression test added"
}
```

### Research Task

```json
{
  "completion_signal": "Research doc exists with >= 5 sources"
}
```

### Analysis Task

```json
{
  "completion_signal": "Analysis doc exists with data tables and conclusions"
}
```

### Creation Task

```json
{
  "completion_signal": "Deliverable exists and passes quality checklist"
}
```

### Review Task

```json
{
  "completion_signal": "Review report exists with approve/reject verdict"
}
```

---

## Verification Workflow

```
┌─────────────────────────────────────────────────────────┐
│                     TASK COMPLETE?                       │
└─────────────────────────────────────────────────────────┘
                          │
                          ▼
              ┌───────────────────────┐
              │   Run verify.sh       │
              └───────────────────────┘
                          │
            ┌─────────────┴─────────────┐
            │                           │
            ▼                           ▼
    ┌───────────────┐          ┌───────────────┐
    │   PASSES      │          │   FAILS       │
    └───────────────┘          └───────────────┘
            │                           │
            ▼                           ▼
    ┌───────────────┐          ┌───────────────┐
    │ Check criteria│          │ Fix issues    │
    │ (manual)      │          │ Re-run verify │
    └───────────────┘          └───────────────┘
            │                           │
            ▼                           │
    ┌───────────────┐                   │
    │ Mark complete │◀──────────────────┘
    │ Git commit    │
    └───────────────┘
```

---

## Creating Custom Verifications

### For a Project

Add checks to `.superbeads/verify-custom.sh`:

```bash
# Custom project verification

check_api_health() {
    echo "🌐 Checking API health..."
    curl -s http://localhost:3000/health | grep -q "ok"
    echo "   ✓ API healthy"
}

check_database_migrations() {
    echo "🗄️ Checking database..."
    # Custom database checks
}

# Run custom checks
check_api_health
check_database_migrations
```

### For a Pack

Add checks to `packs/[name]/templates/verify.sh`.

---

## Best Practices

### 1. Fail Fast

Check the most likely failures first:
```bash
check_outputs_exist     # Quick, catches missing files
check_build            # Medium, catches code errors
check_tests            # Slow, catches logic errors
```

### 2. Provide Context

When verification fails, show what's wrong:
```bash
if ! build_passes; then
    echo "Build failed. Recent errors:"
    tail -20 build.log
    exit 1
fi
```

### 3. Support Quick Mode

Allow skipping slow checks during development:
```bash
if [ "$QUICK_MODE" = false ]; then
    run_full_test_suite
fi
```

### 4. Make Criteria Checkable

Write criteria that can be verified:

**❌ Uncheckable**: "Code is clean"
**✅ Checkable**: "No lint warnings"

**❌ Uncheckable**: "Looks good"
**✅ Checkable**: "Matches Figma design within 2px"

---

## Summary

1. **Observable signals** — Not subjective, checkable
2. **Script-based** — `verify.sh` automates checks
3. **Extensible** — Packs add domain checks
4. **Fail fast** — Quick checks first
5. **Context on failure** — Show what's wrong

---

*Verification Framework — Core Engine Documentation*
