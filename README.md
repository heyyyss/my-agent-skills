# Claude Skills 管理仓库

个人Claude Code技能管理仓库，支持同步上游更新并管理自定义修改。

## 目录结构

```
.
├── README.md
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

### 安装 Skills

```bash
# 从本仓库的 modified/ 目录安装
npx skills add https://github.com/heyyyss/my-agent-skills/modified/frontend-slides --skill frontend-slides

# 从任意GitHub仓库安装
npx skills add https://github.com/user/repo --skill my-skill

# 安装到指定位置
npx skills add <url> --skill <name> --dir ~/.claude/skills/
```

### 同步上游更新

```bash
./sync.sh
```

### 查看原版和修改版的差异

```bash
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

# 4. 重新安装更新后的skill
npx skills add ./modified/frontend-slides --skill frontend-slides
```

## Skills 安装路径

默认安装到：`~/.claude/skills/`

使用 `npx skills add` 时可指定其他位置：
```bash
npx skills add <url> --skill <name> --dir ~/my-skills
```

## 本地开发 Workflow

```bash
# 1. 克隆管理仓库
git clone https://github.com/heyyyss/my-agent-skills.git
cd my-agent-skills

# 2. 同步上游（拉取 third-party 的更新）
./sync.sh

# 3. 对比并决定是否合并到 modified
./scripts/diff-skill.sh frontend-slides

# 4. 合并更新到 modified
cd modified/frontend-slides
git pull ../../third-party/frontend-slides main

# 5. 解决冲突后提交
git add .
git commit -m "sync: merge upstream changes"

# 6. 推送到你的fork
git push origin main
```
