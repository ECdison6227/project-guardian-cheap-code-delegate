# Project Guardian + Cheap Code Delegate

This repository restores two local Codex skills:

- `project-guardian`: project memory, resume, status, and checkpoint workflow.
- `cheap-code-delegate`: cost-aware delegation to Claude Code/MiMo for mechanical, low-risk engineering work.

The repository is designed to be installed into `~/.agents/skills` and uploaded to GitHub as source. It does not modify `~/.codex/AGENTS.md`, create commits, push branches, or deploy anything.

## Quick Start

Validate the restored source:

```bash
./scripts/validate.sh
```

Install into the default local skill directory:

```bash
./install.sh
```

Dry-run the install:

```bash
./install.sh --dry-run
```

After install, the skills should exist at:

```text
~/.agents/skills/cheap-code-delegate/SKILL.md
~/.agents/skills/project-guardian/SKILL.md
```

## GitHub Readiness

Before publishing:

1. Run `./scripts/validate.sh`.
2. Review `git status --short`.
3. Choose a license if you want others to reuse the code.
4. Commit locally.
5. Create the GitHub repository and push.

This project intentionally does not include a license yet. Without a license, others can view the code on GitHub but do not receive broad reuse rights.

