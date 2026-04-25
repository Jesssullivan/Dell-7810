# Linear And Git Workflow

This repo now has an active Linear-backed hardware lane for `honey` workstation power and reset work.

## Authority split

- Linear is the durable planning and issue-tracking surface.
- This repo is the durable research, measurement, and design surface.
- `XoxdWM` is not the authoritative repo for Dell 7810 workstation power architecture.

## Active project

- Linear project:
  `Dell 7810 Honey Power & Enclosure Stabilization`

## Active issue map

- `TIN-337`
  Stabilize honey warm-reboot / display-reset behavior on the Dell 7810 platform
- `TIN-338`
  Research Dell 7810 proprietary PSU, distribution-board, and multi-PSU sync options
- `TIN-339`
  Capture a reset matrix for honey across warm reboot, hard reset, and display topology changes
- `TIN-340`
  Define a management-display / out-of-band recovery path for honey independent of the XR GPU
- `TIN-550`
  Resolve Dell-7810 shared `tinyland-nix` runner and cache contract parity
  Status: `In Progress`
  GitHub mirror: `#22`
  Upstream blocker: `tinyland-inc/GloriousFlywheel#407`
  Notes:
  Dell-7810 must reach the shared runner substrate through a compliant
  org/enterprise or enterprise-equivalent shared scope, or stay explicitly
  blocked. Dell-specific runner labels and repo-scoped runner scale sets are
  not acceptable fixes.

## Git integration policy

- Branches for this lane should use Linear issue-linked branch names.
- Research docs, bench logs, and CAD notes should mention the owning `TIN-###` issue where practical.
- Repo changes should stay small and issue-shaped instead of mixing enclosure work, measurement work, and workstation platform debugging in one branch.

## Current branch

- `jess/tin-338-research-dell-7810-proprietary-psu-distribution-board-and`

This split branch owns only the `TIN-550` runner-boundary hygiene surface:
manual-only cacheable workflows, the repeatable runner-enrollment diagnostic,
and tracking docs for the personal-account owner-boundary blocker.
