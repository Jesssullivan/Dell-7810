# RT Research Contract

Use this note when deciding what `Dell-7810`, `XoxdWM`, and `linux-xr` are each
allowed to claim about PREEMPT_RT on `honey`.

It exists because RT work on this machine is not one thing. It is at least four:

1. shipped kernel semantics
2. live host validation
3. workstation operational acceptability
4. downstream software or XR benefit

Those should not collapse into one claim.

## Repo roles

| Surface | Dell-7810 | `linux-xr` | `XoxdWM` |
| --- | --- | --- | --- |
| Kernel build/install semantics | consumer of shipped results | canonical supplier | consumer |
| Current host RT state on `honey` | canonical raw evidence | may summarize historical shipped validation only | may summarize only by linking back to Dell evidence |
| RT boot control on `honey` | canonical workstation procedure and evidence | out of scope | out of scope |
| RT acceptance for workstation use | canonical | out of scope | may consume |
| XR/compositor benefit under RT | preconditions only | out of scope | canonical software-side result |

## Runner boundary

Dogfood runners, cacheable Nix builds, and CI executor pools are part of the
build-validation surface, not the host-evidence surface.

Current reachability boundary: `Dell-7810` declares the shared
GloriousFlywheel `tinyland-nix` runner contract, but this personal-account repo
cannot currently reach that lane. Do not count queued runner jobs as RT or
Chapel package authority. The compliant exits are org/enterprise shared scope,
an intentional mirror or owner-boundary move, an enterprise-level shared runner
proof, or an explicit blocked state.

Use them for:

- package and compiler reproducibility,
- CI checks over Dell-owned scripts and analysis code,
- and build-cache publication for repeated Chapel or kernel-adjacent work.

Do not treat them as substitutes for `honey` when the claim depends on:

- live RT boot state,
- workstation recovery timing,
- SMI or `hwlat` measurements,
- NUMA inventory on the dual-socket host,
- or any other `C1` / `C2` / `C3` evidence.

Current workflow split in this repo:

- `.github/workflows/kernel-dogfood.yml`
  cacheable runner lane for Dell-owned kernel-validation tooling and seeded RT
  record projection; this is not host evidence
- `.github/workflows/kernel-honey-evidence.yml`
  manual `honey` artifact lane for live runtime, lane-status, baseline, and SMI
  captures
- `.github/workflows/chapel-dogfood.yml`
  cacheable runner lane for Chapel/package reproducibility
- `.github/workflows/chapel-honey-evidence.yml`
  manual `honey` artifact lane for live Chapel host probes

The important symmetry is deliberate: runner lanes validate reproducibility and
tooling, while `honey` lanes capture machine-under-test truth.

## Claim ladder

Each higher claim depends on the lower one beneath it.

### C0. RT package installed

Meaning:
- an RT kernel exists on disk

Current authority:
- `linux-xr` for shipped package semantics
- Dell-7810 for whether that package is actually installed on `honey`

### C1. RT boot proved

Meaning:
- the host booted an RT kernel
- `uname -v` contains `PREEMPT_RT`
- `/sys/kernel/realtime` is `1`

Current authority:
- Dell-7810 only

### C2. RT host posture validated

Meaning:
- base fragment validated
- RT overlay validated against the shipped kernel semantics
- low-latency cmdline validated

Current authority:
- Dell-7810 only

### C3. RT operationally acceptable

Meaning:
- boot/recovery timing is acceptable for the workstation role
- generic fallback return path remains safe
- the operator cost of RT is understood

Current authority:
- Dell-7810 only

### C4. RT materially benefits downstream software

Meaning:
- XR, compositor, or BCI software has a demonstrated benefit under RT

Current authority:
- `XoxdWM` or another application-side consumer repo

Dell-7810 may provide the host preconditions and evidence, but not the
software-side conclusion.

## Current `honey` position

As of April 23, 2026:

- C0: yes
- C1: yes
- C2: yes, under the reconciled Dell validator that matches the shipped
  `linux-xr` RT semantics
- C3: partial
  RT recovery is slower than the generic lane, even though the second pass was
  smoother than the first
- C4: not yet established here

## Update order when an RT fact changes

1. Dell-7810 raw captures
2. Dell-7810 machine-readable validation record
3. Dell-7810 summary note
4. `linux-xr` only if the shipped kernel semantics or supplier docs changed
5. `XoxdWM` only if software-facing support or performance claims changed

## Machine-readable RT record

The Dell repo now carries a formal RT validation record type:

- `dhall/types/KernelValidationRun.dhall`

And a projector for future runs:

- `scripts/platform/project-kernel-validation-dhall`

Current seeded records:

- `dhall/defaults/honey-rt-validation-first-2026-04-23.dhall`
- `dhall/defaults/honey-rt-validation-second-2026-04-23.dhall`

These should be treated as the formal research ledger for RT host-validation
claims on `honey`.
