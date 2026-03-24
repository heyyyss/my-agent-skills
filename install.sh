#!/bin/bash
set -e

# Claude Skills 安装脚本
# 将所有skills安装到 ~/.claude/skills/

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"

echo "📦 Claude Skills Installer"
echo "=========================="
echo "Source: $SCRIPT_DIR"
echo "Target: $INSTALL_DIR"
echo ""

# 创建目标目录
mkdir -p "$INSTALL_DIR"

# 安装函数
install_skill() {
    local source_path=$1
    local skill_name=$(basename "$source_path")
    local target_path="$INSTALL_DIR/$skill_name"

    echo "Installing: $skill_name"

    # 删除旧版本
    if [ -d "$target_path" ]; then
        rm -rf "$target_path"
    fi

    # 复制新版本（排除.git）
    if command -v rsync &> /dev/null; then
        rsync -a --exclude='.git' --exclude='.github' "$source_path/" "$target_path/"
    else
        # 备用方案：使用cp + find
        mkdir -p "$target_path"
        find "$source_path" -maxdepth 1 -not -name '.git' -not -name '.github' -exec cp -r {} "$target_path/" \; 2>/dev/null || true
    fi

    echo "  ✅ $skill_name"
}

# 安装 modified skills（优先，会覆盖third-party的同名skill）
if [ -d "$SCRIPT_DIR/modified" ]; then
    echo ""
    echo "📁 Installing MODIFIED skills..."
    for skill in "$SCRIPT_DIR/modified"/*/; do
        if [ -d "$skill" ]; then
            install_skill "$skill"
        fi
    done
fi

# 安装 custom skills
if [ -d "$SCRIPT_DIR/custom" ]; then
    echo ""
    echo "📁 Installing CUSTOM skills..."
    for skill in "$SCRIPT_DIR/custom"/*/; do
        if [ -d "$skill" ]; then
            install_skill "$skill"
        fi
    done
fi

# 安装 third-party skills（排除已在modified中的）
if [ -d "$SCRIPT_DIR/third-party" ]; then
    echo ""
    echo "📁 Installing THIRD-PARTY skills..."
    for skill in "$SCRIPT_DIR/third-party"/*/; do
        if [ -d "$skill" ]; then
            skill_name=$(basename "$skill")
            # 如果modified中已存在，跳过
            if [ -d "$SCRIPT_DIR/modified/$skill_name" ]; then
                echo "  ⏭️  $skill_name (skipped, using modified version)"
            else
                install_skill "$skill"
            fi
        fi
    done
fi

echo ""
echo "=========================="
echo "✅ Installation complete!"
echo ""
echo "Installed skills to: $INSTALL_DIR"
ls -1 "$INSTALL_DIR" 2>/dev/null || echo "(directory is empty)"
