# frentrip.github.io

Frentrip's public pages, served by GitHub Pages.

## Privacy policy (`privacy/index.html`)

The source is `docs/legal/privacy-policy.md` in Frentrip/frentrip3. Change the
policy there, then regenerate this page. Do not edit the policy text here.

Everything between the `<main>` and `</main>` lines is generated with pandoc
3.1.3 (`pandoc -f gfm -t html5 --wrap=none`). The rest of the file (head,
styles) is hand-written. To regenerate, with frentrip3 checked out beside this
repo:

```sh
scripts/privacy-page.sh write ../frentrip3/docs/legal/privacy-policy.md
```

`scripts/privacy-page.sh check …` exits 1 and prints a diff if the page has
drifted. The script refuses any pandoc but 3.1.3, because another version may
render the same markdown differently.

### Drift check

`.github/workflows/privacy-drift.yml` runs that check on every PR, on pushes to
`main`, daily (the source can change without a commit here), and on demand. It
compares against frentrip3's `main`.

frentrip3 is private, so the workflow reads it with a read-only deploy key. It
needs one secret, set up once:

1. `ssh-keygen -t ed25519 -N '' -C privacy-drift -f privacy-drift`
2. In frentrip3: Settings → Deploy keys → Add deploy key. Paste
   `privacy-drift.pub`. Leave **Allow write access** off.
3. In this repo: Settings → Secrets and variables → Actions → New repository
   secret. Name `FRENTRIP3_DEPLOY_KEY`, value the contents of `privacy-drift`
   (the private key).
4. Delete both local files.

Until the secret exists the check fails and says why. PRs from forks get no
secrets, so the check fails on them too.
