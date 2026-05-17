# Memory Schema

Project memory lives in `.ai/`.

## `.ai/state.json`

Machine-readable session state:

- `initialized_at`
- `last_memory_checkpoint_at`
- `last_git_checkpoint_at`
- `last_resume_at`
- `current_task`
- `current_branch`
- `mode`
- `reminder_minutes`

## `.ai/memory/PROJECT_MEMORY.md`

Stable project facts:

- Purpose
- Goals
- Setup commands
- Test/build commands
- Conventions
- Safe areas
- Sensitive areas

## `.ai/memory/SESSION_LOG.md`

Chronological session notes.

## `.ai/memory/CHECKPOINTS.md`

Concise checkpoints after meaningful work.

## `.ai/memory/DECISIONS.md`

Project decisions and rationale.

## `.ai/memory/TODO.md`

Open tasks and follow-ups.

## `.ai/memory/PAPER_CONTEXT.md`

Only used for paper projects.

