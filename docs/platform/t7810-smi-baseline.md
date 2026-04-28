# Dell T7810 SMI Baseline

Historical baseline imported from `XoxdWM` so the workstation timing lane has a home in this repo.

## Measurement context

- Date: 2026-03-15
- System: Dell Precision Tower 7810 (`0GWHMW`)
- BIOS at time of measurement: `A02`
- Kernel at time of measurement: `6.19.5-1.el10.elrepo.x86_64`
- CPU: `2x Xeon E5-2630 v3`
- NUMA layout:
  node0 `0-7,16-23`
  node1 `8-15,24-31`

This baseline matters because it was taken before the later A34-oriented host work and before the April 22 reset investigations.

## Method summary

The original work combined:

- firmware reverse engineering of the Dell BIOS image,
- SMI source mapping on the Wellsburg platform,
- `rdmsr` checks of `MSR 0x34`,
- and `hwlat` measurements on the live host.

The imported takeaway is not that every number is final forever. It is that the repo now has a historical timing floor to compare against after BIOS, boot-parameter, and kernel changes.

## Historical results

### SMI activity

- boot accumulated roughly `9959` SMIs before the host was even idle
- a 10-second idle sample could misleadingly show zero
- a 30-second sample showed about `22` SMIs, or about `0.73/s`

### hwlat results

- worst observed hardware latency: `2523 us`
- the largest spikes clustered on socket 1 / NUMA node 1
- lower-level background noise mostly sat in the `16-60 us` range

### Observed asymmetry

The strong working interpretation was:

- the PCH is local to socket 0
- socket 1 pays extra rendezvous cost during SMI handling
- the cross-socket penalty makes node 1 the worst latency surface

That interpretation is consistent with how the platform is physically structured, but it should still be treated as an engineering inference rather than a formal proof.

## Why this was a real problem

At low-latency sample or frame budgets, millisecond-scale firmware stalls are not cosmetic:

- they consume a meaningful fraction of a `90 Hz` frame budget
- they can corrupt or delay timing-sensitive acquisition work
- they make it harder to tell platform faults from software faults

## Expected improvements after mitigation

The earlier work expected improvement from:

- BIOS `A34`
- disabling USB legacy support
- reducing BIOS-managed power-state behavior
- low-latency boot parameters
- host validation with `hwlat`, `osnoise`, and `timerlat`

The current repo-side target remains a practical one:

- get the host into a much cleaner latency posture than the A02 baseline
- then compare that cleaner posture against the reset matrix and real workstation behavior

## Repo surfaces that now support this

- [`scripts/platform/smi-validate`](../../scripts/platform/smi-validate)
- [`scripts/platform/dcc-configure-rt`](../../scripts/platform/dcc-configure-rt)
- [`packaging/tuned/t7810-low-latency/tuned.conf`](../../packaging/tuned/t7810-low-latency/tuned.conf)
- [`docs/platform/kernel-lane.md`](kernel-lane.md)

## Next measurement to add

The next useful timing document in this repo is not another historical baseline. It is a post-mitigation measurement on the actual current `honey` posture:

- current BIOS version
- current boot parameters
- current kernel
- current `hwlat` result
- current reset behavior cross-linked to the reset matrix
