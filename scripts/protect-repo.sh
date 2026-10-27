#!/usr/bin/env bash
# Apply the org's standard repo settings and default-branch ruleset to a repository.
# Org-level rulesets need GitHub Team, so this is applied per repo.
#
# Usage: scripts/protect-repo.sh <repo-name> [--releases]
#   --releases  also protect releases: only admins can create, move or delete v*
#               tags, published releases are immutable, and release jobs run in a
#               `release` environment limited to v* tags that needs your approval.
set -euo pipefail

ORG=open-security-tooling
REPO=${1:?usage: $0 <repo-name> [--releases]}
HERE="$(cd "$(dirname "$0")/.." && pwd)"

apply_ruleset() {
  local file=$1 name existing
  name=$(jq -r .name "$file")
  existing=$(gh api "repos/$ORG/$REPO/rulesets" --jq ".[] | select(.name == \"$name\") | .id")
  if [[ -n "$existing" ]]; then
    gh api -X PUT "repos/$ORG/$REPO/rulesets/$existing" --input "$file" --silent
    echo "Updated ruleset '$name' on $ORG/$REPO"
  else
    gh api -X POST "repos/$ORG/$REPO/rulesets" --input "$file" --silent
    echo "Created ruleset '$name' on $ORG/$REPO"
  fi
}

gh api -X PATCH "repos/$ORG/$REPO" --silent \
  -F delete_branch_on_merge=true \
  -F allow_rebase_merge=false \
  -F allow_squash_merge=true \
  -F allow_merge_commit=true \
  -F has_wiki=false

apply_ruleset "$HERE/rulesets/default-branch.json"

if [[ "${2:-}" == "--releases" ]]; then
  apply_ruleset "$HERE/rulesets/release-tags.json"
  gh api -X PUT "repos/$ORG/$REPO/immutable-releases" --silent
  me=$(gh api user --jq .id)
  jq -n --argjson id "$me" '{reviewers: [{type: "User", id: $id}], deployment_branch_policy: {protected_branches: false, custom_branch_policies: true}}' |
    gh api -X PUT "repos/$ORG/$REPO/environments/release" --input - --silent
  if ! gh api "repos/$ORG/$REPO/environments/release/deployment-branch-policies" --jq '.branch_policies[].name' | grep -qx 'v\*'; then
    gh api -X POST "repos/$ORG/$REPO/environments/release/deployment-branch-policies" -f name='v*' -f type=tag --silent
  fi
  echo "Protected releases on $ORG/$REPO: v* tag ruleset, immutable releases, release environment"
fi
