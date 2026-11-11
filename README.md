# lint-rules

First-party lint rule package for [Wright](https://github.com/wrightkit/wright).
Rules are declarative YAML files in `rules/`, following the Wright lint rule
contract (SPEC-309).

| Rule | Reports |
| --- | --- |
| `expensive-loop-check` | a `distance` or `isInLoS` call inside a loop body |
| `min-wait-loop` | a loop whose body waits 0.016 s or less |
| `nested-binder-lambda` | an element-binding array call inside another binder's per-element argument |

## Use

The rules need Wright 0.41.0 or later. Older releases refuse the whole package.

Wright ships these rules by default, so no configuration is needed. To use a
revision of this repository instead, pin it by full commit SHA in the project's
lint configuration:

```yaml
packages:
  - repo: wrightkit/lint-rules
    sha: <full commit SHA>
```

The pinned revision replaces Wright's default rules that have the same IDs.
Today those defaults are native rules in Wright; from `wrightkit/wright#1081`
on, Wright embeds a recorded revision of this package instead. Project
configuration sets each rule's enablement and severity.

## Test

```sh
tests/run.sh
```

Requires Wright 0.41.0 or later as `wright`, plus `jq` and `shasum`, on
`PATH`. Set `WRIGHT` to test another Wright executable. [`AGENTS.md`](AGENTS.md) defines the fixture format and how
rules are admitted and changed.
