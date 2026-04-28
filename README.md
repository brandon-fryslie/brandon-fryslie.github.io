# brandon-fryslie.github.io

Root GitHub Pages site for `brandon-fryslie` — a hand-curated index of
deployed Pages sites.

Live at **https://brandon-fryslie.github.io/**.

## How it works

`sites.json` is hand-curated. To add or remove a site, edit it directly —
the file's `_comment` field documents the entry shape. Order in the file
is the display order on the page.

`index.html` / `style.css` / `main.js` fetch the JSON at load and render
the grid of cards. No build step, no GitHub API calls at runtime.

## Why hand-curated, not auto-generated

The auto-discovery pass (filtering repos by `has_pages`) included dead
deploys, test harnesses, and orphan `gh-pages` branches; it also missed
the multi-deploy story that `gh-pages-multiplexer` enables. A static list
is the right granularity: I decide what shows up, descriptions are
written for visitors instead of inherited from terse repo metadata, and
cards land on the canonical entrypoint URL — `gh-pages-multiplexer`'s
redirect handles routing to whatever version is current.

## The continuum

- `github.com/brandon-fryslie` — the GitHub profile (markdown + sandboxed SVG)
- `brandon-fryslie.github.io/brandon-fryslie/` — the elaborated profile (HTML + JS)
- `brandon-fryslie.github.io/` — *(this site)* the deployed-sites index
