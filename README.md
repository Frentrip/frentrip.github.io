# frentrip.github.io

Frentrip's public pages, served by GitHub Pages.

## Generated pages

Two pages are generated from markdown in Frentrip/frentrip3. Change the text
there, then regenerate the page here. Do not edit the text here.

| Page                                                                     | Source in frentrip3              |
| ------------------------------------------------------------------------ | -------------------------------- |
| `privacy/index.html` (https://frentrip.github.io/privacy/)               | `docs/legal/privacy-policy.md`   |
| `delete-account/index.html` (https://frentrip.github.io/delete-account/) | `docs/legal/account-deletion.md` |

In each page, everything between the `<main>` and `</main>` lines is generated
with pandoc 3.1.3:

```sh
pandoc -f gfm -t html5 --wrap=none <source.md>
```

Use exactly that version: another may render the same markdown differently. The
rest of each file (head, styles) is hand-written. Both pages share the same head
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
