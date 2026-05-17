# Usage

## Install

```bash
./install.sh
```

Use `--target` to install somewhere other than `~/.agents/skills`:

```bash
./install.sh --target "$HOME/.codex/skills"
```

## Cheap Code Delegate

Inventory local Claude Code skills:

```bash
~/.agents/skills/cheap-code-delegate/scripts/claude_skill_inventory.sh
```

Run a read-only delegation dry run:

```bash
~/.agents/skills/cheap-code-delegate/scripts/cheap_delegate.sh \
  --mode readonly \
  --dry-run \
  --task "Inspect this repository and summarize test commands."
```

Run a planning delegation:

```bash
~/.agents/skills/cheap-code-delegate/scripts/cheap_delegate.sh \
  --mode plan \
  --task "Draft a narrow implementation plan for fixing the failing lint rule."
```

Patch mode is reserved for S0, S1, or narrow safe S2 work. Codex must review the diff before accepting it.

## Project Guardian

Initialize project memory:

```bash
~/.agents/skills/project-guardian/scripts/project_guardian.sh init --task "Restore skill repository"
```

Resume a project:

```bash
~/.agents/skills/project-guardian/scripts/project_guardian.sh resume
```

Write a checkpoint:

```bash
~/.agents/skills/project-guardian/scripts/project_guardian.sh checkpoint \
  --summary "Restored skill source and validation scripts."
```

