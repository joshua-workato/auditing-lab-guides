#!/usr/bin/env bash
# Locates the recipe-skills reference material for a connector, from a
# local checkout of https://github.com/workato-devs/recipe-skills.
# lint-rules.json is the source of truth for that connector's valid
# action/trigger names — always check claims against it, never against
# general/trained knowledge of the connector (it goes stale).
#
# If no checkout exists yet: git clone https://github.com/workato-devs/recipe-skills.git
#
# Usage: find_connector_skill.sh <recipe-skills-checkout> <connector-name>
#   e.g. find_connector_skill.sh ./recipe-skills jira
set -euo pipefail
REPO="${1:?Usage: find_connector_skill.sh <recipe-skills-checkout> <connector-name>}"
CONNECTOR="${2:?Usage: find_connector_skill.sh <recipe-skills-checkout> <connector-name>}"

MATCH=$(find "$REPO/skills" -maxdepth 1 -type d -iname "${CONNECTOR}-recipes" 2>/dev/null | head -1)

if [ -z "$MATCH" ]; then
  echo "No skill found for connector '$CONNECTOR'. Available connectors:" >&2
  find "$REPO/skills" -maxdepth 1 -type d -name "*-recipes" -exec basename {} \; 2>/dev/null | sed 's/-recipes$//'
  echo "(Not every connector has a skill yet — absence here isn't itself a bug signal.)" >&2
  exit 1
fi

echo "lint-rules: $MATCH/lint-rules.json"
echo "guidance:   $MATCH/SKILL.md"
echo "checklist:  $MATCH/validation-checklist.md"
