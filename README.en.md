<p align="center">
  <a href="README.md">中文</a> | <a href="README.en.md">English</a>
</p>

<p align="center">
  <img src="docs/assets/workflow.svg" alt="Project Guardian + Cheap Code Delegate" width="100%"/>
</p>

<p align="center">
  Two local Codex skills for safer, cheaper, and more repeatable AI-assisted software work
</p>

<p align="center">
  <a href="#install">🚀 Install</a> ·
  <a href="#usage">📖 Usage</a> ·
  <a href="#safety-boundaries">🛡 Safety</a>
</p>

---

## One-click Setup

If you don't want to install manually, paste this prompt into your Coding Agent (Trae / Codex / Claude Code) and let it do the rest:

```text
Please install and configure https://github.com/ECdison6227/project-guardian-cheap-code-delegate:

1. Git clone the repo into a temporary directory
2. Run ./install.sh to install the skills
3. Tell me what the two skills do and their trigger words
4. If any skill needs initial setup (project memory, delegation worker), guide me through it
5. Finally, demo how to call project-guardian to initialize a project
```

---

## Why This Exists

Codex is best used for judgment-heavy work: architecture, review, safety decisions, and integrating context. Many engineering subtasks are lower-risk and repetitive: searching a repo, summarizing logs, finding test commands, drafting boilerplate, or producing narrow patches. This project gives Codex a repeatable workflow for sending those subtasks to a cheaper local worker without giving up control.

## Skills

### `project-guardian`

Use when starting, resuming, modifying, checkpointing, or ending a project session.

It manages:

- `.ai/state.json`
- `.ai/memory/PROJECT_MEMORY.md`
- `.ai/memory/SESSION_LOG.md`
- `.ai/memory/CHECKPOINTS.md`
- `.ai/memory/DECISIONS.md`
- `.ai/memory/TODO.md`
- `.ai/memory/PAPER_CONTEXT.md`

It automatically runs `git init` when a project is not yet a repository, and it automatically runs `git add -A` + `git commit` on every checkpoint. It never pushes, resets, cleans, deploys, or runs destructive commands automatically.

### `cheap-code-delegate`

Use before coding, debugging, refactoring, testing, linting, documentation updates, CI log analysis, repository inspection, boilerplate generation, or repetitive project work.

It classifies work as:

- `S0`: mechanical tasks
- `S1`: simple localized implementation
- `S2`: medium-risk local work
- `S3`: never delegate

Only S0, S1, and safe narrow S2 work should be delegated. Codex must review every changed line produced by the worker.

## Install

Clone the repository and run:

```bash
./scripts/validate.sh
./install.sh
```

Default install target:

```text
~/.agents/skills
```

Install somewhere else:

```bash
./install.sh --target "$HOME/.codex/skills"
```

Dry-run install:

```bash
./install.sh --dry-run
```

## Usage

Inventory Claude Code skills:

```bash
~/.agents/skills/cheap-code-delegate/scripts/claude_skill_inventory.sh
```

Run a read-only delegation dry run:

```bash
~/.agents/skills/cheap-code-delegate/scripts/cheap_delegate.sh \
  --mode readonly \
  --dry-run \
  --task "Inspect this repository and summarize test commands."
```

Initialize project memory:

```bash
~/.agents/skills/project-guardian/scripts/project_guardian.sh init \
  --task "Start a new project"
```

Resume project context:

```bash
~/.agents/skills/project-guardian/scripts/project_guardian.sh resume
```

## Safety Boundaries

These tools do not automatically:

- push to git remotes
- run `git reset` or `git clean`
- deploy
- delete project data
- modify secrets
- edit production configuration

`project-guardian` does automatically create commits on checkpoints, but it never pushes them without an explicit `--push` flag.

Sensitive work stays with Codex: security, auth, permissions, payments, database migrations, concurrency, public API design, broad rewrites, and final merge decisions.

## Repository Layout

```text
.
├── install.sh
├── scripts/
│   └── validate.sh
├── docs/
│   └── usage.md
└── skills/
    ├── cheap-code-delegate/
    │   ├── SKILL.md
    │   ├── references/
    │   ├── scripts/
    │   └── templates/
    └── project-guardian/
        ├── SKILL.md
        ├── references/
        ├── scripts/
        └── templates/
```

## Requirements

- macOS, Linux, or another Unix-like environment
- Bash
- Git
- Optional: `claude` CLI for delegation
- Optional: `shellcheck` for stricter script linting

`cheap_delegate.sh` falls back to `CHEAP_CODE_CMD` when `claude` is unavailable.

## Validation

```bash
./scripts/validate.sh
```

The validation script checks required files, skill frontmatter, bash syntax, and smoke tests. It runs `shellcheck` only when available.

## License

MIT License. See [LICENSE](LICENSE).
