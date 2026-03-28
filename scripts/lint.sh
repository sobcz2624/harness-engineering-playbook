#!/usr/bin/env bash
# Lint: verify all chapter files referenced in SUMMARY.md actually exist
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
errors=0

for lang in zh en; do
  summary="$root/$lang/SUMMARY.md"
  if [ ! -f "$summary" ]; then
    echo "WARN: $summary not found, skipping"
    continue
  fi

  # Extract markdown link targets (paths in parentheses)
  while read -r path; do
    full="$root/$lang/$path"
    if [ ! -f "$full" ]; then
      echo "ERROR: $lang/SUMMARY.md references '$path' but file does not exist"
      errors=1
    fi
  done < <(grep -oE '\(chapters/[^)]+\)' "$summary" | tr -d '()')
done

if [ "$errors" -ne 0 ]; then
  echo "SUMMARY.md references check FAILED"
  exit 1
fi

echo "All SUMMARY.md references OK"
