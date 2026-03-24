# Claude Skills 管理仓库

个人Claude Code技能管理仓库，支持同步上游更新并管理自定义修改。

## 目录结构

```
.
├── README.md
├── install.sh              # 安装所有skills到 ~/.claude/skills
├── sync.sh                 # 同步上游更新
├── third-party/            # 别人的原版skills (submodule)
│   ├── frontend-slides/    # git submodule
│   └── notion-export/
├── modified/               # 你修改后的skills (fork/手动复制)
│   └── frontend-slides/    # 基于原版，但有自己的commit历史
├── custom/                 # 完全自己创建的skills
│   └── my-awesome-skill/
└── scripts/                # 辅助脚本
    ├── add-skill.sh
    └── diff-skill.sh
```

## 快速开始

```bash
# 1. 安装所有skills到Claude Code
./install.sh

# 2. 同步上游更新
./sync.sh

# 3. 查看原版和修改版的差异
./scripts/diff-skill.sh frontend-slides
```

## 添加新Skill

### 添加别人的skill（原版）
```bash
./scripts/add-skill.sh third-party https://github.com/original/skill-name.git
```

### 添加修改版（基于原版）
```bash
# Fork原仓库到GitHub，然后：
./scripts/add-skill.sh modified https://github.com/yourname/skill-name.git
```

### 创建自己的skill
```bash
mkdir custom/my-new-skill
# 按标准结构创建SKILL.md等文件
```

## 同步工作流

```bash
# 1. 拉取所有上游更新
./sync.sh

# 2. 对比某个skill的变化
./scripts/diff-skill.sh frontend-slides

# 3. 决定更新modified版本（手动）
cd modified/frontend-slides
git remote add upstream ../../third-party/frontend-slides
git fetch upstream
git merge upstream/main  # 或 cherry-pick特定提交
```

## 安装路径

默认安装到：`~/.claude/skills/`

自定义路径：
```bash
CLAUDE_SKILLS_DIR=~/my-skills ./install.sh
```
