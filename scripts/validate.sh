#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

pass() {
  echo "PASS: $*"
}

required_files=(
  .github/workflows/validate.yml
  README.md
  LICENSE
  install.sh
  docs/usage.md
  docs/assets/workflow.svg
  skills/cheap-code-delegate/SKILL.md
  skills/cheap-code-delegate/scripts/cheap_delegate.sh
  skills/cheap-code-delegate/scripts/claude_skill_inventory.sh
  skills/project-guardian/SKILL.md
  skills/project-guardian/scripts/project_guardian.sh
)

for file in "${required_files[@]}"; do
  [[ -f "$file" ]] || fail "missing $file"
done
pass "required files exist"

for skill in skills/*/SKILL.md; do
  first_line="$(sed -n '1p' "$skill")"
  [[ "$first_line" == "---" ]] || fail "$skill missing YAML frontmatter opener"
  grep -q '^name:' "$skill" || fail "$skill missing name frontmatter"
  grep -q '^description:' "$skill" || fail "$skill missing description frontmatter"
done
pass "skill frontmatter is present"

for script in install.sh scripts/*.sh skills/*/scripts/*.sh; do
  bash -n "$script" || fail "bash syntax failed for $script"
done
pass "bash syntax is valid"

chmod +x install.sh scripts/validate.sh skills/cheap-code-delegate/scripts/*.sh skills/project-guardian/scripts/*.sh

./install.sh --help >/dev/null
./install.sh --dry-run >/dev/null
skills/cheap-code-delegate/scripts/cheap_delegate.sh --help >/dev/null
CHEAP_CODE_CMD=cat skills/cheap-code-delegate/scripts/cheap_delegate.sh --mode readonly --dry-run --task "Summarize repository commands." >/dev/null
skills/cheap-code-delegate/scripts/claude_skill_inventory.sh >/dev/null
skills/project-guardian/scripts/project_guardian.sh --help >/dev/null
skills/project-guardian/scripts/project_guardian.sh status >/dev/null
pass "script smoke tests passed"

if command -v shellcheck >/dev/null 2>&1; then
  shellcheck install.sh scripts/*.sh skills/*/scripts/*.sh
  pass "shellcheck passed"
else
  echo "SKIP: shellcheck not installed"
fi

echo "Validation complete."
