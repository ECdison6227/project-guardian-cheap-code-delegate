# Claude Code Usage

The wrapper selects a worker in this order:

1. `CHEAP_CODE_CMD`
2. `claude`
3. `cheapcode`
4. `cloud-code`
5. `cloudcode`
6. `mimo-code`
7. `opencode`
8. `openclaw`

`--dry-run` prints the selected command and complete prompt without invoking the worker.

For Claude Code, the wrapper uses `claude -p "$prompt"`. For other compatible commands, it pipes the prompt to stdin.

The worker prompt always says:

- Do not commit.
- Do not push.
- Do not deploy.
- Do not delete data.
- Do not modify secrets.
- Do not make architecture decisions.
- Refuse file changes for high-risk work.

