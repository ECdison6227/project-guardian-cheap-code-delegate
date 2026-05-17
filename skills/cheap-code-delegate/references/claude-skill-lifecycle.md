# Claude Skill Lifecycle

## Create a Claude Skill When

- A mechanical workflow repeats.
- The workflow has stable steps.
- Success can be checked mechanically.
- The workflow is safe to delegate.
- The skill will save tokens or time.

Default location:

- Project-specific: `.claude/skills/<skill-name>/SKILL.md`
- Personal/global: `$HOME/.claude/skills/<skill-name>/SKILL.md`

Ask before creating unless the user explicitly requested automatic maintenance.

## Update a Claude Skill When

- Instructions were unclear.
- A new edge case was found.
- A forbidden path or file pattern was discovered.
- A better test command was discovered.
- The worker produced too broad a diff.
- The skill missed an important review step.

Ask before updating.

