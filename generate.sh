#!/usr/bin/env bash
# Regenerate sites.json — the index of brandon-fryslie's *deployed* GitHub
# Pages sites. Repos without Pages enabled are not in scope for this index;
# repo discovery already exists at github.com/brandon-fryslie.
#
# What goes in: every non-fork repo where `has_pages == true`.
# What we attach: live Pages URL, build status, source branch/path, repo
# description, language, last-push date.
#
# Output is committed alongside the page so anonymous viewers don't trigger
# rate-limited GitHub API calls at load time.
set -euo pipefail

USER="brandon-fryslie"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP_REPOS=$(mktemp)
TMP_SITES=$(mktemp)
trap "rm -f $TMP_REPOS $TMP_SITES" EXIT

echo "Fetching repo list for $USER..."
gh api "users/$USER/repos?per_page=100&sort=pushed" --paginate > "$TMP_REPOS"

# Filter to Pages-enabled non-forks first; this is a small set (10ish repos)
# so the per-repo pages API call below is cheap.
PAGES_REPOS=$(jq -s 'add | [.[] | select(.fork == false and .has_pages == true) | .name]' "$TMP_REPOS")

echo "Pages-enabled repos: $(echo "$PAGES_REPOS" | jq 'length')"

echo "[" > "$TMP_SITES"
FIRST=1
for name in $(echo "$PAGES_REPOS" | jq -r '.[]'); do
  echo "  fetching pages metadata for $name..."
  PAGES=$(gh api "repos/$USER/$name/pages" 2>/dev/null \
    --jq '{pages_url: .html_url, pages_status: .status, cname, source_branch: .source.branch, source_path: .source.path}')
  REPO=$(jq -s --arg n "$name" 'add | [.[] | select(.name == $n)][0] | {
    name,
    description,
    language,
    pushed_at,
    repo_url: .html_url,
    archived,
    topics
  }' "$TMP_REPOS")
  MERGED=$(jq -n --argjson repo "$REPO" --argjson pages "$PAGES" '$repo + $pages')
  [ $FIRST -eq 1 ] && FIRST=0 || echo "," >> "$TMP_SITES"
  echo "$MERGED" >> "$TMP_SITES"
done
echo "]" >> "$TMP_SITES"

USER_INFO=$(gh api "users/$USER" \
  --jq '{login, name, bio, html_url, avatar_url}')

NOW=$(date -u +%Y-%m-%dT%H:%M:%SZ)

# Final shape: the page can present sites grouped, sorted, or filtered however
# it likes. We keep them sorted by pushed_at desc as a sensible default.
jq --argjson user "$USER_INFO" --arg generated_at "$NOW" '{
  generated_at: $generated_at,
  user: $user,
  sites: (sort_by(.pushed_at) | reverse)
}' "$TMP_SITES" > "$SCRIPT_DIR/sites.json"

COUNT=$(jq '.sites | length' "$SCRIPT_DIR/sites.json")
echo "Wrote $SCRIPT_DIR/sites.json — $COUNT deployed Pages sites"
