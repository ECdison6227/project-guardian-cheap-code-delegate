#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: claude_skill_inventory.sh [--json]

Lists Claude Code skills from:
  .claude/skills
  $HOME/.claude/skills

This command is read-only.
EOF
}

json=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    --json)
      json=true
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

roots=()
[[ -d ".claude/skills" ]] && roots+=(".claude/skills")
[[ -d "${HOME}/.claude/skills" ]] && roots+=("${HOME}/.claude/skills")

if [[ ${#roots[@]} -eq 0 ]]; then
  if [[ "$json" == true ]]; then
    printf '[]\n'
  else
    echo "No Claude Code skill directories found."
  fi
  exit 0
fi

if [[ "$json" == true ]]; then
  first=true
  printf '[\n'
  for root in "${roots[@]}"; do
    while IFS= read -r skill_file; do
      name=$(basename "$(dirname "$skill_file")")
      description=$(awk '
        BEGIN { in_fm=0 }
        NR == 1 && $0 == "---" { in_fm=1; next }
        in_fm && $0 == "---" { exit }
        in_fm && $0 ~ /^description:/ {
          sub(/^description:[[:space:]]*/, "", $0)
          gsub(/"/, "\\\"", $0)
          print
          exit
        }
      ' "$skill_file")
      [[ "$first" == true ]] || printf ',\n'
      first=false
      printf '  {"name":"%s","path":"%s","description":"%s"}' "$name" "$skill_file" "$description"
    done < <(find "$root" -mindepth 2 -maxdepth 2 -name SKILL.md -type f | sort)
  done
  printf '\n]\n'
else
  for root in "${roots[@]}"; do
    echo "## $root"
    found=false
    while IFS= read -r skill_file; do
      found=true
      name=$(basename "$(dirname "$skill_file")")
      description=$(awk '
        BEGIN { in_fm=0 }
        NR == 1 && $0 == "---" { in_fm=1; next }
        in_fm && $0 == "---" { exit }
        in_fm && $0 ~ /^description:/ {
          sub(/^description:[[:space:]]*/, "", $0)
          print
          exit
        }
      ' "$skill_file")
      printf -- "- %s: %s\n  %s\n" "$name" "$description" "$skill_file"
    done < <(find "$root" -mindepth 2 -maxdepth 2 -name SKILL.md -type f | sort)
    [[ "$found" == true ]] || echo "- No skills found."
  done
fi

