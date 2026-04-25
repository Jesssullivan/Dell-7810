# Honey RT SMI/Hwlat And Chapel Series

Date: 2026-04-25

Host: `honey` / Dell Precision T7810

Purpose: complete the first paired generic-versus-RT host-characterization
packet without claiming application or XR benefit.

## Evidence

Generic packet:

- `data/captures/honey/kernel-lane-status-generic-2026-04-25.txt`
- `data/captures/honey/smi-validate-generic-2026-04-25-sample-01.txt`
- `data/captures/honey/smi-validate-generic-2026-04-25-sample-02.txt`
- `data/captures/honey/smi-validate-generic-2026-04-25-sample-03.txt`
- `data/captures/honey/chapel-host-probe-generic-2026-04-25.txt`
- `dhall/defaults/honey-chapel-host-probe-generic-2026-04-25.dhall`

RT packet:

- `data/captures/honey/kernel-lane-status-rt-2026-04-25.txt`
- `data/captures/honey/smi-validate-rt-2026-04-25-sample-01.txt`
- `data/captures/honey/smi-validate-rt-2026-04-25-sample-02.txt`
- `data/captures/honey/smi-validate-rt-2026-04-25-sample-03.txt`
- `data/captures/honey/chapel-host-probe-rt-2026-04-25.txt`
- `dhall/defaults/honey-chapel-host-probe-rt-2026-04-25.dhall`

Return-to-generic proof:

- `data/captures/honey/kernel-lane-status-post-rt-return-2026-04-25.txt`
- `data/captures/honey/kernel-baseline-post-rt-return-2026-04-25.txt`

Derived publication artifacts:

- `docs/publication/data/honey-rt-smi-chapel-packet-2026-04-25.csv`
- `docs/publication/figures/bow2-first-generic-rt-packet.dot`
- `docs/publication/figures/rendered/bow2-first-generic-rt-packet.svg`

These derived artifacts summarize the raw captures; they are not a separate
measurement authority.

## Host posture

The RT run used a one-time boot into `6.19.5-rt1-8.xr.el10`; the persistent
default stayed on the generic lane.

After the RT packet, `honey` returned to:

- kernel: `6.19.5-7.xr.el10`
- `/sys/kernel/realtime`: absent
- default kernel: `/boot/vmlinuz-6.19.5-7.xr.el10`
- `next_entry`: empty
- post-return generic baseline validation: `PASS`

That makes this packet safe to cite as a one-shot RT characterization run, not
as a persistent kernel-lane change.

## SMI and hwlat samples

Each sample used a `30s` SMI counter window and a `30s` tracefs `hwlat` window.

| Lane | Sample | Kernel | SMI count | Rate | tracefs hwlat max |
| --- | ---: | --- | ---: | ---: | ---: |
| generic | 1 | `6.19.5-7.xr.el10` | 74 / 30s | 2.5/s | 0 us |
| generic | 2 | `6.19.5-7.xr.el10` | 73 / 30s | 2.4/s | 2 us |
| generic | 3 | `6.19.5-7.xr.el10` | 74 / 30s | 2.5/s | 2 us |
| RT | 1 | `6.19.5-rt1-8.xr.el10` | 66 / 30s | 2.2/s | 0 us |
| RT | 2 | `6.19.5-rt1-8.xr.el10` | 65 / 30s | 2.2/s | 2 us |
| RT | 3 | `6.19.5-rt1-8.xr.el10` | 74 / 30s | 2.5/s | 2 us |

## Chapel host probe

Both Chapel captures used the already-present target Chapel 2.8.0 store path:

`/nix/store/8y7r4j0lzv8jjyllmhc0gydyssw88rvr-chapel-2.8.0`

That avoids perturbing the timing window with an on-target compiler build.

| Metric | Generic lane | RT lane | Direction |
| --- | ---: | ---: | --- |
| Kernel | `6.19.5-7.xr.el10` | `6.19.5-rt1-8.xr.el10` | paired lanes |
| `/sys/kernel/realtime` | absent | `1` | RT confirmed |
| Serial reduction | `0.022323s` | `0.022533s` | RT +0.9% |
| Parallel reduction | `0.001807s` | `0.001927s` | RT +6.6% |
| Speedup | `12.3536x` | `11.6933x` | RT -5.3% |
| Partitions | 2 | 2 | unchanged |
| Sublocales | 0 | 0 | expected under flat locale model |
| Conforms | true | true | both pass |

## Interpretation

Safe claims:

- The same Dell-owned SMI/hwlat capture shape now exists for the generic and
  RT lanes.
- The same Chapel host-characterization probe now runs and conforms on the
  generic and RT lanes.
- `honey` returned to the generic fallback after the RT packet.
- SMI activity remained nonzero and similar in magnitude on both lanes.
- tracefs `hwlat` stayed low in these short 30s windows.

Unsafe claims:

- RT improved SMI behavior.
- RT improved Chapel host-probe timing.
- RT improved downstream XR, compositor, or BCI behavior.
- The current sample count is enough for a benchmark distribution.

The result is still useful: it converts the blog/paper frame from "RT Chapel
data is missing" to "the first paired packet exists, and it is not an
improvement story yet." The next publication-safe step is a longer repeated
series, not stronger prose.

## Next measurement packet

Before writing a result claim, collect:

1. More generic and RT samples with the same store-prebuilt Chapel path.
2. Longer SMI/hwlat windows, ideally at least several minutes per lane.
3. A note on any active lab load during each capture.
4. If BIOS or C-state settings change, a fresh BIOS record before repeating
   these comparisons.
