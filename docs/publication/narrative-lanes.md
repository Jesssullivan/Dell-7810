# Narrative Lanes

Use this note when framing a paper, talk, or project summary.

The mistake to avoid is telling one giant story that mixes:

- legacy workstation modification,
- host-platform characterization,
- BCI/HPC motivation,
- and XR runtime or application validation.

Those are related, but they are not the same claim surface.

## Lane A: Legacy workstation modification

This is the "Dell 7810 as a legacy server/workstation modification project"
story.

### Core question

How do you turn an old Dell Precision 7810 into a safe, serviceable, measurable
host after pushing it far outside the stock enclosure and power envelope?

### Primary evidence

- `docs/measurements/`
- `cad/openscad/`
- `output/stl/`
- `docs/research/honey-power-reset-and-multi-psu-2026-04-22.md`
- `docs/research/honey-reset-matrix-2026-04-22.md`

### Good claims

- the OEM enclosure no longer matches the installed GPU and cabling reality
- a measurement-first coupon workflow is being used instead of guessed CAD
- the host has real reset, power-path, and serviceability constraints
- the platform needs a new enclosure and a better-defined power/reset contract

### Do not turn this lane into

- a claim that the BCI software stack is already validated
- a claim that XR runtime success proves the hardware redesign is complete
- a generic HPC paper with only incidental mechanical detail

## Lane B: Host characterization for BCI/HPC

This is the "confluence of technical interests to do real HPC work and bring a
BCI server to reality" story, but at the host-method level rather than the full
application-stack level.

### Core question

How do you characterize a dual-socket legacy workstation as a credible timing-
sensitive compute host using NUMA-aware probes, SMI/reset evidence, and
proof-oriented Chapel tests?

### Primary evidence

- `docs/platform/`
- `analysis/`
- `scripts/platform/`
- `packaging/kernel/`
- `packaging/tuned/`

### Good claims

- the host has a measurable reset and latency surface
- NUMA structure and timing invariants can be described and checked explicitly
- Chapel is being used as a host-characterization language, not just as an HPC
  end-user language
- property-based testing via `quickchpl` is being used to harden timing and
  partitioning claims

### Safe way to mention BCI

Use BCI as the motivating workload class and systems requirement:

- low-latency timing matters,
- NUMA locality matters,
- deterministic behavior matters,
- and the host contract has to be understood before higher-level pipelines are
  credible.

### Do not turn this lane into

- a claim that the full BCI pipeline or classifier stack lives here
- a claim that Chapel examples here are application benchmarks
- a claim that proof-oriented tests here replace empirical host measurements

## Lane C: XR and application integration

This is usually context, not the main story for this repo.

### Role in this repo's narrative

- provides downstream motivation,
- explains why `honey` is a real stressed host,
- and explains why some kernel or display-path discussions exist at all.

### Primary source of truth

- `XoxdWM`

### Keep out of Dell-first papers unless necessary

- headset-specific patch efficacy claims
- compositor-specific runtime policy
- product-facing support claims
- application-side BCI analysis results

## Good combinations

Two combinations are sensible:

1. Lane A alone:
   a hardware modification and host-reliability paper or talk
2. Lane A plus Lane B:
   a host-systems paper or talk where the enclosure/power/reset redesign and
   the Chapel/NUMA/PBT methodology are both part of the platform story

If Lane C appears, it should usually be one short motivation section, not a
co-equal claim surface.

## Red-flag combinations

Avoid these patterns:

- using `XoxdWM` operational boot artifacts as if they were Dell-only hardware
  evidence
- presenting Chapel timing proofs as if they were direct workload performance
  measurements
- presenting BCI ambition as if it were already equivalent to a validated BCI
  system result
- blending XR patch carry with generic host-kernel posture in the same result
  table without an explicit overlay/base split
