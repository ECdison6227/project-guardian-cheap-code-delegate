<p align="center">
  <a href="README.md">中文</a> | <a href="README.en.md">English</a>
</p>

<p align="center">
  <img src="docs/assets/workflow.svg" alt="Project Guardian + Cheap Code Delegate" width="100%"/>
</p>

<p align="center">
  两个本地 Codex Skill：强制 Git 纪律 + 低成本任务委派
</p>

<p align="center">
  <a href="#安装">🚀 安装</a> ·
  <a href="#使用">📖 使用</a> ·
  <a href="#安全边界">🛡 安全边界</a>
</p>

---

## 一键使用

如果你不想手动安装，直接把下面这段 prompt 发给你的 Coding Agent（Trae / Codex / Claude Code），它会自动完成安装并解释用法：

```text
请帮我安装并配置 https://github.com/ECdison6227/project-guardian-cheap-code-delegate 这个仓库：

1. 先 git clone 到临时目录
2. 运行 ./install.sh 安装 Skill
3. 告诉我这两个 Skill 分别是做什么的、触发词是什么
4. 如果 Skill 需要初始化配置（如项目记忆、委派 worker），请引导我完成
5. 最后用一个简单的例子演示如何调用 project-guardian 初始化项目
```

---

## 为什么需要这个项目

Codex 更适合做需要判断力的工作：架构、审查、安全边界、上下文整合。很多工程子任务其实更机械：搜索仓库、总结日志、找测试命令、生成样板代码、起草窄范围 patch。这个项目提供一套可重复的流程，把这些低风险任务交给更便宜的本地 worker，同时不把最终控制权交出去。

## Skill 说明

### `project-guardian`

适用于开始项目、恢复项目、修改前后、写检查点、结束工作会话。

它管理：

- `.ai/state.json`
- `.ai/memory/PROJECT_MEMORY.md`
- `.ai/memory/SESSION_LOG.md`
- `.ai/memory/CHECKPOINTS.md`
- `.ai/memory/DECISIONS.md`
- `.ai/memory/TODO.md`
- `.ai/memory/PAPER_CONTEXT.md`

它会自动执行 `git init`/`git add`/`git commit`；不会自动推送、reset、clean、部署或执行破坏性命令。

### `cheap-code-delegate`

适用于编码、调试、重构、测试、lint、文档更新、CI 日志分析、仓库检查、样板代码生成和重复性项目工作之前。

它把任务分为：

- `S0`：机械任务
- `S1`：简单局部实现
- `S2`：中等风险的局部工作
- `S3`：禁止委派

只有 S0、S1 和安全窄范围的 S2 可以委派。worker 产出的每一行改动都必须由 Codex 审查。

## 安装

克隆仓库后运行：

```bash
./scripts/validate.sh
./install.sh
```

默认安装位置：

```text
~/.agents/skills
```

安装到其他位置：

```bash
./install.sh --target "$HOME/.codex/skills"
```

只预览安装行为：

```bash
./install.sh --dry-run
```

## 使用

查看本地 Claude Code Skills：

```bash
~/.agents/skills/cheap-code-delegate/scripts/claude_skill_inventory.sh
```

执行只读委派 dry-run：

```bash
~/.agents/skills/cheap-code-delegate/scripts/cheap_delegate.sh \
  --mode readonly \
  --dry-run \
  --task "Inspect this repository and summarize test commands."
```

初始化项目记忆：

```bash
~/.agents/skills/project-guardian/scripts/project_guardian.sh init \
  --task "Start a new project"
```

恢复项目上下文：

```bash
~/.agents/skills/project-guardian/scripts/project_guardian.sh resume
```

## 安全边界

这些工具不会自动：

- 推送到 Git 远端
- 运行 `git reset` 或 `git clean`
- 部署
- 删除项目数据
- 修改 secrets
- 修改生产配置

`project-guardian` 会在 checkpoint 时自动创建提交，但不会在没有显式 `--push` 标志时推送。

安全、权限、支付、数据库迁移、并发、公开 API 设计、大范围重写和最终合并决策仍然由 Codex 负责。

## 仓库结构

```text
.
├── install.sh
├── scripts/
│   └── validate.sh
├── docs/
│   └── usage.md
└── skills/
    ├── cheap-code-delegate/
    │   ├── SKILL.md
    │   ├── references/
    │   ├── scripts/
    │   └── templates/
    └── project-guardian/
        ├── SKILL.md
        ├── references/
        ├── scripts/
        └── templates/
```

## 环境要求

- macOS、Linux 或其他类 Unix 环境
- Bash
- Git
- 可选：用于委派的 `claude` CLI
- 可选：用于更严格脚本检查的 `shellcheck`

如果没有 `claude`，可以通过 `CHEAP_CODE_CMD` 指定兼容 worker。

## 验证

```bash
./scripts/validate.sh
```

验证脚本会检查必需文件、Skill frontmatter、bash 语法和 smoke tests。只有在本机安装了 `shellcheck` 时才会运行 shellcheck。

## License

MIT License。见 [LICENSE](LICENSE)。
