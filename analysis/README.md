# Chapel Analysis Workspace

This is the canonical Chapel workspace for the Dell 7810 repo.

It is meant for host characterization and proof-oriented analysis work:

- NUMA structure and partitioning checks
- timing-oriented invariant checks
- proof-structure checks over timing budgets and jitter bounds
- property-based tests using `quickchpl`
- linting with `chplcheck`

If this workspace is used in a paper or presentation, the safe framing is:

- Chapel here is a host-characterization method surface,
- `quickchpl` here is the property-based testing surface for timing and
  partitioning invariants,
- and the workspace is intentionally narrower than the full application-side
  analysis tree in `XoxdWM`.

Use [`docs/publication/claim-traceability.md`](/Users/jess/git/Dell-7810/docs/publication/claim-traceability.md)
before turning these modules or tests into broader project claims.

## Local workflow

The repo is `direnv` and flake friendly:

```bash
direnv allow
nix develop path:.#chapel
```

Then use:

```bash
just chapel-host-setup
just chapel-host-build
just chapel-host-test
just chapel-host-lint
just chapel-host-demo
just chapel-host-capture-live target=jess@honey tag=baseline
```

`chapel-host-capture-live` bootstraps itself through `path:.#chapel-capture`,
so it does not require a pre-activated Chapel shell. The first run can still be
slow while the local Chapel environment is realized, but it avoids pulling the
full CAD toolchain into the host-probe path.

The shorter `chapel-*` recipe names are kept as compatibility aliases while the
Dell repo stops advertising the same canonical analysis entry points as
`XoxdWM`.

## Preferred compiler source

The desired long-term compiler source is the dedicated Chapel flake rather than
the local fallback package in this repo.

Today the split is:

- preferred external source for cacheable compiler experiments:
  committed sibling Chapel packaging branch, typically
  `git+file:///Users/jess/git/chapel?ref=chapel-dell-7810-packaging&shallow=1#chapel-llvm19`
- preview worktree fallback while iterating on that branch:
  `path:/tmp/chapel-dell-7810-packaging#chapel-llvm19`
- sibling repo baseline for comparison:
  `path:../chapel#chapel-llvm19`
- current Dell-local fallback for repo-owned analysis work and local continuity:
  `path:.#chapel`

Useful local helpers:

```bash
just chapel-source-status
just chapel-compiler-version
just chapel-compiler-check
just chapel-compiler-check-verbose
```

The sourcing rationale and current gaps are recorded in
[`docs/platform/chapel-sourcing.md`](/Users/jess/git/Dell-7810/docs/platform/chapel-sourcing.md).

Current external preview posture:

- `2.8.0` compiler semantics
- `mason` app exposed by the preview flake
- `chapel-py` and CLI `chplcheck` packaged in the preview flake
- LSP extras intentionally not bundled into the base `chplcheck` path yet

Operational note:

- full `just chapel-compiler-check-verbose` runs can stay quiet for long
  stretches on Darwin while the Chapel compiler is being built underneath

## Project shape

- `Mason.toml`
  Mason project definition
- `src/`
  repo-owned Chapel modules for host structure and timing proofs
- `test/`
  property-based and proof-structure tests
- `examples/`
  bounded host probes and exploratory programs

Current example posture:

- `examples/HostNumaProbe.chpl`
  canonical Dell-host example
- `examples/DualSocketDemo.chpl`
  legacy compatibility shim for older references

## First live Dell host result

The first Dell-owned live result lane is tracked under:

- `TIN-470`
- GitHub mirror: `#21`

Execution surfaces:

- `just chapel-host-capture-live target=jess@honey tag=baseline`
- [`../docs/platform/chapel-live-host-result-template.md`](/Users/jess/git/Dell-7810/docs/platform/chapel-live-host-result-template.md)

The intended order is:

1. compile and run the canonical host probe on `honey`
2. capture the host context and probe output
3. write a Dell-owned result note using the template above
4. only then update broader Dell or `XoxdWM` summary claims

## Current dependency posture

- Chapel version: `2.8.0`
- property-test library: `quickchpl@1.0.2`

Current proof surfaces include:

- partition coverage and exactness for NUMA-aligned channel splits
- deterministic synthetic fixtures for repeatable host experiments
- timing-budget conformance checks over interval streams
- jitter summaries that can back reset, latency, and RT validation notes

As of April 22, 2026, `2.8.0` is the latest verified Chapel release from the official Chapel project release surfaces.
