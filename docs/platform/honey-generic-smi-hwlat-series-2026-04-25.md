# Honey Generic SMI/Hwlat Series

Date: 2026-04-25

Host: `honey` / Dell Precision T7810

Kernel lane: generic `6.19.5-7.xr.el10`, `PREEMPT_DYNAMIC`

Purpose: replace the earlier single short SMI/hwlat sample with a repeated
generic-lane timing-context packet before making RT or Chapel comparison claims.

## Evidence

- `data/captures/honey/kernel-lane-status-generic-2026-04-25.txt`
- `data/captures/honey/smi-validate-generic-2026-04-25-sample-01.txt`
- `data/captures/honey/smi-validate-generic-2026-04-25-sample-02.txt`
- `data/captures/honey/smi-validate-generic-2026-04-25-sample-03.txt`
- `data/captures/honey/chapel-host-probe-generic-2026-04-25.txt`
- `dhall/defaults/honey-chapel-host-probe-generic-2026-04-25.dhall`

## Host posture

- Current kernel: `6.19.5-7.xr.el10`
- Default kernel: `/boot/vmlinuz-6.19.5-7.xr.el10`
- One-time RT candidate present: `6.19.5-rt1-8.xr.el10`
- `next_entry` is empty
- Tuned profile: `t7810-low-latency`
- Isolated CPUs: `2-7`
- `nohz_full=2-7`

## Samples

Each sample used:

- SMI counter window: `30s`
- tracefs `hwlat` window: `30s`
- hwlat threshold: `10 us`

| Sample | SMI count | Rate | tracefs hwlat max |
| --- | ---: | ---: | ---: |
| 1 | 74 / 30s | 2.5/s | 0 us |
| 2 | 73 / 30s | 2.4/s | 2 us |
| 3 | 74 / 30s | 2.5/s | 2 us |

## Interpretation

This strengthens the generic-lane context but does not establish an RT result.

The useful claim is:

- bounded generic-lane SMI activity is repeatably nonzero under the current
  tuned low-latency posture,
- the tracefs `hwlat` window remained low in these three samples,
- and the next RT-lane packet should use the same repeated-window shape before
  any generic-versus-RT Chapel comparison is promoted.

The unsafe claims are:

- "SMI is fixed"
- "RT improved timing"
- "Chapel shows RT benefit"
- "XoxDWM or XR behavior improved"

## Chapel capture note

An initial same-evening on-target Chapel capture was stopped because it began
building the Chapel compiler on `honey`. That build path is useful for packaging
debugging but wrong for timing characterization because it perturbs the host.

A second capture used an already-present Chapel 2.8.0 target store path and did
not run `nix build` on `honey`:

| Metric | Value |
| --- | ---: |
| Capture mode | `on-target-store-prebuilt` |
| Compiler store | `/nix/store/8y7r4j0lzv8jjyllmhc0gydyssw88rvr-chapel-2.8.0` |
| Serial reduction | `0.022323s` |
| Parallel reduction | `0.001807s` |
| Speedup | `12.3536x` |
| Conforms | `true` |

This is still generic-lane evidence. It completes the non-destructive generic
packet, but it does not establish a generic-versus-RT comparison.

The first paired RT packet was later captured the same evening and is
summarized in
[`honey-rt-smi-hwlat-chapel-series-2026-04-25.md`](honey-rt-smi-hwlat-chapel-series-2026-04-25.md).
