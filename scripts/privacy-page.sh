#!/usr/bin/env bash
#
# privacy/index.html is generated from frentrip3's docs/legal/privacy-policy.md.
# Everything between the `<main>` and `</main>` lines is pandoc's output; the
# rest of the file (head, styles) is hand-written and left alone.
#
#   scripts/privacy-page.sh check <privacy-policy.md>   exit 1 if the page has drifted
#   scripts/privacy-page.sh write <privacy-policy.md>   regenerate the page in place
#
# Needs pandoc 3.1.3, the version the page was made with. Another version may
# render the same markdown slightly differently, which would read as drift.
set -euo pipefail

PANDOC_VERSION='3.1.3'
PAGE="$(cd "$(dirname "$0")/.." && pwd)/privacy/index.html"

usage() {
  echo "usage: $0 check|write <path to frentrip3 docs/legal/privacy-policy.md>" >&2
  exit 2
}

[ $# -eq 2 ] || usage
mode="$1"
source_md="$2"
case "$mode" in check | write) ;; *) usage ;; esac
[ -f "$source_md" ] || { echo "no such file: $source_md" >&2; exit 2; }

found="$(pandoc --version | head -n 1 | awk '{print $2}')"
if [ "$found" != "$PANDOC_VERSION" ]; then
  echo "pandoc $PANDOC_VERSION is required, found ${found:-none}" >&2
  exit 2
fi

# Exactly one `<main>` line and one `</main>` line, in that order.
open_line="$(grep -nx '<main>' "$PAGE" | cut -d: -f1 || true)"
close_line="$(grep -nx '</main>' "$PAGE" | cut -d: -f1 || true)"
if [ "$(printf '%s\n' "$open_line" | wc -l)" -ne 1 ] ||
  [ "$(printf '%s\n' "$close_line" | wc -l)" -ne 1 ] ||
  [ -z "$open_line" ] || [ -z "$close_line" ] ||
  [ "$open_line" -ge "$close_line" ]; then
  echo "$PAGE must have exactly one <main> line before exactly one </main> line" >&2
  exit 2
fi

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

pandoc -f gfm -t html5 --wrap=none "$source_md" -o "$tmp/expected.html"
sed -n "$((open_line + 1)),$((close_line - 1))p" "$PAGE" > "$tmp/actual.html"

if [ "$mode" = write ]; then
  {
    sed -n "1,${open_line}p" "$PAGE"
    cat "$tmp/expected.html"
    sed -n "${close_line},\$p" "$PAGE"
  } > "$tmp/page.html"
  cp "$tmp/page.html" "$PAGE"
  echo "regenerated $PAGE"
  exit 0
fi

if diff -u --label 'privacy/index.html (published)' --label 'privacy-policy.md (pandoc)' \
  "$tmp/actual.html" "$tmp/expected.html"; then
  echo "privacy/index.html matches the policy source."
else
  echo >&2
  echo "privacy/index.html has drifted from frentrip3's docs/legal/privacy-policy.md." >&2
  echo "Regenerate it: scripts/privacy-page.sh write <frentrip3>/docs/legal/privacy-policy.md" >&2
  exit 1
fi
