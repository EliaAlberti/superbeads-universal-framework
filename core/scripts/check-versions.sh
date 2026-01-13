#!/bin/bash
# check-versions.sh - Check SuperBeads and dependency versions
#
# Usage:
#   ./check-versions.sh

echo ""
echo "SuperBeads Version Check"
echo "═══════════════════════════════════════════════════════"
echo ""

# SuperBeads version
if [ -f "${HOME}/.superbeads/VERSION" ]; then
    echo "SuperBeads Core: v$(cat ${HOME}/.superbeads/VERSION)"
else
    echo "SuperBeads Core: (not installed)"
fi

# Check dependencies
echo ""
echo "Dependencies:"

# bash
echo -n "  bash: "
bash --version | head -1

# jq
echo -n "  jq: "
if command -v jq &> /dev/null; then
    jq --version
else
    echo "(not installed - recommended)"
fi

# git
echo -n "  git: "
if command -v git &> /dev/null; then
    git --version
else
    echo "(not installed)"
fi

# Node.js (for future CLI)
echo -n "  node: "
if command -v node &> /dev/null; then
    node --version
else
    echo "(not installed - optional)"
fi

# Installed packs
echo ""
echo "Installed Packs:"

if [ -f ".superbeads/settings.json" ] && command -v jq &> /dev/null; then
    packs=$(jq -r '.packs.installed[]' .superbeads/settings.json 2>/dev/null)
    if [ -n "$packs" ]; then
        echo "$packs" | while read pack; do
            echo "  - $pack"
        done
    else
        echo "  (none)"
    fi
else
    echo "  (no project or jq not installed)"
fi

echo ""
echo "═══════════════════════════════════════════════════════"
echo ""
