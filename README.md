# brandon-fryslie.github.io

Root GitHub Pages site for `brandon-fryslie` — an index of *deployed* Pages
sites. Repo discovery already exists at github.com/brandon-fryslie; this is
the live-things layer: which of those repos are actually serving a site.

Live at **https://brandon-fryslie.github.io/**.

## How it works

`sites.json` is a static snapshot generated from the GitHub API. It contains:

- One entry per repo with `has_pages: true` (forks excluded)
- For each: live URL, build status, source branch/path, repo description,
  language, last-pushed date

`index.html` / `style.css` / `main.js` fetch that JSON at load and render
the grid. No GitHub API calls happen at page-load time, so anonymous viewers
don't trigger rate limits.

## Refreshing the index

```sh
./generate.sh
git add sites.json && git commit -m 'Refresh sites index' && git push
```

`generate.sh` queries `users/brandon-fryslie/repos` (paginated, filters by
`has_pages`), then `repos/.../pages` per repo for live URL + build status.

## The continuum

- `github.com/brandon-fryslie` — the GitHub profile (markdown + sandboxed SVG)
- `brandon-fryslie.github.io/brandon-fryslie/` — the elaborated profile (HTML + JS)
- `brandon-fryslie.github.io/` — *(this site)* the deployed-sites index
