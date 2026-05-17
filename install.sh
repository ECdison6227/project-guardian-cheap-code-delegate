#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: install.sh [--target DIR] [--dry-run]

Installs restored skills into the target skill directory.

Default target:
  $HOME/.agents/skills

The installer backs up a non-empty existing destination before replacing it.
It does not modify ~/.codex/AGENTS.md, run git commands, commit, push, or deploy.
EOF
}

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
target="${HOME}/.agents/skills"
dry_run=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      [[ $# -ge 2 ]] || { echo "--target requires a value" >&2; exit 2; }
      target="$2"
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

skills=(cheap-code-delegate project-guardian)
timestamp="$(date -u +%Y%m%d-%H%M%S)"

for skill in "${skills[@]}"; do
  src="${repo_root}/skills/${skill}"
  dest="${target}/${skill}"
  [[ -f "${src}/SKILL.md" ]] || { echo "Missing ${src}/SKILL.md" >&2; exit 1; }

  echo "Installing ${skill}"
  echo "  from: ${src}"
  echo "  to:   ${dest}"

  if [[ "$dry_run" == true ]]; then
    if [[ -d "$dest" ]]; then
      echo "  dry-run: existing destination would be backed up if non-empty."
    fi
    continue
  fi

  mkdir -p "$target"
  if [[ -d "$dest" ]]; then
    if find "$dest" -mindepth 1 -print -quit | grep -q .; then
      backup="${dest}.bak.${timestamp}"
      mv "$dest" "$backup"
      echo "  backed up existing destination to: ${backup}"
    else
      rmdir "$dest"
    fi
  fi

  mkdir -p "$dest"
  cp -R "${src}/." "$dest/"
  find "$dest/scripts" -type f -name '*.sh' -exec chmod +x {} \; 2>/dev/null || true
done

if [[ "$dry_run" == true ]]; then
  echo "Dry run complete. No files changed."
else
  echo "Install complete."
fi

