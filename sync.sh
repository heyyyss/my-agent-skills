#!/bin/bash
set -e

# 同步上游更新脚本
# 更新所有third-party skills到最新版本

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🔄 Syncing upstream updates..."
echo "=============================="

# 初始化并更新所有submodules
echo ""
echo "📦 Updating git submodules..."
cd "$SCRIPT_DIR"

if [ -f ".gitmodules" ]; then
    git submodule update --init --remote --merge
    echo "✅ Submodules updated"
else
    echo "ℹ️  No submodules configured"
fi

# 显示状态
echo ""
echo "📊 Current status:"
echo ""

# THIRD-PARTY
echo "THIRD-PARTY (upstream):"
if [ -d "$SCRIPT_DIR/third-party" ] && [ "$(ls -A "$SCRIPT_DIR/third-party" 2>/dev/null)" ]; then
    for skill in "$SCRIPT_DIR/third-party"/*/; do
        if [ -d "$skill/.git" ]; then
            name=$(basename "$skill")
            cd "$skill"
            commit=$(git log --oneline -1 2>/dev/null | cut -d' ' -f1 || echo "unknown")
            echo "  • $name @ $commit"
        elif [ -d "$skill" ]; then
            name=$(basename "$skill")
            echo "  • $name (not a git repo)"
        fi
    done
else
    echo "  (empty)"
fi

# MODIFIED
echo ""
echo "MODIFIED (your forks):"
if [ -d "$SCRIPT_DIR/modified" ] && [ "$(ls -A "$SCRIPT_DIR/modified" 2>/dev/null)" ]; then
    for skill in "$SCRIPT_DIR/modified"/*/; do
        if [ -d "$skill/.git" ]; then
            name=$(basename "$skill")
            cd "$skill"
            commit=$(git log --oneline -1 2>/dev/null | cut -d' ' -f1 || echo "unknown")
            echo "  • $name @ $commit"
        elif [ -d "$skill" ]; then
            name=$(basename "$skill")
            echo "  • $name (not a git repo)"
        fi
    done
else
    echo "  (empty)"
fi

# CUSTOM
echo ""
echo "CUSTOM (your own):"
if [ -d "$SCRIPT_DIR/custom" ] && [ "$(ls -A "$SCRIPT_DIR/custom" 2>/dev/null)" ]; then
    for skill in "$SCRIPT_DIR/custom"/*/; do
        if [ -d "$skill" ]; then
            name=$(basename "$skill")
            echo "  • $name"
        fi
    done
else
    echo "  (empty)"
fi

echo ""
echo "=============================="
echo ""
echo "Next steps:"
echo "  1. Review changes: ./scripts/diff-skill.sh <skill-name>"
echo "  2. Update modified version: cd modified/<skill> && git pull ../../third-party/<skill>"
echo "  3. Re-install: ./install.sh"
