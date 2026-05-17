#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: project_guardian.sh COMMAND [options]

Commands:
  init        Create .ai memory files if missing.
  resume      Print memory and git status summary.
  status      Print git and memory status.
  checkpoint  Append a checkpoint summary.

Options:
  --task TEXT       Task name for init.
  --mode MODE       code, docs, paper, or general. Default: code.
  --summary TEXT    Checkpoint summary.
  --help, -h        Show help.

This helper never runs git init, git add, git commit, git push, git reset,
git clean, deployments, or production commands.
EOF
}

command_name="${1:-}"
if [[ -z "$command_name" || "$command_name" == "--help" || "$command_name" == "-h" ]]; then
  usage
  exit 0
fi
shift

task="TBD"
mode="code"
summary=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --task)
      [[ $# -ge 2 ]] || { echo "--task requires a value" >&2; exit 2; }
      task="$2"
      shift 2
      ;;
    --mode)
      [[ $# -ge 2 ]] || { echo "--mode requires a value" >&2; exit 2; }
      mode="$2"
      shift 2
      ;;
    --summary)
      [[ $# -ge 2 ]] || { echo "--summary requires a value" >&2; exit 2; }
      summary="$2"
      shift 2
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

timestamp() {
  date -u +"%Y-%m-%dT%H:%M:%SZ"
}

git_branch() {
  git branch --show-current 2>/dev/null || true
}

git_status() {
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    git status --short --branch
  else
    echo "Not a git repository."
  fi
}

ensure_memory_dirs() {
  mkdir -p .ai/memory
}

write_file_if_missing() {
  local path="$1"
  local content="$2"
  if [[ ! -f "$path" ]]; then
    printf '%s\n' "$content" > "$path"
  fi
}

init_memory() {
  ensure_memory_dirs
  local now branch
  now=$(timestamp)
  branch=$(git_branch)

  if [[ ! -f .ai/state.json ]]; then
    cat > .ai/state.json <<EOF
{
  "initialized_at": "${now}",
  "last_memory_checkpoint_at": "${now}",
  "last_git_checkpoint_at": null,
  "last_resume_at": null,
  "current_task": "${task}",
  "current_branch": "${branch}",
  "mode": "${mode}",
  "reminder_minutes": 30
}
EOF
  fi

  write_file_if_missing ".ai/memory/PROJECT_MEMORY.md" "# Project Memory

## Project purpose

TBD

## Current goals

- ${task}

## Current mode

${mode}

## Setup commands

- TBD

## Test/build commands

- TBD

## Important conventions

- TBD

## Safe areas

- TBD

## Sensitive / high-risk areas

- secrets
- env files
- production config
- auth
- payment
- permissions
- database migrations
- destructive scripts

## Notes for future sessions

- TBD"

  write_file_if_missing ".ai/memory/SESSION_LOG.md" "# Session Log

## ${now}

- Initialized project memory for: ${task}"

  write_file_if_missing ".ai/memory/CHECKPOINTS.md" "# Checkpoints

## Entries"

  write_file_if_missing ".ai/memory/DECISIONS.md" "# Decisions

## Entries"

  write_file_if_missing ".ai/memory/TODO.md" "# TODO

- Continue project work safely."

  write_file_if_missing ".ai/memory/PAPER_CONTEXT.md" "# Paper Context

This is not a paper project unless updated by the user."

  echo "Project memory initialized or already present."
  git_status
}

resume_project() {
  echo "## Git status"
  git_status
  echo
  echo "## Memory files"
  if [[ -d .ai/memory ]]; then
    find .ai/memory -maxdepth 1 -type f | sort
  else
    echo "No .ai/memory directory found."
  fi
  echo
  if [[ -f .ai/memory/PROJECT_MEMORY.md ]]; then
    echo "## Project memory excerpt"
    sed -n '1,120p' .ai/memory/PROJECT_MEMORY.md
  fi
}

status_project() {
  echo "## Git status"
  git_status
  echo
  echo "## AI state"
  if [[ -f .ai/state.json ]]; then
    sed -n '1,120p' .ai/state.json
  else
    echo "No .ai/state.json found."
  fi
}

checkpoint_project() {
  [[ -n "${summary//[[:space:]]/}" ]] || { echo "checkpoint requires --summary" >&2; exit 2; }
  ensure_memory_dirs
  local now
  now=$(timestamp)
  {
    echo
    echo "## ${now}"
    echo
    echo "- ${summary}"
    echo
    echo "### Git status"
    echo
    echo '```text'
    git_status
    echo '```'
  } >> .ai/memory/CHECKPOINTS.md
  echo "Checkpoint appended to .ai/memory/CHECKPOINTS.md"
}

case "$command_name" in
  init)
    init_memory
    ;;
  resume)
    resume_project
    ;;
  status)
    status_project
    ;;
  checkpoint)
    checkpoint_project
    ;;
  *)
    echo "Unknown command: $command_name" >&2
    usage >&2
    exit 2
    ;;
esac

