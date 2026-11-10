#!/usr/bin/env bash
# Acceptance check for every rule in rules/.
#
# Each rule has a fixture at tests/fixtures/<rule>.ws. A Workshop rule whose
# name starts with "flagged" must produce exactly one finding of the rule under
# test; a rule whose name starts with "clean" must produce none.
#
# The rules load through the same pinned-package path a project uses. The store
# entry is keyed by a content hash, so a changed rule set never reuses a stale
# entry, and old entries need no cleanup. Bare rule IDs replace Wright's native rules of the same ID, so the
# check also fails when a finding does not come from this package.
set -euo pipefail

cd "$(dirname "$0")/.."

repo="wrightkit/lint-rules"
wright="${WRIGHT:-wright}"

sha="$(cat rules/*.yaml | shasum | cut -c1-40)"
store="$PWD/.store"
mkdir -p "$store/$repo/$sha"
cp -R rules "$store/$repo/$sha/"
config="$store/lint.yaml"
printf 'packages:\n  - repo: %s\n    sha: %s\n' "$repo" "$sha" > "$config"

status=0
for rule_file in rules/*.yaml; do
  id="$(basename "$rule_file" .yaml)"
  fixture="tests/fixtures/$id.ws"
  if [ ! -f "$fixture" ]; then
    echo "FAIL $id: missing $fixture"
    status=1
    continue
  fi

  result="$(WRIGHT_LINT_PACKAGE_DIR="$store" "$wright" lint -f json --all \
    --lint-config "$config" --rule-id "$id" "$fixture")"
  if [ "$(jq '.diagnostics | length' <<<"$result")" != 0 ]; then
    echo "FAIL $id: $(jq -c '[.diagnostics[] | {code, message}]' <<<"$result")"
    status=1
    continue
  fi
  lines="$(jq -r '.result.findings[]
    | select(.message | test("\\(matched [0-9]+ nodes?\\)$"))
    | .location | split(":")[1]' <<<"$result")"
  total="$(jq '.result.findings | length' <<<"$result")"

  # One "start name" row per Workshop rule, in file order.
  rows="$(grep -n '^rule ("' "$fixture" | sed -E 's/^([0-9]+):rule \("([^"]*)".*/\1 \2/')"
  failed=0
  checked=0
  while read -r start name; do
    end="$(awk -v s="$start" '$1 > s { print $1; exit }' <<<"$rows")"
    end="${end:-999999}"
    count=0
    for line in $lines; do
      if [ "$line" -ge "$start" ] && [ "$line" -lt "$end" ]; then count=$((count + 1)); fi
    done
    checked=$((checked + count))
    case "$name" in
      flagged*) want=1 ;;
      clean*) want=0 ;;
      *) echo "FAIL $id: rule \"$name\" must start with flagged or clean"; failed=1; continue ;;
    esac
    if [ "$count" != "$want" ]; then
      echo "FAIL $id: \"$name\" has $count findings, expected $want"
      failed=1
    fi
  done <<<"$rows"
  if [ "$checked" != "$total" ]; then
    echo "FAIL $id: $((total - checked)) findings did not come from this package"
    failed=1
  fi

  if [ "$failed" = 0 ]; then echo "ok   $id"; else status=1; fi
done
exit "$status"
