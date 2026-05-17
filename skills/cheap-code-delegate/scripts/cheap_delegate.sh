#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: cheap_delegate.sh [options]

Options:
  --task "..."          Task text.
  --task-file path      Read task text from a file.
  --mode MODE           readonly, plan, or patch. Default: readonly.
  --skill NAME          Ask Claude Code to use /NAME if available.
  --dry-run             Print selected command and prompt without invoking worker.
  --help, -h            Show help.

Environment:
  CHEAP_CODE_CMD        Worker command override. Defaults to claude when available.
EOF
}

mode="readonly"
task=""
task_file=""
skill="none"
dry_run=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --task)
      [[ $# -ge 2 ]] || { echo "--task requires a value" >&2; exit 2; }
      task="$2"
      shift 2
      ;;
    --task-file)
      [[ $# -ge 2 ]] || { echo "--task-file requires a value" >&2; exit 2; }
      task_file="$2"
      shift 2
      ;;
    --mode)
      [[ $# -ge 2 ]] || { echo "--mode requires a value" >&2; exit 2; }
      mode="$2"
      shift 2
      ;;
    --skill)
      [[ $# -ge 2 ]] || { echo "--skill requires a value" >&2; exit 2; }
      skill="$2"
      shift 2
      ;;
    --dry-run)
      dry_run=true
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

case "$mode" in
  readonly|plan|patch) ;;
  *)
    echo "Invalid --mode: $mode. Expected readonly, plan, or patch." >&2
    exit 2
    ;;
esac

if [[ -n "$task_file" ]]; then
  [[ -f "$task_file" ]] || { echo "Task file not found: $task_file" >&2; exit 2; }
  task=$(cat "$task_file")
elif [[ -z "$task" && ! -t 0 ]]; then
  task=$(cat)
fi

if [[ -z "${task//[[:space:]]/}" ]]; then
  echo "No task provided. Use --task, --task-file, or stdin." >&2
  exit 2
fi

worker_cmd=()
if [[ -n "${CHEAP_CODE_CMD:-}" ]]; then
  # Intentionally simple splitting for command overrides such as: "claude -p".
  read -r -a worker_cmd <<< "$CHEAP_CODE_CMD"
else
  for candidate in claude cheapcode cloud-code cloudcode mimo-code opencode openclaw; do
    if command -v "$candidate" >/dev/null 2>&1; then
      worker_cmd=("$candidate")
      break
    fi
  done
fi

if [[ ${#worker_cmd[@]} -eq 0 ]]; then
  cat >&2 <<'EOF'
No cheap coding worker was found.

Install Claude Code or set CHEAP_CODE_CMD to a compatible command, for example:
  export CHEAP_CODE_CMD="claude"
EOF
  exit 127
fi

mode_rules=""
case "$mode" in
  readonly)
    mode_rules="Read-only mode. Do not modify files. Only inspect, search, summarize, and suggest commands."
    ;;
  plan)
    mode_rules="Plan mode. Do not modify files. Return a concrete plan, files involved, risks, tests, and reuse assessment."
    ;;
  patch)
    mode_rules="Patch mode. You may produce or apply a minimal patch only for S0, S1, or narrow safe S2 work. Do not commit, push, deploy, delete data, modify secrets, or change production config."
    ;;
esac

skill_instruction="No Claude Skill was specified."
if [[ "$skill" != "none" ]]; then
  skill_instruction="Use the Claude Code Skill /${skill} if available. If it is unavailable, say so clearly and continue only if the task can be completed safely without it."
fi

prompt=$(cat <<EOF
You are a low-cost coding worker invoked by Codex.

Your role:
- Do mechanical, low-risk coding work.
- Reuse an existing Claude Code Skill when one is provided.
- Return a patch, unified diff, plan, skill proposal, or investigation result.
- Do not make final decisions.
- Do not commit.
- Do not push.
- Do not deploy.
- Do not delete data.
- Do not modify secrets.
- Do not change production config.
- Do not make architecture decisions.
- Do not touch auth, payment, permissions, crypto, database migrations, concurrency, or security-sensitive logic unless the task explicitly asks for read-only inspection.

Mode:
${mode}

Mode rules:
${mode_rules}

Optional Claude Skill to use:
${skill_instruction}

Task:
${task}

Required output:
1. Summary
2. Existing Claude Skill used, if any
3. Files inspected
4. Files changed
5. Unified diff
6. Tests run
7. Risks / uncertainties
8. Reusable workflow assessment
9. Should this become or update a Claude Skill?

Claude Code usage guidance:
- Prefer reading the repository and using existing project commands.
- Prefer CLI tools when available.
- If you need to understand available commands, inspect package.json, Makefile, justfile, Taskfile.yml, scripts/, and CI workflows.
- If a relevant Claude Skill exists, use it.
- If no file changes are needed, say so.
- If you are uncertain, say so.
- If the task appears high-risk, refuse to modify files and explain why.
- Prefer minimal, reviewable changes.
- Do not perform broad rewrites.
- Do not hide assumptions.
- Do not claim tests passed unless you actually ran them.
EOF
)

if [[ "$dry_run" == true ]]; then
  echo "Worker command: ${worker_cmd[*]}"
  echo "Mode: $mode"
  echo "Skill: $skill"
  echo
  echo "----- Delegate prompt -----"
  printf '%s\n' "$prompt"
  echo "----- End prompt -----"
  echo
  echo "Dry run only. No worker was invoked."
  exit 0
fi

cmd_name=$(basename "${worker_cmd[0]}")
if [[ "$cmd_name" == "claude" && ${#worker_cmd[@]} -eq 1 ]]; then
  "${worker_cmd[0]}" -p "$prompt"
else
  printf '%s\n' "$prompt" | "${worker_cmd[@]}"
fi

