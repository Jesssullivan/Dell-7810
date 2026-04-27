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

Use [`docs/publication/claim-traceability.md`](../docs/publication/claim-traceability.md)
before turning these modules or tests into broader project claims.

## Local workflow

The repo is `direnv` and flake friendly:

```bash
direnv allow
nix develop path:.#chapel
```

Then use:

```bash
export DELL_7810_TARGET=user@host
just chapel-host-setup
just chapel-host-build
just chapel-host-test
just chapel-host-lint
just chapel-host-demo
just chapel-host-capture-live tag=baseline
just chapel-host-capture-live-save tag=baseline
just chapel-host-capture-live-external tag=baseline
just chapel-host-capture-live-save-external tag=baseline
just chapel-host-capture-live-on-target tag=baseline
just chapel-host-capture-live-save-on-target tag=baseline
just chapel-host-capture-local tag=baseline
just chapel-host-capture-local-save tag=baseline
```

`chapel-host-capture-live` bootstraps itself through `path:.#chapel-capture`,
so it does not require a pre-activated Chapel shell. The first run can still be
slow while the local Chapel environment is realized, but it avoids pulling the
full CAD toolchain into the host-probe path.

Current build/execution split:

- cacheable build/package work is being converged onto the self-hosted
  GloriousFlywheel/HPA dogfood path
- the checked-in CI path now targets `honey`-labeled `tinyland-nix` runners,
  but `Dell-7810` is not yet enrolled in a compatible runner set, so the
  self-hosted path is not live for this repo today
- `honey` remains the machine-under-test for the final host evidence
- the current `--option builders ''` and on-target build paths are continuity
  surfaces for host truth, not the canonical CI shape

Current workflow split:

- `.github/workflows/chapel-ci.yml`
  intended canonical self-hosted Chapel CI lane; currently queued behind runner
  enrollment/scope mismatch for this repo
- `.github/workflows/chapel-dogfood.yml`
  cacheable dogfood runner lane for package/probe reproducibility; records the
  built Chapel output paths and publishes the flake surface to FlakeHub on
  `main`
- `.github/workflows/chapel-honey-evidence.yml`
  manual `honey` artifact lane; uploads evidence artifacts but does not publish
  them as repo truth automatically

If the Dell-local fallback is still building and you want the probe to follow
the preferred external compiler branch instead, use
`chapel-host-capture-live-external` or `chapel-host-capture-live-save-external`.

If the local Darwin/Linux control machine is still the bottleneck, use
`chapel-host-capture-live-on-target` or
`chapel-host-capture-live-save-on-target`. That path stages only `flake.nix`,
`nix/`, and `analysis/` on the target host, builds the repo-local Chapel
capture package there, and runs `HostNumaProbe` directly on the target without
waiting on repo-local `mason` or `chplcheck` packaging. It is useful for host
truth, but it should not become the only build path for repeatable compiler
validation.

For timing characterization windows, prefer
`chapel-host-capture-live-store` or `chapel-host-capture-live-save-store`.
Those recipes compile the small probe on the target with an already-present
Chapel 2.8.0 store path and intentionally do not run `nix build` on the host
under test. Use the on-target build recipes for package/build proof, not for
same-boot SMI/hwlat timing packets.

If you are already on a Linux host that should act as the machine under test,
use `chapel-host-capture-local` or `chapel-host-capture-local-save`. That is
the path used by the manual `honey` GitHub Actions evidence lane.

Current operator note:

- the Dell host-characterization lane is single-locale today
- do not pass `-nl ...` to `HostNumaProbe` on the current `CHPL_COMM=none`
  build posture
- `CHPL_LOCALE_MODEL=flat` means Chapel does not further subdivide the locale,
  so `Sublocales: 0` is expected on the current generic-lane capture surface

The shorter `chapel-*` recipe names are kept as compatibility aliases while the
Dell repo stops advertising the same canonical analysis entry points as
`XoxdWM`.

## Preferred compiler source

The desired long-term compiler source is the dedicated Chapel flake rather than
the local fallback package in this repo.

Today the split is:

- preferred external source for cacheable compiler experiments:
  committed sibling Chapel packaging branch, typically
  `git+file://$PWD/../chapel?ref=chapel-dell-7810-packaging&shallow=1#chapel-llvm19`
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
[`docs/platform/chapel-sourcing.md`](../docs/platform/chapel-sourcing.md).

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

- `export DELL_7810_TARGET=user@host`
- `just chapel-host-capture-live tag=baseline`
- `just chapel-host-capture-live-save tag=baseline`
- `just chapel-host-capture-live-external tag=baseline`
- `just chapel-host-capture-live-save-external tag=baseline`
- `just chapel-host-capture-live-on-target tag=baseline`
- `just chapel-host-capture-live-save-on-target tag=baseline`
- [`../docs/platform/chapel-live-host-result-template.md`](../docs/platform/chapel-live-host-result-template.md)

The intended order is:

1. compile and run the canonical host probe on `honey`
2. capture the host context and probe output
3. write a Dell-owned result note using the template above
4. only then update broader Dell or `XoxdWM` summary claims

Current live result:

- generic-lane live capture now exists at
  [`../data/captures/honey/chapel-host-probe-baseline.txt`](../data/captures/honey/chapel-host-probe-baseline.txt)
- Dell-owned result note:
  [`../docs/platform/honey-chapel-live-result-2026-04-23.md`](../docs/platform/honey-chapel-live-result-2026-04-23.md)

Use [`../docs/platform/rt-research-contract.md`](../docs/platform/rt-research-contract.md)
to keep the claim boundary honest: this live probe can characterize the host
lane and help set up a future C4 argument, but it does not by itself prove a
downstream RT software benefit.

## Current dependency posture

- Chapel version: `2.8.0`
- property-test library: `quickchpl@1.0.2`

Current proof surfaces include:

- partition coverage and exactness for NUMA-aligned channel splits
- deterministic synthetic fixtures for repeatable host experiments
- timing-budget conformance checks over interval streams
- jitter summaries that can back reset, latency, and RT validation notes

As of April 22, 2026, `2.8.0` is the latest verified Chapel release from the official Chapel project release surfaces.
