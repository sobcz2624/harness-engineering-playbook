#!/usr/bin/env bash
# Test: verify zh, en, and ja chapter directories are in sync
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
langs=(zh en ja)
errors=0

for src in "${langs[@]}"; do
  for tgt in "${langs[@]}"; do
    [ "$src" = "$tgt" ] && continue
    for file in "$root"/"$src"/chapters/*.md; do
      [ -f "$file" ] || continue
      basename="$(basename "$file")"
      if [ ! -f "$root/$tgt/chapters/$basename" ]; then
        echo "ERROR: $src/chapters/$basename exists but $tgt/chapters/$basename is missing"
        errors=$((errors + 1))
      fi
    done
  done
done

if [ "$errors" -gt 0 ]; then
  echo "$errors sync error(s) found"
  exit 1
fi

echo "zh/en/ja chapter files are in sync"
