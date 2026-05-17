# Usage / 使用说明

English | [中文](#中文)

## Install

```bash
./scripts/validate.sh
./install.sh
```

Default target:

```text
~/.agents/skills
```

Custom target:

```bash
./install.sh --target "$HOME/.codex/skills"
```

Dry run:

```bash
./install.sh --dry-run
```

## Cheap Code Delegate

List local Claude Code skills:

```bash
~/.agents/skills/cheap-code-delegate/scripts/claude_skill_inventory.sh
```

Run read-only delegation dry run:

```bash
~/.agents/skills/cheap-code-delegate/scripts/cheap_delegate.sh \
  --mode readonly \
  --dry-run \
  --task "Inspect this repository and summarize test commands."
```

Run a planning task:

```bash
~/.agents/skills/cheap-code-delegate/scripts/cheap_delegate.sh \
  --mode plan \
  --task "Draft a narrow implementation plan for fixing the failing lint rule."
```

Run with a specific Claude Skill:

```bash
~/.agents/skills/cheap-code-delegate/scripts/cheap_delegate.sh \
  --mode readonly \
  --skill security-review \
  --task "Inspect this diff for obvious security risks."
```

Patch mode is only for S0, S1, or narrow safe S2 tasks. Codex must review the diff before accepting it.

## Project Guardian

Initialize memory:

```bash
~/.agents/skills/project-guardian/scripts/project_guardian.sh init \
  --task "Restore skill repository"
```

Resume a project:

```bash
~/.agents/skills/project-guardian/scripts/project_guardian.sh resume
```

Show status:

```bash
~/.agents/skills/project-guardian/scripts/project_guardian.sh status
```

Write a checkpoint:

```bash
~/.agents/skills/project-guardian/scripts/project_guardian.sh checkpoint \
  --summary "Restored skill source and validation scripts."
```

---

# 中文

## 安装

```bash
./scripts/validate.sh
./install.sh
```

默认安装位置：

```text
~/.agents/skills
```

自定义安装位置：

```bash
./install.sh --target "$HOME/.codex/skills"
```

预览安装：

```bash
./install.sh --dry-run
```

## Cheap Code Delegate

列出本地 Claude Code Skills：

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

执行计划任务：

```bash
~/.agents/skills/cheap-code-delegate/scripts/cheap_delegate.sh \
  --mode plan \
  --task "Draft a narrow implementation plan for fixing the failing lint rule."
```

指定 Claude Skill：

```bash
~/.agents/skills/cheap-code-delegate/scripts/cheap_delegate.sh \
  --mode readonly \
  --skill security-review \
  --task "Inspect this diff for obvious security risks."
```

`patch` 模式只适用于 S0、S1 或安全窄范围 S2。Codex 必须审查 diff 后才能接受。

## Project Guardian

初始化项目记忆：

```bash
~/.agents/skills/project-guardian/scripts/project_guardian.sh init \
  --task "Restore skill repository"
```

恢复项目：

```bash
~/.agents/skills/project-guardian/scripts/project_guardian.sh resume
```

查看状态：

```bash
~/.agents/skills/project-guardian/scripts/project_guardian.sh status
```

写入检查点：

```bash
~/.agents/skills/project-guardian/scripts/project_guardian.sh checkpoint \
  --summary "Restored skill source and validation scripts."
```

