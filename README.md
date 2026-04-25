# Dell 7810 Top-Hat Project

Replacement side/top enclosure for a Dell Precision Tower 7810 that has been modified for oversized, high-power GPU use. The target part is a manufacturable third-party sheet-metal assembly that restores enclosure safety, improves dust control, preserves serviceability where practical, and supports external or elevated PSU integration plus large cable pass-through features.

This repository is intentionally measurement-first. Until the OEM interfaces and GPU/PSU clearances are captured, the CAD here should be treated as scaffolding and process structure, not final geometry.

The repo now also carries the host-specific `honey` platform lane where Dell 7810 power/reset behavior, low-latency validation, and enclosure decisions overlap. The boundary is: workstation-specific hardware behavior belongs here, while compositor and XR application validation stay in `XoxdWM`.

Cacheable Chapel and kernel CI are being converged onto the shared
GloriousFlywheel `tinyland-nix` capability-class contract. `Dell-7810` cannot
yet truthfully reach that shared lane, so the cacheable CI path is not live for
this repo today. Live GitHub inventory currently shows zero accessible
self-hosted runners for this repo. Direct `honey` evidence remains a separate
host-truth lane, not the normal CI authority surface.

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

## Active parallel workstreams

- Case work: capture the OEM interfaces, GPU envelope, cable bundle, and installation path well enough to replace placeholder coupons with real fit-check artifacts.
- Platform work: capture `honey` power/reset behavior, establish a repeatable reset matrix, and bring Dell-7810-specific RT/NUMA validation tooling into this repo.

## Related repositories

