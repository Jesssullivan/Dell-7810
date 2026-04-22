# Declarative Host Contract

This note defines how to use Dhall and other declarative patterns across
`Dell-7810`, `XoxdWM`, and the sibling `chapel` repo without blurring the
boundary again.

## Short rule

Formalize shared host facts and host evidence shapes.

Do not move whole operational pipelines just because they already happen to be
written in Dhall.

## Why this matters

The current split is lopsided:

- `XoxdWM` already has strong Dhall around boot generations and platform-aware
  boot rendering,
- `Dell-7810` already has stronger host evidence and workstation-specific
  notes,
- but the shared host contract between those worlds was mostly implicit.

That is exactly how rushed content migration turns into fuzzy authority.

## What should be declarative

These are the right targets for shared formal structure:

### 1. Stable host identity and platform facts

Examples:

- hostname
- vendor / model / board ID
- BIOS identity
- CPU socket and NUMA posture summary
- connector roles

Reason:

- these facts are reused by evidence, packaging, and writing,
- but they are not themselves boot-entry generation logic.

### 2. Host timing posture

Examples:

- generic low-latency kernel lane
- expected SMI-mitigation cmdline constants
- tuned profile name
- whether RT is expected

Reason:

- `XoxdWM` should not keep re-explaining Dell timing posture inline in each
  boot generation,
- this repo should own the host-facing posture summary,
- a shared declarative surface can let operational code consume the same facts.

### 3. Evidence record shapes

Examples:

- reset-run records
- power-path inventory shape
- BIOS settings record shape
- host inventory capture shape

Reason:

- publication, platform work, and operational validation all benefit from
  stable record shapes,
- and these can be formal without carrying live UUIDs or deployment state.

### 4. Display-role declarations

Examples:

- which path is management,
- which path is XR,
- which path must be preserved during recovery.

Reason:

- this is a host design invariant, not a compositor deployment detail.

## What should stay operational

These should not be moved here wholesale:

### 1. Boot-entry generation

Keep in `XoxdWM`:

- `packaging/dhall/defaults/honey-*.dhall`
- `packaging/dhall/generate-boot.dhall`
- `packaging/dhall/types/BootGeneration.dhall`
- `packaging/scripts/boot-apply`

Why:

- they encode live storage topology, kernel package versions, BLS layout, and
  deployment assumptions.

### 2. Storage migration and boot topology ops

Keep in `XoxdWM` unless a dedicated host-ops home is created:

- `packaging/scripts/honey-storage-migrate`
- storage-layout and boot-entry operational definitions

Why:

- these are real host ops, but they are not the same thing as workstation
  hardware evidence.

### 3. XR deployment logic

Keep in `XoxdWM`:

- XR-specific kernel overlays
- compositor packaging
- runtime and headset deployment logic

Why:

- these are product/runtime surfaces, not generic host contract surfaces.

## New local schema surface

This repo now carries a narrow declarative host-contract lane in [`dhall/`](../../dhall/README.md):

- [`dhall/types/HostContract.dhall`](../../dhall/types/HostContract.dhall)
- [`dhall/types/HostIdentity.dhall`](../../dhall/types/HostIdentity.dhall)
- [`dhall/types/KernelTimingPosture.dhall`](../../dhall/types/KernelTimingPosture.dhall)
- [`dhall/types/DisplayPath.dhall`](../../dhall/types/DisplayPath.dhall)
- [`dhall/types/PowerContract.dhall`](../../dhall/types/PowerContract.dhall)
- [`dhall/types/ResetRun.dhall`](../../dhall/types/ResetRun.dhall)
- [`dhall/types/EvidenceRef.dhall`](../../dhall/types/EvidenceRef.dhall)
- [`dhall/types/BiosRecord.dhall`](../../dhall/types/BiosRecord.dhall)
- [`dhall/types/PowerPathInventory.dhall`](../../dhall/types/PowerPathInventory.dhall)
- [`dhall/types/HostInventoryRecord.dhall`](../../dhall/types/HostInventoryRecord.dhall)
- [`dhall/defaults/honey-host-contract-template.dhall`](../../dhall/defaults/honey-host-contract-template.dhall)
- [`dhall/defaults/honey-bios-record-template.dhall`](../../dhall/defaults/honey-bios-record-template.dhall)
- [`dhall/defaults/honey-power-path-inventory-template.dhall`](../../dhall/defaults/honey-power-path-inventory-template.dhall)
- [`dhall/defaults/honey-host-inventory-template.dhall`](../../dhall/defaults/honey-host-inventory-template.dhall)
- [`dhall/defaults/honey-reset-run-template.dhall`](../../dhall/defaults/honey-reset-run-template.dhall)
- [`dhall/defaults/honey-reset-run-b-2026-04-22.dhall`](../../dhall/defaults/honey-reset-run-b-2026-04-22.dhall)
- [`dhall/defaults/honey-reset-run-c-2026-04-22.dhall`](../../dhall/defaults/honey-reset-run-c-2026-04-22.dhall)

