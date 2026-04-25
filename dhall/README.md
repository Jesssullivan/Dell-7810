# Declarative Host Contract

This directory is the start of a narrow declarative surface for Dell-7810 host
facts and evidence.

It exists to formalize the host contract without copying `XoxdWM`'s whole boot
pipeline into this repo.

## Scope

Use these Dhall types for:

- stable workstation identity facts,
- kernel and timing posture summaries,
- display-role and recovery-role declarations,
- power-path contract summaries,
- reset-run records and evidence references.

Do not use this directory for:

- BLS entry generation,
- `/etc/fstab` rendering,
- storage migration plans,
- deployment-specific kernel package selection,
- XR runtime or compositor deployment logic.

Those remain operational surfaces in `XoxdWM`.

## Why this exists

Right now the two repos have an awkward split:

- `XoxdWM` already has real Dhall for boot generation and platform constants,
- `Dell-7810` has the measurement, reset, BIOS, NUMA, and power evidence,
- but there is no small formal layer that says what the host contract is
  without dragging in boot UUIDs and deployment plumbing.

This directory is that missing middle layer.

It now also carries machine-readable record templates for the human-facing Dell
platform workflows:

- BIOS settings records
- power-path inventory records
- host inventory records
- reset-run records
- kernel validation records
- projector helpers that emit Dhall records from saved capture artifacts

## Current files

- `types/HostIdentity.dhall`
- `types/KernelTimingPosture.dhall`
- `types/DisplayPath.dhall`
- `types/PowerContract.dhall`
- `types/EvidenceRef.dhall`
- `types/ResetRun.dhall`
- `types/BiosRecord.dhall`
- `types/PowerPathInventory.dhall`
- `types/HostInventoryRecord.dhall`
- `types/KernelValidationRun.dhall`
- `types/ChapelHostProbeRun.dhall`
- `types/HostContract.dhall`
- `defaults/honey-host-contract-template.dhall`
- `defaults/honey-bios-record-template.dhall`
- `defaults/honey-power-path-inventory-template.dhall`
- `defaults/honey-host-inventory-template.dhall`
- `defaults/honey-reset-run-template.dhall`
- `defaults/honey-reset-run-b-2026-04-22.dhall`
- `defaults/honey-reset-run-c-2026-04-22.dhall`
- `defaults/honey-rt-validation-first-2026-04-23.dhall`
- `defaults/honey-rt-validation-second-2026-04-23.dhall`
- `defaults/honey-chapel-host-probe-baseline-2026-04-23.dhall`
- `defaults/honey-chapel-host-probe-generic-2026-04-25.dhall`
- `defaults/honey-chapel-host-probe-rt-2026-04-25.dhall`

## Relationship to XoxdWM

The intended pattern is:

- `XoxdWM/packaging/dhall/Platform.dhall` and related files remain the
  operational boot-generation layer,
- this repo owns the host evidence and the narrower host-contract schema,
- any future shared constants should be extracted intentionally, not by copying
  full boot or storage definitions into this repo.

Use [`../docs/platform/declarative-host-contract.md`](../docs/platform/declarative-host-contract.md)
for the authority and migration rules behind that split.

## Projection helpers

Use these scripts to turn saved host captures into Dhall records instead of
hand-writing the structural fields each time:

- `scripts/platform/project-host-inventory-dhall`
- `scripts/platform/project-reset-run-dhall`
- `scripts/platform/project-kernel-validation-dhall`
- `scripts/platform/project-chapel-host-probe-dhall`
