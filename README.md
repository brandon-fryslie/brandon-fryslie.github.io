# brandon-fryslie.github.io

Root GitHub Pages site for `brandon-fryslie` — an index of public projects.

Live at **https://brandon-fryslie.github.io/**.

## How it works

`projects.json` is a static snapshot of repo metadata pulled from the GitHub API.
The page (`index.html` / `style.css` / `main.js`) fetches it at load and
renders a filterable grid. No GitHub API calls happen at page-load time —
anonymous viewers don't have to worry about rate limits.

## Refreshing the index

```sh
./generate.sh
git add projects.json && git commit -m 'Refresh projects index' && git push
```

`generate.sh` queries `users/brandon-fryslie/repos` (paginated), filters out
forks, and writes `projects.json`. It uses the locally-authenticated `gh` CLI.

## Companion site

The constrained-vs-unconstrained continuum:

- [github.com/brandon-fryslie](https://github.com/brandon-fryslie) — the GitHub profile (markdown + sandboxed SVG)
- [brandon-fryslie.github.io/brandon-fryslie](https://brandon-fryslie.github.io/brandon-fryslie/) — the elaborated profile (HTML + JS)
- [brandon-fryslie.github.io](https://brandon-fryslie.github.io/) — *(this site)* the project index
