# Dell 7810 Top-Hat Project

Replacement side/top enclosure for a Dell Precision Tower 7810 that has been modified for oversized, high-power GPU use. The target part is a manufacturable third-party sheet-metal assembly that restores enclosure safety, improves dust control, preserves serviceability where practical, and supports external or elevated PSU integration plus large cable pass-through features.

This repository is intentionally measurement-first. Until the OEM interfaces and GPU/PSU clearances are captured, the CAD here should be treated as scaffolding and process structure, not final geometry.

## Project goals

- Replace the removed OEM hinged side entry with a rigid "top-hat" or tent-style enclosure.
- Create enough vertical and lateral volume for large multi-slot GPUs and their cable exits.
- Provide a mounting strategy for an elevated or external-adjacent modular PSU.
- Add a large cable pass-through feature sized for GPU power harnesses and other external peripherals.
- Reuse the OEM lower tongue/groove pattern and quick-release latch if the geometry proves repeatable and robust.
- Generate fabrication outputs for laser-cut and bent sheet parts plus 3D-printed fit-check coupons.

## Design principles

- OpenSCAD is the source of truth for parametric geometry.
- FreeCAD is a support tool for inspection, import/export, and drawing workflows, not a competing geometry source.
- Every interface that touches the Dell chassis gets validated with a printed coupon before it reaches a full metal prototype.
- Fabrication outputs are generated, not hand-edited.

## Repo layout

- `docs/epic-plan.md`: milestone plan, decision gates, and deliverables.
- `docs/architecture/`: concept selection and CAD workflow guidance.
- `docs/measurements/measurement-plan.md`: measurement workflow and datum strategy.
- `docs/measurements/measurement-log-template.md`: capture sheet for repeated measurements.
- `docs/measurements/bench-session-01.md`: ordered first measurement session.
- `docs/measurements/cad-handoff-checklist.md`: what measurements are sufficient to unlock each CAD task.
- `docs/measurements/photo-shot-list.md`: required photo record for each bench session.
- `docs/research/extant-art.md`: current external references and candidate hardware families.
- `docs/research/honey-power-reset-and-multi-psu-2026-04-22.md`: April 22 workstation power/reset findings and multi-PSU research memo for `honey`.
- `docs/research/honey-reset-matrix-2026-04-22.md`: reset-focused matrix for the failed and recovered `honey` display/GPU states.
- `docs/research/honey-management-display-and-recovery-path-2026-04-22.md`: management-display and recovery-lane recommendation for `honey`.
- `docs/tracking/linear-git-workflow.md`: active Linear issue map and branch policy for the hardware lane.
- `data/measurements/feature-register.csv`: feature-by-feature measurement register.
- `data/measurements/session-01-priority-log.csv`: pre-seeded first session capture sheet.
- `cad/openscad/`: parametric OpenSCAD source and shared configuration.
- `cad/freecad/`: FreeCAD-side notes and import/export helpers.
- `BOM.md`: provisional COTS shortlist and fabrication consumables.
- `output/`: generated fabrication assets such as DXF, STL, STEP, and PDF.
- `prototypes/fit-checks/`: notes and artifacts for 3D-printed coupons and slivers.
- `fixtures/`: measurement jigs, templates, or sacrificial helpers.

## Working model

1. Capture the chassis interface and interference envelope.
2. Print fit-check coupons for the latch, lower rail, and rear edge geometry.
3. Lock the enclosure architecture and cable/PSU strategy.
4. Generate flat patterns and bend-ready parts.
5. Build and test a metal alpha, then iterate toward a production package.

## Development shell

The repo includes a minimal `flake.nix` and `justfile` to standardize tools around OpenSCAD-first work:

```bash
nix develop
just --list
```

`openscad` is confirmed available locally. `FreeCAD` is not currently on `PATH`, so the shell treats it as optional until that is resolved.

## Immediate next step

Start with [`docs/measurements/measurement-plan.md`](docs/measurements/measurement-plan.md) and fill out [`docs/measurements/measurement-log-template.md`](docs/measurements/measurement-log-template.md) against the physical chassis before making any serious interface geometry claims.
