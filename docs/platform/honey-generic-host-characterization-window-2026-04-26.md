# Honey Generic Host Characterization Window

Date: 2026-04-26

Host: `honey` / Dell Precision T7810

Kernel lane: generic `6.19.5-7.xr.el10`, `/sys/kernel/realtime` absent

Purpose: collect a longer non-destructive generic-lane packet with the new
host-characterization-window helper before attempting the matching RT repeat
series.

## Evidence

Manifest:

- `data/captures/honey/host-characterization-window-generic-repeat-2026-04-26.txt`

SMI / `hwlat` captures:

- `data/captures/honey/smi-validate-generic-repeat-2026-04-26-sample-01.txt`
- `data/captures/honey/smi-validate-generic-repeat-2026-04-26-sample-02.txt`
- `data/captures/honey/smi-validate-generic-repeat-2026-04-26-sample-03.txt`

Chapel captures:

- `data/captures/honey/chapel-host-probe-generic-repeat-2026-04-26-sample-01.txt`
- `data/captures/honey/chapel-host-probe-generic-repeat-2026-04-26-sample-02.txt`
- `data/captures/honey/chapel-host-probe-generic-repeat-2026-04-26-sample-03.txt`
- `data/captures/honey/chapel-host-probe-generic-repeat-2026-04-26-sample-04.txt`
- `data/captures/honey/chapel-host-probe-generic-repeat-2026-04-26-sample-05.txt`

Projected Chapel records:

- `dhall/defaults/honey-chapel-host-probe-generic-repeat-2026-04-26-sample-01.dhall`
- `dhall/defaults/honey-chapel-host-probe-generic-repeat-2026-04-26-sample-02.dhall`
- `dhall/defaults/honey-chapel-host-probe-generic-repeat-2026-04-26-sample-03.dhall`
- `dhall/defaults/honey-chapel-host-probe-generic-repeat-2026-04-26-sample-04.dhall`
- `dhall/defaults/honey-chapel-host-probe-generic-repeat-2026-04-26-sample-05.dhall`

Helper:

```bash
just platform-host-characterization-window \
  target=jess@honey \
  tag=generic-repeat-2026-04-26 \
  expect_lane=generic \
  smi_samples=3 \
  smi_duration=120 \
  hwlat_duration=120 \
  chapel_samples=5
```

The helper does not reboot, schedule RT, change BIOS, change tuned, or alter
the default kernel. It refused RT-lane capture during validation when the host
was on generic, then this run proceeded with `expect_lane=generic`.

## Host context

Preflight:

- kernel: `6.19.5-7.xr.el10`
- `/sys/kernel/realtime`: absent
- uptime: `22620.39` seconds
- loadavg: `8.53 5.46 3.73`
- `next_entry`: empty
- `rke2-server`: active

Postflight:

- kernel: `6.19.5-7.xr.el10`
- `/sys/kernel/realtime`: absent
- uptime: `23483.51` seconds
- loadavg: `5.48 6.77 5.69`
- `rke2-server`: active

The host remained on the generic fallback lane for the whole packet.

## SMI and hwlat samples

Each sample used a `120s` SMI counter window and a `120s` tracefs `hwlat`
window.

| Sample | Kernel | SMI count | Rate | tracefs hwlat max | tuned profile |
| --- | --- | ---: | ---: | ---: | --- |
| 1 | `6.19.5-7.xr.el10` | 280 / 120s | 2.3/s | 0 us | `t7810-low-latency` |
| 2 | `6.19.5-7.xr.el10` | 279 / 120s | 2.3/s | 0 us | `t7810-low-latency` |
| 3 | `6.19.5-7.xr.el10` | 279 / 120s | 2.3/s | 0 us | `t7810-low-latency` |

Interpretation:

- SMI activity remains nonzero and stable over the longer generic windows.
- The tracefs `hwlat` fallback stayed at `0 us` max in all three samples.
- This does not prove SMI mitigation. It records generic-lane host posture.

## Chapel host probe

All five Chapel captures used the store-prebuilt target path, so the timing
windows did not include building Chapel on `honey`.

| Sample | 1m loadavg | Serial | Parallel | Ratio | Conforms |
| --- | ---: | ---: | ---: | ---: | --- |
| 1 | 4.58 | `0.025468s` | `0.001932s` | `13.1822x` | true |
| 2 | 5.46 | `0.027597s` | `0.001946s` | `14.1814x` | true |
| 3 | 6.69 | `0.021964s` | `0.001782s` | `12.3255x` | true |
| 4 | 6.56 | `0.021841s` | `0.001768s` | `12.3535x` | true |
| 5 | 5.48 | `0.022242s` | `0.002382s` | `9.3375x` | true |

Summary:

| Metric | Min | Max | Mean | Sample stdev |
| --- | ---: | ---: | ---: | ---: |
| Serial seconds | `0.021841` | `0.027597` | `0.023822` | `0.002590` |
| Parallel seconds | `0.001768` | `0.002382` | `0.001962` | `0.000249` |
| Ratio | `9.3375x` | `14.1814x` | `12.2760x` | `1.8093x` |

## Interpretation

Safe claims:

- The generic-lane packet is now captured with longer SMI/`hwlat` windows and
  five store-prebuilt Chapel repeats.
- All five Chapel repeats conform.
- SMI remains nonzero around `2.3/s` in this generic window.
- tracefs `hwlat` stayed at `0 us` max in these samples.
- Chapel ratio still varies materially under live lab load.

Unsafe claims:

- This is an idle benchmark.
- This proves generic is better than RT.
- This proves application or XoxDWM performance.
- This proves SMI has been fixed.

## Next packet

Superseded follow-up: the matching RT packet was captured later on
2026-04-26. See
[`honey-rt-host-characterization-window-2026-04-26.md`](honey-rt-host-characterization-window-2026-04-26.md)
and
[`honey-rt-chapel-repeat-2026-04-26.md`](honey-rt-chapel-repeat-2026-04-26.md).
The result is cautionary, not an RT improvement result.

Original matching command shape:

```bash
just platform-host-characterization-window \
  target=jess@honey \
  tag=rt-repeat-2026-04-26 \
  expect_lane=rt \
  smi_samples=3 \
  smi_duration=120 \
  hwlat_duration=120 \
  chapel_samples=5
```

After the RT packet, return to generic and validate the fallback lane before
making any publication claim.
