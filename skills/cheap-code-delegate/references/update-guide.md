# Update Guide

When changing this skill:

1. Keep `SKILL.md` concise.
2. Move detailed guidance into `references/`.
3. Keep scripts deterministic and shellcheck-friendly.
4. Validate with `scripts/validate.sh` at the repository root.
5. Do not weaken S3 boundaries without explicit user approval.
6. Do not add automatic commit, push, deploy, or destructive behavior.

