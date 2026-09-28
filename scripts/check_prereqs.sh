#!/usr/bin/env bash
# Checks the prerequisites SKILL.md's Prerequisites section lists, so a
# missing dependency surfaces before starting an audit instead of mid-run.
#
# Only checks what's reliably checkable from the shell. It deliberately
# does NOT try to verify the recipe-lint wk plugin is installed, or that a
# Google Sheets/Drive MCP tool is connected -- those aren't reliably
# checkable outside the tool's own environment (same reasoning as
# pull_and_lint.sh's note on not trusting wk's exact JSON shape). Those two
# are printed as manual reminders instead of asserted on.
#
# Usage: check_prereqs.sh
# Exit status: 0 if every checkable prerequisite passes, 1 otherwise.
set -uo pipefail

FAIL=0

check() {
  local label="$1"
  shift
  if "$@" >/dev/null 2>&1; then
    echo "OK    $label"
  else
    echo "MISSING  $label"
    FAIL=1
  fi
}

echo "== Checkable prerequisites =="

check "wk CLI on PATH" command -v wk

if command -v wk >/dev/null 2>&1; then
  check "wk auth status succeeds (exit code only -- shape not verified)" wk auth status --json
fi

if [ -n "${RECIPE_SKILLS_DIR:-}" ]; then
  check "\$RECIPE_SKILLS_DIR points at a real recipe-skills checkout (has a skills/ dir)" \
    test -d "$RECIPE_SKILLS_DIR/skills"
else
  echo "MISSING  \$RECIPE_SKILLS_DIR is not set"
  echo "         Clone https://github.com/workato-devs/recipe-skills.git and export"
  echo "         RECIPE_SKILLS_DIR=<path to it>, or pass the path explicitly to"
  echo "         scripts/find_connector_skill.sh on every call instead."
  FAIL=1
fi

echo
echo "== Not checkable from the shell -- confirm these yourself =="
echo "  - recipe-lint installed as a wk plugin (wk plugins install recipe-lint)"
echo "  - a Google Sheets tool is connected in this environment (required for"
echo "    team/shared audits, not optional -- see SKILL.md Step 5)"
echo "  - a Drive tool is connected (recommended, not required -- enables"
echo "    template-copy formatting instead of a blank sheet)"
echo "  - the Topic label for this run is decided (SKILL.md Step 1.4)"

echo
if [ "$FAIL" -eq 0 ]; then
  echo "All checkable prerequisites pass."
else
  echo "One or more checkable prerequisites are missing -- see MISSING lines above."
fi
exit "$FAIL"
