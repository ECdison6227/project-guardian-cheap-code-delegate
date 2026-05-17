---
name: project-guardian
description: Use when starting, resuming, modifying, checkpointing, or ending a software, documentation, paper, or project work session to manage project memory under .ai/, inspect git status safely, preserve context, and avoid unsafe git or production actions.
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
- Check branch and git status.
- Preserve branch safety.
- Summarize changed files.
- Ask before git initialization, branch creation, staging, committing, hooks, or skill maintenance.
- Never push automatically.

## Start or Resume

1. Check whether `.ai/state.json` exists.
2. Read `.ai/memory/` files if they exist.
3. Check `git status --short --branch`.
4. If not a git repo, ask before `git init`.
5. If on `main` or `master`, suggest an `ai/<task>` branch, but ask before creating it.
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

It does not run `git init`.

## After Edits

1. Run git status and a diff summary.
2. Summarize changed files.
3. If useful, use `cheap-code-delegate` for a low-cost checkpoint draft.
4. Ask before writing a memory checkpoint unless checkpointing was explicitly requested.
5. Ask before `git add` or `git commit`.
6. Never push automatically.

Helper:

```bash
$HOME/.agents/skills/project-guardian/scripts/project_guardian.sh checkpoint --summary "..."
```

## Paper Projects

If the project is a paper or thesis:

- Maintain `.ai/memory/PAPER_CONTEXT.md`.
- Track abstract, introduction, related work, method, experiments, limitations, conclusion, references, figures, tables, and equations.
- After edits, remind the user to check cross-section consistency, citations, and numbering.

## Forbidden Automatic Actions

Never run automatically:

- `git push`
- `git reset`
- `git clean`
- destructive checkout
- `rm -rf`
- deployment
- production commands

Require explicit user confirmation:

- `git init`
- creating branches
- `git add`
- `git commit`
- modifying project `AGENTS.md` or `CLAUDE.md`
- creating/updating Claude Skills
- enabling hooks

## References

Load these only when needed:

- `references/memory-schema.md`: `.ai/` file responsibilities.
- `references/git-safety.md`: safe git workflow.
- `references/paper-projects.md`: paper memory guidance.

