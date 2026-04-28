# PR 14 Split Plan

Date: 2026-04-25

Scope: draft PR `#14`, branch `jess/tin-339-capture-honey-reset-matrix`,
stacked on PR `#13`.

## Why split

PR `#14` is useful as a stack head, but it is not a good merge unit. Against
the PR `#13` base it currently spans about 193 files across platform evidence,
measurement scaffolding, generated print artifacts, Chapel/NUMA code,
kernel/RT packaging, Dhall records, cross-repo boundary docs, and runner
hygiene.

The right next step is not to keep expanding the draft. The right next step is
to preserve this branch as an integration reference and promote smaller
issue-shaped branches from it.

## Non-negotiable boundaries

- Do not add Dell-specific runner labels or Dell repo-scoped runner sets.
- Keep cacheable runner workflows manual-only until `Dell-7810` can reach a
  compliant shared `tinyland-nix` scope.
- Keep direct `honey` captures separate from cacheable CI proof.
- Keep generated STL output out of platform/runner slices unless the target
  slice is explicitly the Session 01 printable package.
- Keep XoxdWM software proof authority outside this repo; Dell owns host,
  reset, BIOS, SMI, NUMA, and enclosure evidence.

## Proposed slices

| Slice | Tracker | Purpose | Primary file families |
| --- | --- | --- | --- |
| A. Reset evidence base | `TIN-339` | Merge the original reset/power/recovery evidence | `docs/research/honey-reset-matrix-*`, reset captures, reset Dhall records, reset helper scripts |
| B. Platform baseline and RT contract | `TIN-397` / `TIN-398` | Merge Dell-owned BIOS, SMI, kernel, RT, and Linux-XR authority surfaces | `docs/platform/*kernel*`, `docs/platform/*bios*`, `docs/platform/*rt*`, `packaging/kernel`, `packaging/tuned`, kernel validation captures/scripts |
| C. Chapel/NUMA formal lane | `TIN-470` | Merge Chapel package/probe code, generic live result, Dhall projection, and publication framing | `analysis/`, `nix/packages/chapel.nix`, Chapel captures, `dhall/types/ChapelHostProbeRun.dhall`, `docs/platform/chapel-*`, `docs/publication/rt-numa-*` |
| D. Measurement and fan scaffolding | `TIN-468` / `TIN-469` | Merge bench packets, fan support matrix, and Session 01 capture scaffolding | `docs/measurements/`, `data/measurements/`, `scripts/measurements/`, `cad/openscad/*fit*` |
| E. Generated Session 01 print package | `TIN-469` | Merge generated printable placeholder STL artifacts only when desired | `output/stl/*coupon_placeholder.stl` |
| F. XoxdWM/Dell authority boundary | cross-repo hygiene | Merge repo-boundary docs and derived-fork provenance records | `docs/platform/authority-map.md`, `docs/platform/xoxdwm-*`, `docs/platform/duplication-status.md`, cross-repo plan notes |
| G. Runner/cache boundary hygiene | `TIN-550` | Merge manual-only workflow guards and runner reachability tracking | `.github/workflows/*dogfood*`, `.github/workflows/chapel-ci.yml`, `scripts/platform/runner-enrollment-status`, runner tracking docs |
| H. Repo shell/dev environment | support | Merge shared devshell/justfile wiring only with the slices that need it | `.envrc`, `flake.nix`, `flake.lock`, `justfile`, `dhall/README.md` |

## Recommended order

1. Merge or split `TIN-339` reset evidence first. It is the historical root of
   the current branch and gives the later platform evidence something to cite.
2. Split `TIN-550` runner hygiene next. It stops CI noise and is mostly
   orthogonal to host evidence.
3. Split platform baseline/RT contract. This is the strongest Dell-owned
   authority lane and should not depend on enclosure print artifacts.
4. Split Chapel/NUMA formal lane. It depends conceptually on the platform
   baseline, but not on Session 01 physical measurements.
5. Split measurement/fan scaffolding before generated STL output. The CSV/docs
   scaffolding is reviewable; the generated files should be an explicit choice.
6. Split generated STL output last, or regenerate it from a smaller
   measurement branch and keep it out of the broad platform stack.

## Current validation posture

- Workflow YAML parses locally.
- `git diff --check` passes.
- `just platform-runner-enrollment-status --no-cluster` reports zero accessible
  self-hosted runners, which is the expected blocked state for `TIN-550`.
- Stale queued `tinyland-nix` runs were cancelled.
- Current cacheable workflows are manual-only and require
  `confirm_runner_reachable=true`.

## Immediate next branch candidates

The two cleanest candidates to cut first are:

- `jess/tin-550-runner-boundary-hygiene`
  Contains only workflow gating, runner diagnostic, and runner-tracking docs.
- `jess/tin-397-platform-rt-authority`
  Contains kernel/RT/BIOS/SMI authority docs, captures, Dhall projection, and
  validation scripts.

Avoid starting with the generated STL slice. It is large, mechanical, and easy
to review later once the measurement branch is isolated.
