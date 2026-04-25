# Paper Outline -- Legacy Workstation To Host-Characterization Platform

This is the first concrete publication scaffold for this repo.

It is intentionally narrow. It combines:

- Lane A from `narrative-lanes.md`:
  legacy workstation modification
- Lane B from `narrative-lanes.md`:
  host characterization for BCI/HPC

It does **not** treat XR application results as a co-equal claim surface.

## Working title candidates

- Rehabilitating a Legacy Dual-Socket Workstation for Timing-Sensitive Compute
- From Legacy Tower To Measured Host: Reset, NUMA, and Enclosure Work on a Dell 7810
- Chapel and Property-Based Host Characterization on a Modified Dell Precision 7810

## One-sentence thesis

A legacy dual-socket workstation pushed outside its stock enclosure and power
envelope can still become a credible timing-sensitive host, but only if the
mechanical, reset, latency, and locality surfaces are treated as one measured
platform problem rather than as disconnected hacks.

## Abstract skeleton

Use this as a starting shape, not as final prose.

1. Problem:
   a Dell Precision 7810 was repurposed for a workload class with stricter
   timing, locality, and cabling constraints than its stock enclosure and power
   design were meant to support.
2. Method:
   the project combined measurement-first enclosure work, reset and SMI
   characterization, NUMA-aware Chapel probes, and property-based timing checks.
3. Contribution:
   the repo formalizes a host contract rather than only carrying ad hoc machine
   tweaks.
4. Scope boundary:
   application-side XR and BCI stack claims remain outside the main result
   surface.
5. Outcome:
   the paper should report either the first measured host baseline or the first
   measured enclosure-plus-host baseline, depending on what evidence is ready.

## Section outline

## 1. Introduction

### Purpose

Frame the problem as a systems rehabilitation problem, not just a case mod and
not just an HPC software exercise.

### Evidence source

- `docs/publication/narrative-lanes.md`
- `docs/publication/claim-traceability.md`
- `docs/research/honey-power-reset-and-multi-psu-2026-04-22.md`

### Status

Draftable now.

## 2. Platform context and constraints

### Purpose

Explain the Dell 7810 hardware context, what changed from stock, and why the
host can no longer be treated as an untouched commodity workstation.

### Evidence source

- `README.md`
- `docs/research/extant-art.md`
- `docs/research/honey-power-reset-and-multi-psu-2026-04-22.md`
- `docs/research/honey-reset-matrix-2026-04-22.md`

### Status

Draftable now, but stronger once the power-path inventory is filled.

## 3. Measurement-first enclosure method

### Purpose

Describe the workflow:

- named feature register
- ordered bench session
- coupon matrix
- evidence-gated SCAD apply path

### Evidence source

- `docs/measurements/measurement-plan.md`
- `docs/measurements/bench-session-01.md`
- `docs/measurements/printable-coupon-matrix.md`
- `scripts/measurements/session-01-status`
- `scripts/measurements/session-01-evidence-status`
- `scripts/measurements/session-01-apply-scad`

### Status

Method section is draftable now.
Results section is blocked on bench execution.

## 4. Host contract and reset/latency characterization

### Purpose

Explain how the host was formalized as a measurable platform:

- reset matrix
- BIOS posture
- SMI and hwlat posture
- host-kernel baseline versus XR overlay

### Evidence source

- `docs/platform/host-kernel-baseline.md`
- `docs/platform/kernel-lane.md`
- `docs/platform/t7810-smi-baseline.md`
- `docs/research/honey-reset-matrix-2026-04-22.md`
- `scripts/platform/smi-validate`
- `scripts/platform/capture-reset-state`

### Status

Framing is draftable now.
Fresh measured results are blocked on real host execution.

## 5. Chapel and property-based host characterization

### Purpose

Show why Chapel appears in this project at all:

- express NUMA-oriented host structure
- express timing and jitter proof surfaces
- use `quickchpl` to harden invariant claims

### Evidence source

- `analysis/examples/HostNumaProbe.chpl`
- `analysis/src/HostNumaTiming.chpl`
- `analysis/src/TimingProofs.chpl`
- `analysis/test/TestHostNumaTiming.chpl`
- `analysis/test/TestTimingProofs.chpl`
- `docs/platform/numa-and-chapel.md`

### Status

Method and motivation are draftable now.
The first generic/RT host result subsection is draftable only as a cautious
packet note; repeated captures are still required before presenting a timing
improvement result.

## 6. Boundary and provenance

### Purpose

Make the repo split explicit so the paper does not accidentally cite the wrong
surface for the wrong claim.

### Evidence source

- `docs/platform/xoxdwm-boundary-audit.md`
- `docs/platform/duplication-status.md`
- `docs/publication/claim-traceability.md`

### Status

Draftable now and important for a methods or appendix section.

## 7. Results

### Desired result groups

- measured enclosure interface/coupon outcomes
- measured reset and latency outcomes on `honey`
- measured NUMA/host probe outcomes

### Status

Not ready yet.
This section should not be drafted as if the evidence already exists.

## 8. Discussion

### Good themes

- legacy hardware can still be a serious host if treated as a measured platform
- enclosure, reset, power, and NUMA are coupled engineering variables
- Chapel can be useful below the full application layer as a host-method tool
- property-based tests can harden systems claims before expensive experiments

### Avoid

- claiming application-side BCI success from host-method evidence
- claiming XR overlay efficacy from generic host baseline evidence

## 9. Conclusion

### Likely shape

The conclusion should emphasize:

- host contract formalization
- measurement-first method
- and the bridge from legacy hardware modification to timing-sensitive compute

It should not overclaim downstream application readiness.

## Figure and table candidates

### Figure candidates

1. Platform overview:
   modified Dell 7810, cable path, and enclosure problem statement
2. Measurement workflow:
   feature register -> bench session -> coupon -> SCAD apply -> measured CAD
3. Boundary diagram:
   Dell-7810 host platform lane versus `XoxdWM` XR/application lane
4. Host-method diagram:
   reset matrix + SMI baseline + Chapel/PBT probe flow

### Table candidates

1. Named feature IDs and what each coupon family validates
2. Reset matrix rows and key observables
3. Host baseline versus XR overlay boundary table
4. Chapel proof surface table:
   invariant, source file, test surface, empirical dependency

## Current recommendation

The best current paper shape is a methods-forward host-systems paper with
partial results, not a full results-heavy hardware paper yet.

That means:

- write sections 1 through 6 first,
- keep section 7 explicitly marked as pending measured evidence,
- and fill the result tables only after Scope A and/or Scope B from the
  workstream status note are executed.
