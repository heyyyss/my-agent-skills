#!/bin/bash

# 添加新skill脚本
# 用法: ./scripts/add-skill.sh <category> <git-url> [name]
# 示例:
#   ./scripts/add-skill.sh third-party https://github.com/original/skill.git
#   ./scripts/add-skill.sh modified https://github.com/yourname/skill.git my-skill
#   ./scripts/add-skill.sh custom (直接创建空目录)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CATEGORY=$1
GIT_URL=$2
NAME=$3

if [ -z "$CATEGORY" ]; then
    echo "Usage: ./scripts/add-skill.sh <category> [git-url] [name]"
    echo ""
    echo "Categories:"
    echo "  third-party    - Add as submodule (track upstream)"
    echo "  modified       - Clone normally (your fork/modification)"
    echo "  custom         - Create empty directory (your own skill)"
    echo ""
    echo "Examples:"
    echo "  ./scripts/add-skill.sh third-party https://github.com/original/skill.git"
    echo "  ./scripts/add-skill.sh modified https://github.com/yourname/skill.git"
    echo "  ./scripts/add-skill.sh custom my-new-skill"
    exit 1
fi

case "$CATEGORY" in
    third-party)
        if [ -z "$GIT_URL" ]; then
            echo "Error: git-url required for third-party"
            exit 1
        fi
        # 从URL提取名字
        if [ -z "$NAME" ]; then
            NAME=$(basename "$GIT_URL" .git)
        fi
        echo "Adding third-party skill: $NAME"
        cd "$SCRIPT_DIR"
        git submodule add "$GIT_URL" "third-party/$NAME"
        git commit -m "Add third-party skill: $NAME"
        echo "✅ Added as submodule in third-party/$NAME"
        ;;

    modified)
        if [ -z "$GIT_URL" ]; then
            echo "Error: git-url required for modified"
            exit 1
        fi
        if [ -z "$NAME" ]; then
            NAME=$(basename "$GIT_URL" .git)
        fi
        echo "Cloning modified skill: $NAME"
        cd "$SCRIPT_DIR/modified"
        git clone "$GIT_URL" "$NAME"
        echo "✅ Cloned to modified/$NAME"
        ;;

    custom)
        if [ -z "$GIT_URL" ]; then
            echo "Error: skill name required for custom"
            exit 1
        fi
        NAME="$GIT_URL"
        echo "Creating custom skill: $NAME"
        mkdir -p "$SCRIPT_DIR/custom/$NAME"
        echo "# $NAME" > "$SCRIPT_DIR/custom/$NAME/SKILL.md"
        echo "" >> "$SCRIPT_DIR/custom/$NAME/SKILL.md"
        echo "Create your skill here following the standard structure." >> "$SCRIPT_DIR/custom/$NAME/SKILL.md"
        echo "✅ Created custom/$NAME/SKILL.md (template)"
        ;;

    *)
        echo "Error: Unknown category '$CATEGORY'"
        echo "Valid: third-party, modified, custom"
        exit 1
        ;;
esac
