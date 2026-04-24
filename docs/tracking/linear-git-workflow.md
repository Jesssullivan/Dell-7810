# Linear And Git Workflow

This repo now has an active Linear-backed hardware lane for `honey` workstation power and reset work.

## Authority split

- Linear is the durable planning and issue-tracking surface.
- This repo is the durable research, measurement, and design surface.
- `XoxdWM` is not the authoritative repo for Dell 7810 workstation power architecture.
- GitHub issue mirrors in this workflow are manual mirror surfaces, not an
  automatic bidirectional sync. Create and link both sides explicitly.

## Active project

- Linear project:
  `Dell 7810 Honey Power & Enclosure Stabilization`
- Team:
  `Tinyland (TIN)`
- Project status:
  `Planned`
- Project priority:
  `High`

## Active issue map

- `TIN-337`
  Stabilize honey warm-reboot / display-reset behavior on the Dell 7810 platform
  Status: `Backlog`
- `TIN-338`
  Research Dell 7810 proprietary PSU, distribution-board, and multi-PSU sync options
  Status: `In Progress`
- `TIN-339`
  Capture a reset matrix for honey across warm reboot, hard reset, and display topology changes
  Status: `In Progress`
- `TIN-340`
  Define a management-display / out-of-band recovery path for honey independent of the XR GPU
  Status: `In Progress`

## Newly filed follow-on issues

- `TIN-396`
  Survey Dell 7810 fan families, stock control paths, and aftermarket PWM
  adaptation options
  Status: `Backlog`
  GitHub mirror: `#16`
  Natural split once bench work starts:
  stock fan inventory first, aftermarket validation second
- `TIN-468`
  Create Dell 7810 fan support matrix and lightweight acoustic validation lane
  Status: `Backlog`
  GitHub mirror: `#19`
  Notes:
  support-matrix-first lane for the ordered Noctua candidates and any optional
  REW / mic follow-on
- `TIN-469`
  Execute Session 01 and produce first evidence-backed printable revision
  Status: `Backlog`
  GitHub mirror: `#20`
- `TIN-470`
  Close Dell Chapel lane with first live `honey` probe results and compiler-source decision
  Status: `Backlog`
  GitHub mirror: `#21`
- `TIN-397`
  Consolidate Dell 7810 BIOS A34, C-state posture, and `linux-xr` rollout flow
  into Dell-7810 authority docs
  Status: `Backlog`
  GitHub mirror: `#17`
- `TIN-398`
  Reconcile live `honey` kernel posture claims across Dell-7810, `linux-xr-fast`,
  and `XoxdWM`
  Status: `Backlog`
  GitHub mirror: `#18`

## Cross-repo dependent issue

- `TIN-346`
  Produce the first evidence-backed `XoxdWM` VR smoke path on `honey`
  Status: `Todo`

This is an `XoxdWM` project issue, not a Dell-7810 authority surface. It should
consume host evidence from this repo rather than replace it.

GitHub mirrors now exist for `TIN-396`, `TIN-397`, `TIN-398`, `TIN-468`,
`TIN-469`, and `TIN-470`, but they are mirror surfaces only. Linear remains
the durable planning authority for this repo.

## Tracking gaps

Linear is now aligned with the current known repo lanes:

- `TIN-396` now owns the fan and aftermarket-airflow authority lane.
- the first useful execution split under `TIN-396` is:
  stock fan inventory and connector mapping before aftermarket Noctua/PWM claims
- `TIN-468` now owns the support-matrix and optional acoustic-validation
  follow-on for actual candidate testing.
- `TIN-469` now owns the first evidence-backed enclosure execution lane.
- `TIN-470` now owns the Dell-side Chapel live-results and compiler-closure lane.
- `TIN-397` now owns the BIOS A34 / C-state / `linux-xr` flow consolidation lane.
- `TIN-398` now owns the cross-repo kernel / RT truth-audit lane so installed
  RT artifacts stop being conflated with an active RT or validated low-latency
  host posture.

The remaining planning weakness is not missing issue coverage. It is branch
shape: the current branch still spans several issue lanes.

## Git integration policy

- Branches for this lane should use Linear issue-linked branch names.
- Research docs, bench logs, and CAD notes should mention the owning `TIN-###` issue where practical.
- Repo changes should stay small and issue-shaped instead of mixing enclosure work, measurement work, and workstation platform debugging in one branch.

## Current branch

- `jess/tin-339-capture-honey-reset-matrix`

This branch is aligned with the reset-matrix lane, but the working tree currently
contains broader cross-cutting work spanning platform docs, declarative host
contracts, Chapel analysis, measurement scaffolding, fan-lane setup, and the
first Dell move toward the shared GloriousFlywheel `tinyland-nix`
capability-class contract. The checked-in CI path now targets that shared lane,
but `Dell-7810` cannot yet truthfully reach it and live GitHub inventory still
shows zero accessible self-hosted runners for this repo, so that path is not
live for this repo today. Future branch cuts should prefer `TIN-468`, `TIN-469`, or
`TIN-470` once active work moves out of the current reset-focused lane.
