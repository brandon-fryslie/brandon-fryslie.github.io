#!/usr/bin/env bash
# Regenerate projects.json from the GitHub API.
#
# Run manually whenever you want a fresh snapshot, or wire into a cron-driven
# Action later. Output is committed to the repo so the Pages site can fetch
# it as static data — no GitHub API calls happen at page-load time (rate
# limits would bite anonymous viewers fast).
set -euo pipefail

USER="brandon-fryslie"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMPRAW=$(mktemp)
trap "rm -f $TMPRAW" EXIT

echo "Fetching repo list for $USER..."
gh api "users/$USER/repos?per_page=100&sort=pushed" --paginate > "$TMPRAW"

echo "Fetching user profile..."
USER_INFO=$(gh api "users/$USER" \
  --jq '{login, name, bio, html_url, avatar_url, public_repos, followers}')

NOW=$(date -u +%Y-%m-%dT%H:%M:%SZ)

# Pages of paginated results arrive as separate JSON arrays — slurp + add
# concatenates them into one. Then filter out forks (the index is for
# original work) and project to a stable shape.
jq -s --argjson user "$USER_INFO" --arg generated_at "$NOW" '
  add | {
    generated_at: $generated_at,
    user: $user,
    repos: (
      [.[]
        | select(.fork == false)
        | {
            name,
            full_name,
            description,
            language,
            stars: .stargazers_count,
            forks: .forks_count,
            pushed_at,
            url: .html_url,
            archived,
            topics,
            license: .license.spdx_id,
            owner: .owner.login
          }
      ]
      | sort_by(.pushed_at) | reverse
    )
  }
' "$TMPRAW" > "$SCRIPT_DIR/projects.json"

COUNT=$(jq '.repos | length' "$SCRIPT_DIR/projects.json")
echo "Wrote $SCRIPT_DIR/projects.json — $COUNT repos"
