# Declarative Host Contract

This directory is the start of a narrow declarative surface for Dell-7810 host
facts and evidence.

It exists to formalize the host contract without copying `XoxdWM`'s whole boot
pipeline into this repo.

## Scope

Use these Dhall types for:

- stable workstation identity facts,
- kernel and timing posture summaries,
- BIOS records,
- host inventory records,
- kernel validation records,
- and evidence references.

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
- host inventory records
- kernel validation records
- projector helpers that emit Dhall records from saved capture artifacts

## Current files

- `types/HostIdentity.dhall`
- `types/KernelTimingPosture.dhall`
- `types/EvidenceRef.dhall`
- `types/BiosRecord.dhall`
- `types/HostInventoryRecord.dhall`
- `types/KernelValidationRun.dhall`
- `defaults/honey-bios-record-template.dhall`
- `defaults/honey-bios-record-2026-04-22.dhall`
- `defaults/honey-host-inventory-template.dhall`
- `defaults/honey-host-inventory-2026-04-22.dhall`
- `defaults/honey-rt-validation-first-2026-04-23.dhall`
- `defaults/honey-rt-validation-second-2026-04-23.dhall`

## Relationship to XoxdWM

The intended pattern is:

- `XoxdWM/packaging/dhall/Platform.dhall` and related files remain the
  operational boot-generation layer,
- this repo owns the host evidence and the narrower host-contract schema,
- any future shared constants should be extracted intentionally, not by copying
  full boot or storage definitions into this repo.

## Projection helpers

Use these scripts to turn saved host captures into Dhall records instead of
hand-writing the structural fields each time:

- `scripts/platform/project-host-inventory-dhall`
- `scripts/platform/project-kernel-validation-dhall`
