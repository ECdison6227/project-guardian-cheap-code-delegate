---
name: cheap-code-delegate
description: Use before coding, debugging, refactoring, testing, linting, docs updates, CI log analysis, repository inspection, boilerplate generation, or repetitive project work to classify risk, reuse Claude Code Skills, and delegate mechanical low-risk tasks to Claude Code/MiMo while Codex remains reviewer and final decision maker.
---

# Cheap Code Delegate

Use this skill before software engineering work that may include mechanical, low-risk, repetitive, or easily verified subtasks.

## Role Split

- Codex is the controller, architect, reviewer, and final decision maker.
- Claude Code/MiMo is a low-cost worker for drafts, plans, read-only investigation, logs, tests, and narrow patches.
- Claude Code Skills are reusable workflow assets.
- Codex must review every changed line produced by a worker.
- Codex must run relevant tests after accepting a patch, or explain why tests were not run.
- Codex must reject incomplete, unsafe, broad, uncertain, or sensitive worker output.

## Classification

Classify each subtask before delegation:

- **S0 Mechanical:** run tests, lint, format, grep/search, summarize logs, inspect repo structure, discover commands, update docs, generate simple boilerplate, apply a known checklist.
- **S1 Simple Localized:** simple function following existing patterns, tests following existing patterns, rename symbols, fix obvious lint/type errors, small docs/config changes, obvious missing error handling.
- **S2 Medium Local:** local bug with mostly clear root cause, small refactor across several files, moderate test failure diagnosis, non-critical performance improvement, draft tests around suspected bug.
- **S3 Never Delegate:** architecture, security-sensitive logic, auth, permissions, payment, crypto, database migrations, concurrency, data deletion, production config, secrets, ambiguous root-cause debugging, public API design, final merge decisions, broad rewrites, breaking dependency upgrades, production-impacting work.

Delegate S0 and S1 by default when the worker is available. Delegate safe S2 only for exploration, draft patches, tests, or summaries. Keep S3 in Codex.

## Reuse Search

Before one-off delegation:

1. Check project skills: `.claude/skills/`.
2. Check personal skills: `$HOME/.claude/skills/`.
3. Prefer a matching Claude Skill when one exists.
4. If no matching skill exists, use one-off delegation.
5. If the workflow is repeatable, mechanically verifiable, and safe, ask the user before creating a new Claude Skill.
6. If an existing Claude Skill almost works, ask the user before updating it.

Use the inventory helper when useful:

```bash
$HOME/.agents/skills/cheap-code-delegate/scripts/claude_skill_inventory.sh
```

## Delegation Wrapper

Use:

```bash
$HOME/.agents/skills/cheap-code-delegate/scripts/cheap_delegate.sh --mode readonly --task "..."
$HOME/.agents/skills/cheap-code-delegate/scripts/cheap_delegate.sh --mode plan --task "..."
$HOME/.agents/skills/cheap-code-delegate/scripts/cheap_delegate.sh --mode patch --task "..."
```

Supported modes:

- `readonly`: no file changes; search, inspect, summarize, suggest commands.
- `plan`: no file changes; return implementation plan, files, risks, tests, and skill reuse assessment.
- `patch`: allow a minimal patch only for S0, S1, or narrow safe S2.

Supported options:

- `--task "..."`
- `--task-file path`
- `--skill <skill-name>`
- `--dry-run`

## Worker Review Checklist

After worker output:

1. Read the summary and risks.
2. Inspect every changed file and every diff line.
3. Reject broad rewrites, hidden assumptions, unsafe changes, or sensitive-area edits.
4. Run targeted tests or validation.
5. Decide whether to accept, revise, redo, or handle directly.
6. Record the delegation decision in the final report.

## Reusable Workflow Candidate

Suggest a new or updated Claude Skill only when:

- The workflow is likely to repeat.
- It applies to a class of files, logs, tests, docs, or edits.
- It has a stable checklist.
- Success can be verified mechanically.
- It would save future Codex tokens or user time.

Do not create, update, delete, or loosen Claude Skills without user permission unless the user explicitly requested automatic skill maintenance.

## References

Load these only when needed:

- `references/delegation-policy.md`: risk boundaries and classification examples.
- `references/claude-code-usage.md`: wrapper behavior and worker invocation details.
- `references/claude-skill-lifecycle.md`: when to create or update Claude Skills.
- `references/update-guide.md`: maintenance rules for this skill.

