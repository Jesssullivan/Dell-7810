# Dell 7810 Platform Workstream

This directory is the home for Dell-7810-specific host behavior that should not live in `XoxdWM`.

For paper and presentation framing on top of that operational split, also use
[`../publication/README.md`](../publication/README.md).

For the current "measured versus scaffolded" state across the Dell and
`XoxdWM` lanes, also use
[`../tracking/measured-evidence-map.md`](../tracking/measured-evidence-map.md).

For the current cross-repo contract surfaces themselves, also use
[`xoxdwm-symbiosis-touchpoints.md`](xoxdwm-symbiosis-touchpoints.md).

## Scope

This repo owns:

- enclosure, cable, and PSU mechanical design,
- workstation power and reset behavior,
- Dell 7810 BIOS, SMI, and recovery-path characterization,
- low-latency host validation that depends on T7810 hardware specifics,
- minimal NUMA and Chapel probes used to characterize the dual-socket host.

`XoxdWM` should keep:

- compositor, OpenXR, Monado, and XR application logic,
- software-facing benchmark results,
- packaging and release logic that is not specific to the Dell 7810 platform,
- XR-specific kernel patches that are really display-stack or compositor prerequisites.

## Why extract from XoxdWM

`XoxdWM` currently carries a mixed bag of host-specific material:

- Dell T7810 BIOS and SMI validation scripts,
- a T7810-oriented low-latency tuned profile,
- a Chapel package and NUMA demo,
- T7810 SMI baseline notes,
- XR-kernel config that mixes real platform concerns with Beyond/AMD display patches.

That makes the ownership boundary fuzzy. The workstation platform is now a first-class engineering lane in this repo, especially after the April 22 `honey` reset work and power research.

## What has been pulled into this repo

- `scripts/platform/smi-validate`
- `scripts/platform/dcc-configure-rt`
- `scripts/platform/capture-reset-state`
- `packaging/tuned/t7810-low-latency/`
- `analysis/`
- `nix/packages/chapel.nix` as a temporary local fallback
- `dhall/` as a narrow host-contract schema lane, not a boot-generation lane

These are the pieces that are clearly workstation-platform scaffolding rather than compositor product logic.

## What should stay in XoxdWM for now

- Bigscreen Beyond and AMD DSC patch carrying.
- compositor-specific real-time policy and user-service integration.
- full BCI batch-analysis pipeline modules that depend on XoxdWM's software architecture.
- app-facing support matrices and named-host software claims.

## Upgrade plan

- Split the generic Dell-7810 RT kernel posture from the XR-specific patch stack.
- Reproduce the March SMI baseline in this repo, then record the post-A34 and post-tuning deltas here.
- Add reset-run templates and issue-linked evidence capture for the missing rows in `honey-reset-matrix-2026-04-22.md`.
- Formalize the current proprietary-Dell plus external-ATX power path as a measured wiring and control contract.
- Keep Chapel here as a host-characterization tool, not as an excuse to move application analysis code prematurely.
- Move compiler ownership toward the dedicated Chapel flake rather than growing a permanent compiler package in this repo.

## Immediate next records to fill

- Promote the first machine-checked T7810 BIOS settings record from the April 22
  legacy-DCC capture into a stable follow-on baseline after any BIOS changes.
- A power-path inventory with actual harness, rail, and start-signal notes.
- The matching PREEMPT_RT SMI/hwlat and Chapel packet after the operator is
  ready for a one-time RT boot and generic fallback verification.
- A decision on whether remaining SMI activity should be handled as BIOS-side
  candidate testing or accepted as host-posture context for the current kernel
  lane.

## Current supporting docs

