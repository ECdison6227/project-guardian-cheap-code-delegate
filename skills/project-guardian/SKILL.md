---
name: project-guardian
description: Use when starting, resuming, modifying, checkpointing, or ending a software, documentation, paper, or project work session to manage project memory under .ai/, enforce git discipline, preserve context, and avoid unsafe git or production actions.
---

# Project Guardian

Use this skill at project boundaries:

- Starting a project.
- Resuming after context loss or a new thread.
- Before major edits.
- After file modifications.
- After a cheap worker produced a patch.
- Ending a work session.
- More than 30 minutes after the last memory checkpoint.

## Core Responsibilities

- Maintain project memory in `.ai/memory/`.
- Maintain machine-readable state in `.ai/state.json`.
- **Enforce git discipline**: initialize, stage, and commit automatically. Do not just mention git—run it.
- Preserve branch safety.
- Summarize changed files.
- Never push, reset, clean, deploy, or run destructive commands automatically.

## Start or Resume

1. Check whether `.ai/state.json` exists.
2. Read `.ai/memory/` files if they exist.
3. Check `git status --short --branch`.
4. **If not a git repo, run `git init` automatically.**
5. If on `main` or `master`, suggest an `ai/<task>` branch to the user, but do not create it without confirmation.
6. Produce a concise resume summary before doing new work.

Helper:

```bash
$HOME/.agents/skills/project-guardian/scripts/project_guardian.sh resume
```

## Initialize Memory

Use the helper when a project has no memory:

```bash
$HOME/.agents/skills/project-guardian/scripts/project_guardian.sh init --task "..."
```

The helper creates:

- `.ai/state.json`
- `.ai/memory/PROJECT_MEMORY.md`
- `.ai/memory/SESSION_LOG.md`
- `.ai/memory/CHECKPOINTS.md`
- `.ai/memory/DECISIONS.md`
- `.ai/memory/TODO.md`
- `.ai/memory/PAPER_CONTEXT.md`

It also runs `git init` if the directory is not already a git repository.

## After Edits

1. Run git status and a diff summary.
2. Summarize changed files.
3. If useful, use `cheap-code-delegate` for a low-cost checkpoint draft.
4. **Write a memory checkpoint automatically.**
5. **Run `git add -A` and `git commit -m "checkpoint: <summary>"` automatically.**
6. Do not push unless the user explicitly asks or you pass `--push`.

Helper:

```bash
# Auto-commit locally
$HOME/.agents/skills/project-guardian/scripts/project_guardian.sh checkpoint --summary "..."

# Auto-commit and push (requires explicit intent)
$HOME/.agents/skills/project-guardian/scripts/project_guardian.sh checkpoint --summary "..." --push
```

## Paper Projects

If the project is a paper or thesis:

- Maintain `.ai/memory/PAPER_CONTEXT.md`.
- Track abstract, introduction, related work, method, experiments, limitations, conclusion, references, figures, tables, and equations.
- After edits, remind the user to check cross-section consistency, citations, and numbering.

## Automatic Actions

Run automatically:

- `git init` when the directory is not a git repository.
- `git add -A` when checkpointing.
- `git commit` when checkpointing.
- Writing `.ai/memory` checkpoints.

## Require Explicit User Confirmation

Do not run automatically:

- `git push`
- `git reset`
- `git clean`
- destructive checkout
- `rm -rf`
- deployment
- production commands
- creating branches other than the auto-suggested `ai/<task>` branch

## References

Load these only when needed:

- `references/memory-schema.md`: `.ai/` file responsibilities.
- `references/git-safety.md`: safe git workflow.
- `references/paper-projects.md`: paper memory guidance.
