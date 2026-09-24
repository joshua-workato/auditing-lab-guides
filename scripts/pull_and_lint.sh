#!/usr/bin/env bash
# Pulls the starter Workato project via `wk` and runs the deterministic
# recipe linter, capturing structured JSON for the audit workflow.
#
# Requires: `wk` installed, an active `wk auth` profile targeting the
# starter project's workspace/environment/region, and `recipe-lint`
# installed as a wk plugin (`wk plugins install recipe-lint`) for the
# `wk lint` step to do anything.
#
# Usage: pull_and_lint.sh <project-dir>
#   <project-dir>  Path to the wk project directory (contains .wk/wk.toml).
#                   If it doesn't exist yet, run `wk init` first and `cd`
#                   into it before calling this script.
set -euo pipefail
PROJECT_DIR="${1:?Usage: pull_and_lint.sh <project-dir>}"

if ! command -v wk >/dev/null 2>&1; then
  echo "wk CLI not found on PATH. Install and authenticate it first (see your team's wk setup guide) before running this script." >&2
  exit 1
fi

cd "$PROJECT_DIR"

echo "== wk auth status ==" >&2
# NOTE: the exact JSON shape of `wk auth status --json` isn't verified here —
# don't grep for a specific key. Whoever/whatever consumes auth-status.json
# should read it and confirm connectivity itself rather than trust this
# script's exit code alone.
wk auth status --json > auth-status.json || {
  echo "wk auth status exited non-zero — check auth-status.json before continuing" >&2
  exit 1
}
cat auth-status.json >&2

echo "== wk pull ==" >&2
wk pull --json > pull-result.json

echo "== wk lint (non-fatal if findings exist) ==" >&2
wk lint --json > lint-result.json || true

echo "Wrote auth-status.json, pull-result.json, lint-result.json in $PROJECT_DIR" >&2