- [`bios-settings-record-template.md`](bios-settings-record-template.md)
- [`bios-flash-procedure.md`](bios-flash-procedure.md)
- [`authority-map.md`](authority-map.md)
- [`declarative-host-contract.md`](declarative-host-contract.md)
- [`duplication-status.md`](duplication-status.md)
- [`host-inventory-template.md`](host-inventory-template.md)
- [`host-kernel-baseline.md`](host-kernel-baseline.md)
- [`honey-bios-cstates-and-linux-xr-runbook-2026-04-22.md`](honey-bios-cstates-and-linux-xr-runbook-2026-04-22.md)
- [`honey-kernel-posture-cross-repo-audit-2026-04-22.md`](honey-kernel-posture-cross-repo-audit-2026-04-22.md)
- [`honey-live-baseline-2026-04-22.md`](honey-live-baseline-2026-04-22.md)
- [`honey-generic-smi-hwlat-series-2026-04-25.md`](honey-generic-smi-hwlat-series-2026-04-25.md)
- [`honey-generic-chapel-repeat-series-2026-04-25.md`](honey-generic-chapel-repeat-series-2026-04-25.md)
- [`honey-generic-host-characterization-window-2026-04-26.md`](honey-generic-host-characterization-window-2026-04-26.md)
- [`honey-rt-smi-hwlat-chapel-series-2026-04-25.md`](honey-rt-smi-hwlat-chapel-series-2026-04-25.md)
- [`honey-rt-validation-2026-04-23.md`](honey-rt-validation-2026-04-23.md)
- [`honey-smi-numa-rt-evening-runbook-2026-04-25.md`](honey-smi-numa-rt-evening-runbook-2026-04-25.md)
- [`rt-research-contract.md`](rt-research-contract.md)
- [`kernel-lane.md`](kernel-lane.md)
- [`linux-xr-install-and-rollback.md`](linux-xr-install-and-rollback.md)
- [`t7810-rt-boot-troubleshooting.md`](t7810-rt-boot-troubleshooting.md)
- [`chapel-sourcing.md`](chapel-sourcing.md)
- [`numa-and-chapel.md`](numa-and-chapel.md)
- [`power-path-inventory-template.md`](power-path-inventory-template.md)
- [`reset-run-template.md`](reset-run-template.md)
- [`rt-research-contract.md`](rt-research-contract.md)
- [`t7810-smi-baseline.md`](t7810-smi-baseline.md)
- [`xoxdwm-boundary-audit.md`](xoxdwm-boundary-audit.md)
- [`xoxdwm-symbiosis-touchpoints.md`](xoxdwm-symbiosis-touchpoints.md)

## Related schema lane

- [`../../dhall/README.md`](../../dhall/README.md)
- machine-readable templates now exist there for BIOS, power-path, host-inventory,
  and reset-run records
- live capture scripts now also support JSON output for reset and NUMA state

## Current supporting scripts

- `scripts/platform/validate-host-kernel-baseline`
- `scripts/platform/capture-numa-state`
- `scripts/platform/capture-reset-state`
- `scripts/platform/project-host-inventory-dhall`
- `scripts/platform/project-chapel-host-probe-dhall`
- `scripts/platform/capture-chapel-host-probe-local`
- `scripts/platform/capture-chapel-host-probe-series-store-on-target`
- `scripts/platform/project-kernel-validation-dhall`
- `scripts/platform/capture-kernel-runtime-local`
- `scripts/platform/capture-kernel-lane-status-local`
- `scripts/platform/project-reset-run-dhall`
- `scripts/platform/runner-enrollment-status`
- `scripts/platform/smi-validate`
- `scripts/platform/dcc-configure-rt`
- `scripts/platform/remote-bios-control`
- `scripts/platform/remote-kernel-control`
- `scripts/platform/remote-tuned-control`
- `scripts/platform/stage-legacy-dcc-7810`
- `scripts/platform/validate-host-kernel-baseline-remote`

## Current workflow lanes

- `.github/workflows/chapel-ci.yml`
  canonical shared-runner Chapel CI lane for cacheable analysis and package
  validation
- `.github/workflows/chapel-dogfood.yml`
  shared-runner Chapel/package reproducibility plus publish/probe-specific
  follow-through on the same CI helper
- `.github/workflows/chapel-honey-evidence.yml`
  manual `honey` Chapel artifact lane
- `.github/workflows/kernel-dogfood.yml`
  cacheable runner lane for Dell-owned kernel-validation tooling and seeded RT
  record reprojection
- `.github/workflows/kernel-honey-evidence.yml`
  manual `honey` kernel artifact lane
