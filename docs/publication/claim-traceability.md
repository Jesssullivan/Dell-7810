# Claim Traceability

Use this note to decide which repo and which artifacts should back a claim in a
paper, presentation, abstract, or project summary.

The goal is not legal citation style. The goal is to stop scope drift and
accidental repo-mixing.

## Claim matrix

| Claim family | Canonical repo | Primary artifacts | Safe wording | Avoid |
| --- | --- | --- | --- | --- |
| enclosure redesign, printable coupons, chassis measurements | `Dell-7810` | `docs/measurements/`, `cad/openscad/`, `output/stl/`, measurement CSVs | "The Dell 7810 enclosure lane uses a measurement-first coupon workflow..." | citing XR runtime behavior as proof that the enclosure work is complete |
| power-path, reset, BIOS, SMI, NUMA host evidence | `Dell-7810` | `docs/platform/`, `docs/research/honey-reset-matrix-2026-04-22.md`, `scripts/platform/`, `packaging/kernel/`, `packaging/tuned/` | "The host contract was characterized on the Dell 7810 platform via reset, SMI, and NUMA evidence..." | treating `XoxdWM` deployment scripts as the main evidence source |
| Chapel as a host-characterization method | `Dell-7810` | `analysis/`, `docs/platform/numa-and-chapel.md`, `docs/platform/chapel-sourcing.md` | "Chapel was used here as a host-characterization and proof-structure tool..." | implying that the Dell repo contains the whole application analysis stack |
| property-based timing or partitioning checks using `quickchpl` | `Dell-7810` | `analysis/test/TestHostNumaTiming.chpl`, `analysis/src/TimingProofs.chpl` | "Property-based tests were used to harden timing and partitioning invariants..." | claiming that PBT alone establishes empirical latency performance |
| historical provenance of host scripts/profiles extracted from `XoxdWM` | both, with Dell as current host-facing copy | `docs/platform/xoxdwm-boundary-audit.md` plus the derivative file headers | "This surface originated in XoxdWM and was formalized here as the Dell-owned host copy..." | pretending the Dell copy was created independently |
| actual `honey` boot topology, BLS entries, storage migration, debug boot generations | `XoxdWM` | `packaging/dhall/defaults/honey-*.dhall`, `packaging/scripts/honey-storage-migrate` | "Operational host boot and storage posture remained anchored in XoxdWM..." | copying those files into this repo and treating them as Dell-first evidence |
| XR patch efficacy, Beyond bring-up, compositor/runtime integration | `XoxdWM` | `nix/kernel/xr-kernel.nix`, `patches/`, compositor and remote setup lanes | "XR-specific overlay behavior is tracked in XoxdWM..." | presenting these as generic Dell 7810 platform facts |
| application-side BCI analysis or product-facing workload claims | `XoxdWM` | application analysis modules, runtime benchmarks, software integration results | "Application-side BCI behavior is out of scope for this repo and belongs to XoxdWM..." | using the Dell host-characterization workspace as a substitute citation |

## Attribution patterns

Use one of these patterns explicitly when needed.

### Derived there, formalized here

Use this when a host-facing artifact started in `XoxdWM` but now has a Dell
repo home:

- `smi-validate`
- the low-latency tuned profile
- the repo-local Chapel fallback
- the early NUMA demo scaffolding

Suggested phrasing:

- "This host-facing artifact originated in `XoxdWM` and was later narrowed and formalized in the Dell 7810 repo."

### Measured here, summarized elsewhere

Use this when the evidence is a Dell-platform result that may matter to XR or
BCI work later:

- reset rows
- BIOS posture
- SMI/hwlat results
- NUMA inventory
- enclosure measurements

Suggested phrasing:

- "The underlying host evidence is recorded in the Dell 7810 repo; downstream project notes only summarize the effect relevant to XR or BCI work."

### Operational truth remains elsewhere

Use this when the fact is real and relevant but the operative source is still
in `XoxdWM`:

- boot entries
- storage migration
- deployment posture
- remote host ops

Suggested phrasing:

- "Operational boot and deployment truth remained in `XoxdWM`, while Dell-platform characterization and evidence were separated into the Dell 7810 repo."

## Paper-safe Chapel framing

If Chapel is part of the publication, the cleanest claim surface here is:

- Chapel was used to express host-structure, timing, and NUMA-oriented proof
  surfaces on a dual-socket legacy workstation.
- `quickchpl` was used to exercise those invariants with property-based tests.
- the analysis workspace is deliberately smaller than the full application-side
  analysis tree in `XoxdWM`.

That gives a defensible "Chapel and PBT in action" story without implying that
every downstream BCI or XR result is housed in this repo.

## Do not do this

- Do not write "the Dell repo proves the BCI server works" unless the claim is
  narrowed to host-platform readiness.
- Do not write "the Chapel lane was built entirely in the Dell repo" without
  acknowledging `XoxdWM` provenance where it exists.
- Do not cite a host-kernel posture and an XR overlay result as if they were the
  same variable.
- Do not create a second historical baseline note when a dated one already
  exists; add a follow-on measurement instead.
