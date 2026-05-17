---
name: example-skill-name
description: Use for one focused mechanical workflow with clear safety boundaries and mechanical validation.
---

# Example Skill Name

## When to Use

Use this for:

- Specific repeatable workflow.
- Files or logs matching known patterns.
- Mechanically verifiable outcomes.

## Workflow

1. Inspect relevant files.
2. Apply the checklist.
3. Produce a small diff or read-only summary.
4. Run the validation command when safe.
5. Report files changed, tests run, and risks.

## Safety Boundaries

- Do not modify secrets.
- Do not commit.
- Do not push.
- Do not deploy.
- Refuse broad rewrites or sensitive areas.

