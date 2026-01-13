#!/bin/bash
# install-superbeads.sh - Install Universal SuperBeads Core Engine
#
# Usage:
#   curl -fsSL https://superbeads.dev/install.sh | bash
#   # OR
#   ./install-superbeads.sh [OPTIONS]
#
# Options:
#   --prefix PATH    Install prefix (default: ~/.superbeads)
#   --no-path        Don't add to PATH
#   --help           Show help

set -e

# ═══════════════════════════════════════════════════════════
# CONFIGURATION
# ═══════════════════════════════════════════════════════════

VERSION="1.0.0"
INSTALL_PREFIX="${HOME}/.superbeads"
ADD_TO_PATH=true

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# ═══════════════════════════════════════════════════════════
# HELPERS
# ═══════════════════════════════════════════════════════════

log() {
    echo -e "${BLUE}==>${NC} $1"
}

success() {
    echo -e "${GREEN}✓${NC} $1"
}

warn() {
    echo -e "${YELLOW}⚠${NC} $1"
}

error() {
    echo -e "${RED}✗${NC} $1"
    exit 1
}

# ═══════════════════════════════════════════════════════════
# ARGUMENT PARSING
# ═══════════════════════════════════════════════════════════

while [[ $# -gt 0 ]]; do
    case $1 in
        --prefix)
            INSTALL_PREFIX="$2"
            shift 2
            ;;
        --no-path)
            ADD_TO_PATH=false
            shift
            ;;
        --help|-h)
            echo "Universal SuperBeads Core Engine Installer"
            echo ""
            echo "Usage:"
            echo "  ./install-superbeads.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --prefix PATH    Install prefix (default: ~/.superbeads)"
            echo "  --no-path        Don't add to PATH"
            echo "  --help, -h       Show this help"
            exit 0
            ;;
        *)
            error "Unknown option: $1"
            ;;
    esac
done

# ═══════════════════════════════════════════════════════════
# INSTALLATION
# ═══════════════════════════════════════════════════════════

echo ""
echo "═══════════════════════════════════════════════════════"
echo " Universal SuperBeads Core Engine Installer v${VERSION}"
echo "═══════════════════════════════════════════════════════"
echo ""

# Check prerequisites
log "Checking prerequisites..."

if ! command -v bash &> /dev/null; then
    error "bash is required"
fi
success "bash found"

if command -v jq &> /dev/null; then
    success "jq found"
else
    warn "jq not found (optional, but recommended)"
fi

if command -v git &> /dev/null; then
    success "git found"
else
    warn "git not found (optional)"
fi

# Determine script location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CORE_DIR="$(dirname "$SCRIPT_DIR")"

log "Installing to: $INSTALL_PREFIX"

# Create installation directory
mkdir -p "$INSTALL_PREFIX"/{bin,lib,templates}

# Copy core files
log "Copying core files..."

# Copy documentation
if [ -d "$CORE_DIR/docs" ]; then
    cp -r "$CORE_DIR/docs" "$INSTALL_PREFIX/lib/"
    success "Documentation copied"
fi

# Copy templates
if [ -d "$CORE_DIR/templates" ]; then
    cp -r "$CORE_DIR/templates/"* "$INSTALL_PREFIX/templates/"
    success "Templates copied"
fi

# Copy and install CLI
log "Installing CLI..."

if [ -f "$CORE_DIR/scripts/superbeads" ]; then
    cp "$CORE_DIR/scripts/superbeads" "$INSTALL_PREFIX/bin/"
    chmod +x "$INSTALL_PREFIX/bin/superbeads"
    success "superbeads CLI installed"
fi

# Copy utilities
for script in verify check-versions.sh; do
    if [ -f "$CORE_DIR/scripts/$script" ]; then
        cp "$CORE_DIR/scripts/$script" "$INSTALL_PREFIX/bin/"
        chmod +x "$INSTALL_PREFIX/bin/$script"
    fi
done

# Add to PATH
if [ "$ADD_TO_PATH" = true ]; then
    log "Configuring PATH..."

    SHELL_RC=""
    if [ -n "$ZSH_VERSION" ] || [ -f "$HOME/.zshrc" ]; then
        SHELL_RC="$HOME/.zshrc"
    elif [ -n "$BASH_VERSION" ] || [ -f "$HOME/.bashrc" ]; then
        SHELL_RC="$HOME/.bashrc"
    elif [ -f "$HOME/.profile" ]; then
        SHELL_RC="$HOME/.profile"
    fi

    if [ -n "$SHELL_RC" ]; then
        PATH_LINE="export PATH=\"\$PATH:$INSTALL_PREFIX/bin\""

        if ! grep -q "superbeads" "$SHELL_RC" 2>/dev/null; then
            echo "" >> "$SHELL_RC"
            echo "# Universal SuperBeads Framework" >> "$SHELL_RC"
            echo "$PATH_LINE" >> "$SHELL_RC"
            success "Added to $SHELL_RC"
        else
            warn "PATH already configured in $SHELL_RC"
        fi
    else
        warn "Could not determine shell config file"
        echo "   Add this to your shell config:"
        echo "   export PATH=\"\$PATH:$INSTALL_PREFIX/bin\""
    fi
fi

# Create version file
echo "$VERSION" > "$INSTALL_PREFIX/VERSION"

# ═══════════════════════════════════════════════════════════
# COMPLETION
# ═══════════════════════════════════════════════════════════

echo ""
echo "═══════════════════════════════════════════════════════"
echo -e "${GREEN}✓ Installation complete!${NC}"
echo "═══════════════════════════════════════════════════════"
echo ""
echo "Installed to: $INSTALL_PREFIX"
echo "Version: $VERSION"
echo ""
echo "Next steps:"
echo ""
echo "  1. Restart your shell or run:"
echo "     source ~/.zshrc  # or ~/.bashrc"
echo ""
echo "  2. Initialize a project:"
echo "     cd /path/to/project"
echo "     superbeads init"
echo ""
echo "  3. Read the documentation:"
echo "     superbeads help"
echo ""
echo "Documentation: $INSTALL_PREFIX/lib/docs/"
echo "Templates: $INSTALL_PREFIX/templates/"
echo ""