This is intentionally narrower than the `XoxdWM` Dhall lane.

It summarizes:

- the host subject,
- the timing posture,
- display roles,
- power-contract status,
- recent reset evidence,
- and explicit unknowns.

It does not try to render a bootloader entry.

It also now provides machine-readable companions to the existing human
templates for:

- BIOS posture capture,
- power-path inventory,
- host inventory,
- and reset-run evidence.

The current practical bridge from live host state into those records is JSON
capture:

- `scripts/platform/capture-reset-state --json`
- `scripts/platform/capture-numa-state --json`
- `just platform-save-reset-state-json tag=<label>`
- `just platform-save-numa-state-json tag=<label>`

Those captures are not Dhall themselves. They are the machine-readable evidence
artifacts that the Dhall records can point at or be projected from later.

The next bridge now exists too:

- `scripts/platform/project-host-inventory-dhall`
- `scripts/platform/project-reset-run-dhall`
- `just platform-project-host-inventory-dhall <capture.json>`
- `just platform-project-reset-run-dhall <capture.json> <run-id> <trigger> <outcome> <ac-power-broken>`

Those projection helpers emit Dhall record files seeded from saved JSON
captures. They do not remove the need for operator review, but they do cut down
the amount of manual re-entry.

## Current implementation status

As of April 22, 2026, the first operational extraction step has landed in
`XoxdWM`:

- `packaging/dhall/HostFacts.dhall`
- `packaging/dhall/HostTiming.dhall`
- `Platform.dhall` now consumes `HostFacts.dhall`
- `BootParams.dhall` now consumes `HostTiming.dhall`
- `defaults/honey-xr.dhall` now consumes `BootParams.dhall` instead of
  hardcoding the Dell timing posture inline

That is the right intermediate state:

- `XoxdWM` keeps its operational boot-generation pipeline,
- Dell timing and host facts are no longer handwritten inside
  `honey-xr.dhall`,
- and the extraction target is now a smaller host-contract surface rather than
  a full-file migration.

## Mapping from XoxdWM Dhall to this contract

Use this mapping when deciding what to extract or reference:

| XoxdWM surface | Keep / extract | Reason |
| --- | --- | --- |
| `Platform.dhall` host facts | extract selected stable fields | hardware identity is reusable beyond boot generation |
| `BootParams.dhall` SMI and timing constants | extract selected host-safe constants | host timing posture should not be duplicated inline |
| `KernelConfig.dhall` host-safe config fragments | reference or extract host-safe subset | generic host baseline belongs under Dell authority |
| `defaults/honey-stock.dhall` | keep | contains live storage and boot topology |
| `defaults/honey-debug.dhall` | keep | deployment/debug boot posture |
| `defaults/honey-xr.dhall` | keep, but consume shared host constants | XR boot entry still belongs to XR/deployment lane |
| `generate-boot.dhall` | keep | operational rendering pipeline |

## Immediate next extraction targets

These are the sensible follow-on moves:

1. Decide whether the new `XoxdWM` `HostTiming.dhall` surface should stay as an
   internal operational projection or graduate into a truly shared home.
2. Decide whether the new `XoxdWM` `HostFacts.dhall` surface should stay as an
   internal operational projection or graduate into a truly shared home.
3. Keep using Dell-7810 templates and evidence notes as the human-facing source,
   then add machine-readable projections only where they pay off.
4. If more than two repos start consuming the same host-contract schema, move
   that schema into a dedicated shared home rather than treating either repo as
   the permanent neutral center.

## Practical rule for future edits

Before adding a new declarative surface, ask:

1. Is this a stable host fact or evidence shape?
2. Will more than one repo consume it?
3. Does it avoid carrying live deployment state?

If all three are yes, formalize it.

If the file mostly exists to boot, install, migrate, or deploy `honey`, keep it
out of this repo unless an explicit host-ops extraction is happening.
