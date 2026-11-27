# frentrip.github.io

Frentrip's public pages, served by GitHub Pages at https://frentrip.com (the
old frentrip.github.io addresses redirect there; `CNAME` holds the domain).

## Generated pages

Three pages are generated from markdown in Frentrip/frentrip3. Change the text
there, then regenerate the page here. Do not edit the text here.

| Page                                                               | Source in frentrip3              |
| ------------------------------------------------------------------ | -------------------------------- |
| `privacy/index.html` (https://frentrip.com/privacy/)               | `docs/legal/privacy-policy.md`   |
| `delete-account/index.html` (https://frentrip.com/delete-account/) | `docs/legal/account-deletion.md` |
| `terms/index.html` (https://frentrip.com/terms/)                   | `docs/legal/terms-of-use.md`     |

In each page, everything between the `<main>` and `</main>` lines is generated
with pandoc 3.1.3:

```sh
pandoc -f gfm -t html5 --wrap=none <source.md>
```

Use exactly that version: another may render the same markdown differently. The
rest of each file (head, styles) is hand-written. All three pages share the same head
and styles; only `<title>` and the `description` meta differ. Keep the styles in
step when you change one.

To regenerate a page, with frentrip3 checked out beside this repo, replace the
lines between `<main>` and `</main>` with pandoc's output, for example:

```sh
page=delete-account/index.html
src=../frentrip3/docs/legal/account-deletion.md
open=$(grep -nx '<main>' "$page" | cut -d: -f1)
close=$(grep -nx '</main>' "$page" | cut -d: -f1)
{ sed -n "1,${open}p" "$page"
  pandoc -f gfm -t html5 --wrap=none "$src"
  sed -n "${close},\$p" "$page"; } > "$page.new" && mv "$page.new" "$page"
```

### Checked by frentrip3

frentrip3's `Legal pages` workflow (`.github/workflows/legal-pages.yml`)
re-renders the three sources with pandoc 3.1.3 and compares the result with
this repo's `main`. It compares only the generated part, between the `<main>`
and `</main>` lines; the head and styles are not checked. Keep those two marker
lines exactly as they are (no indent): without them the check cannot run.

It runs on merges to frentrip3 `main` that change one of the three sources (or
the check), weekly, and on demand. A merge here does not start it, so after
merging a regenerated page, run it again in frentrip3 (Actions → Legal pages →
Run workflow) to confirm it is green. It never runs on PRs or blocks a merge.

To check by hand, from a frentrip3 checkout beside this repo:

```sh
node scripts/check-legal-pages.mjs ../frentrip.github.io
```

It needs pandoc 3.1.3 on the PATH (or its path in `PANDOC`), and exits 0 when
all three pages match, 1 when one differs, and 2 when it cannot check.
