# Git Safety

## Safe Read-Only Commands

- `git status --short --branch`
- `git diff --stat`
- `git diff --name-only`
- `git branch --show-current`
- `git log --oneline -5`

## Require Confirmation

- `git init`
- `git switch -c ...`
- `git add ...`
- `git commit ...`
- `git push ...`
- hook installation

## Never Run Automatically

- `git reset --hard`
- `git clean -fd`
- destructive checkout
- force push

If work begins on `main` or `master`, suggest a task branch but do not create it without confirmation.