This repo focuses on Dell 7810 platform characterization, enclosure design,
power/reset behavior, and host validation. XR/VR compositor and application
work using this platform lives in
[`Jesssullivan/XoxdWM`](https://github.com/Jesssullivan/XoxdWM).

For the explicit ownership boundary between repos, see
[`docs/platform/xoxdwm-boundary-audit.md`](docs/platform/xoxdwm-boundary-audit.md)
and [`docs/platform/authority-map.md`](docs/platform/authority-map.md). For the
new declarative host-contract lane, see
[`docs/platform/declarative-host-contract.md`](docs/platform/declarative-host-contract.md).
For the current "measured versus scaffolded" state, see
[`docs/tracking/measured-evidence-map.md`](docs/tracking/measured-evidence-map.md).

## Repo layout

- `docs/epic-plan.md`: milestone plan, decision gates, and deliverables.
- `docs/architecture/`: concept selection and CAD workflow guidance.
- `docs/platform/`: Dell 7810 host-platform scope, extraction plan, and RT/NUMA lane notes.
- `docs/platform/honey-bios-cstates-and-linux-xr-runbook-2026-04-22.md`: current Dell-owned BIOS A34, C-state, and `linux-xr` run order for `honey`.
- `docs/platform/honey-kernel-posture-cross-repo-audit-2026-04-22.md`: cross-repo audit separating installed RT artifacts, active RT boot, and validated low-latency host posture.
- `docs/platform/chapel-live-host-result-template.md`: template for the first Dell-owned live Chapel host result under `TIN-470`.
- `docs/publication/`: paper and presentation framing notes plus claim boundaries.
- `docs/measurements/measurement-plan.md`: measurement workflow and datum strategy.
- `docs/measurements/measurement-log-template.md`: capture sheet for repeated measurements.
- `docs/measurements/bench-session-01.md`: ordered first measurement session.
- `docs/measurements/honey-bench-packet.md`: combined bench-day packet for Session 01 plus stock fan inventory capture on `honey`.
- `docs/measurements/session-01-execution-packet.md`: short bench packet for `TIN-469`.
- `docs/measurements/session-01-result-template.md`: short result-note template for the first evidence-backed Session 01 pass.
- `docs/measurements/printable-coupon-matrix.md`: Session 01 feature-to-parameter-to-coupon map.
- `docs/measurements/t7810-fan-support-matrix.md`: candidate replacement support matrix for stock and aftermarket fan validation.
- `docs/measurements/t7810-fan-noise-study-lite.md`: optional lightweight REW / mic method for fan noise comparison after support gates pass.
- `docs/measurements/cad-handoff-checklist.md`: what measurements are sufficient to unlock each CAD task.
- `docs/measurements/photo-shot-list.md`: required photo record for each bench session.
- `docs/measurements/case-work-todo.md`: current measurement and printable gaps blocking real coupon work.
- `docs/research/extant-art.md`: current external references and candidate hardware families.
- `docs/research/t7810-fan-and-airflow-prior-art-2026-04-22.md`: stock Dell fan behavior, external front-fan replacement constraints, and aftermarket PWM candidate prior art.
- `docs/research/honey-power-reset-and-multi-psu-2026-04-22.md`: April 22 workstation power/reset findings and multi-PSU research memo for `honey`.
- `docs/research/honey-reset-matrix-2026-04-22.md`: reset-focused matrix for the failed and recovered `honey` display/GPU states.
- `docs/tracking/linear-git-workflow.md`: active Linear issue map and branch policy for the hardware lane.
- `docs/tracking/hygiene-mini-sprint-2026-04-25.md`: current cleanup sprint for tracker truth, GloriousFlywheel runner/cache parity, and evidence sequencing.
- `docs/tracking/measured-evidence-map.md`: current split between real measured evidence, historical imported measurements, and still-unmeasured scaffolding.
- `docs/tracking/repo-health-reality-check-2026-04-23.md`: dated git, issue, evidence, and cross-repo health check.
- `docs/tracking/workstream-status-2026-04-22.md`: dated status snapshot of the active workstreams and recommended next scopes.
- `data/captures/`: durable live host capture artifacts promoted out of scratch output paths.
- `data/measurements/feature-register.csv`: feature-by-feature measurement register.
- `data/measurements/honey-fan-support-matrix.csv`: working support matrix for stock and candidate fan rows.
- `data/measurements/honey-fan-noise-runs.csv`: optional lightweight acoustic run log.
- `data/measurements/session-01-print-manifest.csv`: print manifest for the current Session 01 coupon family.
- `data/measurements/session-01-priority-log.csv`: pre-seeded first session capture sheet.
- `analysis/`: Chapel workspace for NUMA probes, timing invariants, and property-based testing.
- `cad/openscad/`: parametric OpenSCAD source and shared configuration.
- `cad/freecad/`: FreeCAD-side notes and import/export helpers.
- `scripts/platform/`: Dell 7810 BIOS and SMI validation helpers.
- `packaging/kernel/`: generic T7810 host-kernel config fragments and boot posture.
- `packaging/tuned/`: low-latency host tuning profiles and helper scripts.
- `nix/packages/`: repo-local package definitions such as Chapel for NUMA experiments.
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
direnv allow
nix develop path:.
just --list
nix develop path:.#chapel
```

`openscad` is confirmed available locally. `FreeCAD` is not currently on `PATH`, so the shell treats it as optional until that is resolved.

For Chapel-specific sourcing and the current external-vs-local split, see
[`docs/platform/chapel-sourcing.md`](docs/platform/chapel-sourcing.md).

For the current paper-safe Chapel and PBT claim boundary, also use
[`analysis/README.md`](analysis/README.md) and
[`docs/publication/claim-traceability.md`](docs/publication/claim-traceability.md).

For paper and presentation framing, use
[`docs/publication/README.md`](docs/publication/README.md) together with
[`docs/platform/xoxdwm-boundary-audit.md`](docs/platform/xoxdwm-boundary-audit.md)
before treating this repo and `XoxdWM` as one blended source.

The current case-work bench loop is:

```bash
just fit-coupons-session-01
just measurements-session-01-status
just measurements-session-01-evidence-status
just measurements-session-01-scad-preview
just measurements-session-01-apply-scad
```

Use `just measurements-session-01-apply-scad-write` only after the dry-run diff
looks correct. It only stamps confirmed assignments into
`cad/openscad/lib/measured-params.scad`, and it refuses to write if the bench
evidence is incomplete.

## Immediate next step

For case work, start with [`docs/measurements/measurement-plan.md`](docs/measurements/measurement-plan.md) and [`docs/measurements/case-work-todo.md`](docs/measurements/case-work-todo.md) before making any serious interface geometry claims. For host-platform work, use [`docs/research/honey-reset-matrix-2026-04-22.md`](docs/research/honey-reset-matrix-2026-04-22.md) and [`docs/platform/README.md`](docs/platform/README.md) to keep workstation-specific validation in this repo rather than in `XoxdWM`.
