# AGENTS.md

This repository is WrightKit's first-party lint rule package. Apply the
workspace `AGENTS.md` first, then these rules.

## Ownership

- This repository owns rule content: the files in `rules/` and their fixtures.
- Wright owns the rule format, the matcher, and the loader
  ([SPEC-309](https://github.com/wrightkit/wright/blob/main/docs/specs/SPEC-309-extensible-lint-rules.md)).
  A rule that the matcher cannot express stays a native rule in Wright. Do not
  work around a missing matcher feature here; propose it in `wrightkit/wright`.

## Admitting a rule

- A rule reports a high-confidence structural fact with few false positives
  (WrightKit goal, principle 10). Broader or opinionated checks belong in a
  community package.
- `metadata` has `summary`, `rationale`, `documentation`, `known-limits`, and
  `tags`. `known-limits` states what the structural match cannot prove.
- `evidence` and `severity` are allowed only in this package. Declare
  `evidence` for every rule. `severity: error` requires
  `evidence: runtime-validated`; Wright refuses any other combination.
- The rule ID is the file name without `.yaml`. A rule that replaces a native
  Wright rule keeps the native rule's bare ID. A new rule needs an owner
  decision on whether it is enabled by default, because every rule here ships
  in Wright.

## Changing a rule

- Every rule change comes with its fixture change in `tests/fixtures/<id>.ws`.
  A Workshop rule named `flagged...` must produce exactly one finding, and one
  named `clean...` must produce none. Cover each matched scope and each
  documented exclusion.
- A change that replaces a native rule, or changes what an existing rule
  reports, states in the PR how the findings compare with the previous
  behavior on the fixtures and on a real project.
- Run `tests/run.sh` before opening a PR. It needs `wright` (or `WRIGHT` set to
  its path), `jq`, and `shasum`.

## How a change reaches users

- CI runs the fixtures against the latest Wright release.
- Wright embeds this repository's `rules/` at a recorded commit SHA. A merged
  change reaches users when Wright bumps that SHA in a PR and releases; users
  then receive it through `wright update self`. Until `wrightkit/wright#1081`
  lands, Wright still ships native copies of the rules here.
- A project can use a newer revision before that by pinning this repository
  with a full SHA under `packages` in its lint configuration. The pinned
  revision replaces the embedded one.
