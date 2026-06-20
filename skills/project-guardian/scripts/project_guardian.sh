#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: project_guardian.sh COMMAND [options]

Commands:
  init        Create .ai memory files if missing. Run git init if needed.
  resume      Print memory and git status summary.
  status      Print git and memory status.
  checkpoint  Append a checkpoint summary and auto-commit changes.

Options:
  --task TEXT       Task name for init.
  --mode MODE       code, docs, paper, or general. Default: code.
  --summary TEXT    Checkpoint summary.
  --push            Also push after commit (checkpoint only). Default: false.
  --help, -h        Show help.

Git behavior:
  - init:   runs git init automatically if not already a repo.
  - checkpoint: runs git add -A && git commit automatically.
  - push is only performed when --push is passed.
  - This helper never runs git reset, git clean, rm -rf, deployments, or
    production commands automatically.
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
push_flag=false

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
    --push)
      push_flag=true
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

timestamp() {
  date -u +"%Y-%m-%dT%H:%M:%SZ"
}

git_branch() {
  git branch --show-current 2>/dev/null || true
}

is_git_repo() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1
}

git_status() {
  if is_git_repo; then
    git status --short --branch
  else
    echo "Not a git repository."
  fi
}

git_init_if_needed() {
  if ! is_git_repo; then
    echo "Initializing git repository..."
    git init
    echo "Git repository initialized."
  else
    echo "Already a git repository."
  fi
}

git_commit_if_changed() {
  local message="$1"
  if ! is_git_repo; then
    echo "ERROR: cannot commit; not a git repository." >&2
    return 1
  fi

  # Use porcelain status so first commit (no HEAD) is handled correctly
  if [[ -z "$(git status --porcelain)" ]]; then
    echo "No changes to commit."
    return 0
  fi

  git add -A
  git commit -m "$message"
  echo "Committed: $message"
}

git_push_if_requested() {
  if [[ "$push_flag" != true ]]; then
    return 0
  fi

  if ! is_git_repo; then
    echo "ERROR: cannot push; not a git repository." >&2
    return 1
  fi

  local branch
  branch=$(git_branch)
  if [[ -z "$branch" ]]; then
    echo "ERROR: cannot push; no current branch." >&2
    return 1
  fi

  if git ls-remote --exit-code origin "$branch" >/dev/null 2>&1; then
    git push origin "$branch"
    echo "Pushed to origin/$branch"
  else
    echo "No upstream branch found. Pushing with -u origin $branch"
    git push -u origin "$branch"
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

state_set() {
  local key="$1"
  local value="$2"
  [[ -f .ai/state.json ]] || return 0
  sed -i.bak -E 's/("'"$key"'"[[:space:]]*:[[:space:]]*)("[^"]*"|null)/\1"'"$value"'"/' .ai/state.json && rm -f .ai/state.json.bak
}

init_memory() {
  ensure_memory_dirs
  git_init_if_needed

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

  # Commit initial memory files if they are new/changed
  git_commit_if_changed "project-guardian: initialize memory" || true
  git_status
}

resume_project() {
  local now branch
  now=$(timestamp)
  branch=$(git_branch)
  state_set "last_resume_at" "$now"
  state_set "current_branch" "$branch"

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
  state_set "last_memory_checkpoint_at" "$now"
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

  # Update git checkpoint timestamp before committing so it is included in the commit
  state_set "last_git_checkpoint_at" "$now"

  # Auto-commit memory and project changes
  git_commit_if_changed "checkpoint: ${summary}"

  # Push only if explicitly requested
  if [[ "$push_flag" == true ]]; then
    git_push_if_requested
  fi
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
