#!/usr/bin/env bash
# Apply the org's standard repo settings and default-branch ruleset to a repository.
# Org-level rulesets need GitHub Team, so this is applied per repo.
#
# Usage: scripts/protect-repo.sh <repo-name>
set -euo pipefail

ORG=open-security-tooling
REPO=${1:?usage: $0 <repo-name>}
RULESET="$(cd "$(dirname "$0")/.." && pwd)/rulesets/default-branch.json"
NAME=$(jq -r .name "$RULESET")

gh api -X PATCH "repos/$ORG/$REPO" --silent \
  -F delete_branch_on_merge=true \
  -F allow_rebase_merge=false \
  -F allow_squash_merge=true \
  -F allow_merge_commit=true

existing=$(gh api "repos/$ORG/$REPO/rulesets" --jq ".[] | select(.name == \"$NAME\") | .id")
if [[ -n "$existing" ]]; then
  gh api -X PUT "repos/$ORG/$REPO/rulesets/$existing" --input "$RULESET" --silent
  echo "Updated ruleset '$NAME' on $ORG/$REPO"
else
  gh api -X POST "repos/$ORG/$REPO/rulesets" --input "$RULESET" --silent
  echo "Created ruleset '$NAME' on $ORG/$REPO"
fi
