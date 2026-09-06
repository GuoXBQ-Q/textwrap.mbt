# AGENTS.md

MoonBit workspace monorepo (`moon.work`) with two publishable modules:
`linebreak/` (UAX #14 line breaking) and `textwrap/` (wrapping toolkit).

## Commands

Run all commands from the repository root:

- `moon check` — type check (run regularly; it is fast)
- `moon test` — run tests; use `moon test --update` only for intended snapshot changes
- `moon fmt` — format before handoff
- `moon info` — regenerate `pkg.generated.mbti`; review the diff as the public-API signal and commit it
- `moon run linebreak/examples/basic` / `moon run textwrap/examples/demo` — runnable examples

## Conventions

- Separate top-level items with `///|`.
- Prefer many small, cohesive files; file names are organizational only.
- Black-box tests live in `*_test.mbt` and call APIs via `@linebreak` / `@textwrap`.
- Modules are published as `GuoXBQ-Q/linebreak` and `GuoXBQ-Q/textwrap`; keep
  the owner in `moon.mod` names and `moon.pkg` imports in sync with the GitHub
  owner (GuoXBQ-Q).
- Dependency pins live in `moon.mod` `import` blocks; manage them with
  `moon add` / `moon remove`, not by hand.
- Upstream attribution is mandatory (see README): unicode-linebreak
  (Apache-2.0), textwrap (MIT), UCD data files (Unicode License). Do not copy
  code from upstreams without preserving their license headers.
