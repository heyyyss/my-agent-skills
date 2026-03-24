#!/bin/bash

# 对比原版和修改版的差异
# 用法: ./scripts/diff-skill.sh <skill-name>

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_NAME=$1

if [ -z "$SKILL_NAME" ]; then
    echo "Usage: ./scripts/diff-skill.sh <skill-name>"
    echo ""
    echo "Compares third-party/original vs modified version"
    exit 1
fi

THIRD_PARTY="$SCRIPT_DIR/third-party/$SKILL_NAME"
MODIFIED="$SCRIPT_DIR/modified/$SKILL_NAME"

if [ ! -d "$THIRD_PARTY" ]; then
    echo "Error: third-party/$SKILL_NAME not found"
    exit 1
fi

if [ ! -d "$MODIFIED" ]; then
    echo "Error: modified/$SKILL_NAME not found"
    echo "This skill exists only in third-party/ (no modifications)"
    exit 1
fi

echo "Comparing: $SKILL_NAME"
echo "======================="
echo "Left:  third-party/$SKILL_NAME (upstream)"
echo "Right: modified/$SKILL_NAME (your version)"
echo ""

# 使用git diff或者diff工具
if command -v git &> /dev/null; then
    # 临时作为git仓库对比
    cd "$MODIFIED"
    if [ ! -d .git ]; then
        echo "Warning: modified/$SKILL_NAME is not a git repo"
        echo "Using plain diff instead..."
        diff -r "$THIRD_PARTY" "$MODIFIED" 2>/dev/null || true
    else
        # 添加upstream作为remote来对比
        if ! git remote | grep -q "upstream"; then
            git remote add upstream "$THIRD_PARTY" 2>/dev/null || true
        fi
        git fetch upstream 2>/dev/null || true
        git diff upstream/main..HEAD --stat 2>/dev/null || git diff upstream/master..HEAD --stat 2>/dev/null || echo "Could not determine diff"
    fi
else
    diff -r "$THIRD_PARTY" "$MODIFIED" 2>/dev/null || true
fi
