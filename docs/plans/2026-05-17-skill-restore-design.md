# Skill Restore Design

## Goal

Restore `project-guardian` and `cheap-code-delegate` as GitHub-ready source, then install them back into the local global skill directory.

## Approach

The repository keeps publishable source under `skills/`, deterministic helper commands under each skill's `scripts/`, and repository-level validation under `scripts/validate.sh`. Installation copies each skill folder into `~/.agents/skills` with backup protection for non-empty existing targets.

## Components

- `skills/cheap-code-delegate/SKILL.md`: Codex workflow for classifying work, reusing Claude Skills, and delegating only low-risk tasks.
- `skills/cheap-code-delegate/scripts/cheap_delegate.sh`: Safe wrapper around Claude Code or a compatible worker command.
- `skills/cheap-code-delegate/scripts/claude_skill_inventory.sh`: Read-only inventory of project and personal Claude Skills.
- `skills/project-guardian/SKILL.md`: Project lifecycle, memory, branch, and checkpoint workflow.
- `skills/project-guardian/scripts/project_guardian.sh`: Deterministic memory init/resume/status/checkpoint helper.
- `install.sh`: Local installer with dry-run and backup behavior.
- `scripts/validate.sh`: Structural and shell validation.

## Safety

The restored tools do not push, deploy, delete data, run destructive git commands, or make commits automatically. Git initialization, branch creation, staging, committing, and skill maintenance remain explicit user decisions.

