# Honey RT Chapel Repeat

Date: 2026-04-26

Host: `honey` / Dell Precision T7810

Kernel lane: PREEMPT_RT `6.19.5-rt1-8.xr.el10`, one-shot boot through
`next_entry`

Purpose: collect the missing repeated RT Chapel host-probe distribution after
the earlier 2026-04-26 RT SMI/`hwlat` packet completed but blocked before
`HostNumaProbe`.

## Result

The hardened Chapel-only repeat completed. All five RT samples conformed, but
the distribution does not support an RT improvement claim.

| Sample | 1m loadavg | Serial | Parallel | Ratio | Conforms |
| --- | ---: | ---: | ---: | ---: | --- |
| 1 | 10.90 | `0.022157s` | `0.001810s` | `12.2414x` | true |
| 2 | 13.27 | `0.023117s` | `0.016977s` | `1.3617x` | true |
| 3 | 17.15 | `0.023178s` | `0.002349s` | `9.8672x` | true |
| 4 | 17.38 | `0.023715s` | `0.002302s` | `10.3019x` | true |
| 5 | 18.33 | `0.022144s` | `0.001726s` | `12.8297x` | true |

Summary:

| Metric | Min | Max | Mean | Sample stdev |
| --- | ---: | ---: | ---: | ---: |
| Serial seconds | `0.022144` | `0.023715` | `0.022862` | `0.000690` |
| Parallel seconds | `0.001726` | `0.016977` | `0.005033` | `0.006683` |
| Ratio | `1.3617x` | `12.8297x` | `9.3204x` | `4.6220x` |

Comparison to the generic 2026-04-26 repeat:

| Lane | Serial mean | Parallel mean | Ratio mean | Ratio stdev |
| --- | ---: | ---: | ---: | ---: |
| generic | `0.023822s` | `0.001962s` | `12.2760x` | `1.8093x` |
| RT | `0.022862s` | `0.005033s` | `9.3204x` | `4.6220x` |

Interpretation:

- RT serial timing was slightly lower on average in this packet.
- RT parallel timing was much noisier because sample 2 was a severe outlier.
- RT ratio mean was lower and variance was higher than the matching generic
  repeat.
- This is a useful negative/cautionary packet, not an optimization result.

## Evidence

Pre-RT and arm:

- `data/captures/honey/pre-rt-chapel-repeat-host-context-2026-04-26.txt`
- `data/captures/honey/kernel-lane-status-pre-rt-chapel-repeat-2026-04-26.txt`
- `data/captures/honey/kernel-lane-arm-rt-chapel-repeat-2026-04-26.txt`
- `data/captures/honey/kernel-lane-status-armed-rt-chapel-repeat-2026-04-26.txt`
- `data/captures/honey/reboot-command-rt-chapel-repeat-2026-04-26.txt`

RT lane:

- `data/captures/honey/kernel-lane-status-rt-chapel-repeat-2026-04-26.txt`
- `data/captures/honey/rt-chapel-repeat-host-context-2026-04-26.txt`
- `data/captures/honey/kernel-lane-status-rt-chapel-repeat-post-capture-2026-04-26.txt`
- `data/captures/honey/rt-chapel-repeat-post-capture-host-context-2026-04-26.txt`

RT Chapel captures:

- `data/captures/honey/chapel-host-probe-rt-chapel-repeat-2026-04-26-sample-01.txt`
- `data/captures/honey/chapel-host-probe-rt-chapel-repeat-2026-04-26-sample-02.txt`
- `data/captures/honey/chapel-host-probe-rt-chapel-repeat-2026-04-26-sample-03.txt`
- `data/captures/honey/chapel-host-probe-rt-chapel-repeat-2026-04-26-sample-04.txt`
- `data/captures/honey/chapel-host-probe-rt-chapel-repeat-2026-04-26-sample-05.txt`

Projected Chapel records:

- `dhall/defaults/honey-chapel-host-probe-rt-chapel-repeat-2026-04-26-sample-01.dhall`
- `dhall/defaults/honey-chapel-host-probe-rt-chapel-repeat-2026-04-26-sample-02.dhall`
- `dhall/defaults/honey-chapel-host-probe-rt-chapel-repeat-2026-04-26-sample-03.dhall`
- `dhall/defaults/honey-chapel-host-probe-rt-chapel-repeat-2026-04-26-sample-04.dhall`
- `dhall/defaults/honey-chapel-host-probe-rt-chapel-repeat-2026-04-26-sample-05.dhall`

Return to generic:

- `data/captures/honey/reboot-command-post-rt-chapel-repeat-return-generic-2026-04-26.txt`
- `data/captures/honey/kernel-lane-status-post-rt-chapel-repeat-return-generic-2026-04-26.txt`
- `data/captures/honey/kernel-baseline-post-rt-chapel-repeat-return-generic-2026-04-26.txt`
- `data/captures/honey/post-rt-chapel-repeat-return-host-context-2026-04-26.txt`
- `data/captures/honey/post-rt-chapel-repeat-return-service-check-2026-04-26.txt`

## Command

After one-shot RT boot and RT confirmation:

```bash
bash scripts/platform/capture-chapel-host-probe-series-store-on-target \
  --target ${DELL_7810_TARGET} \
  --tag rt-chapel-repeat-2026-04-26 \
  --samples 5 \
  --output-dir data/captures/honey
```

The capture used the hardened store-prebuilt path:

- metadata timeout: `20s`
- remote compile timeout: `120s`
- remote probe timeout: `60s`

No sample recorded a `command_status: timeout_or_error` marker.

## Return State

The host was rebooted back to the saved generic fallback after capture.

- kernel: `6.19.5-7.xr.el10`
- `/sys/kernel/realtime`: absent
- generic baseline validation: `PASS`
- overlay network service: active
- `rke2-server`: active after boot settle

## Claim Boundary

Safe claims:

- The repeated RT Chapel distribution now exists.
- All five RT Chapel samples conform.
- The RT distribution has a severe parallel outlier and higher variance than
  the matching generic distribution.
- The matched 2026-04-26 evidence is neutral-to-negative for RT as a Chapel
  host-characterization timing improvement.

Unsafe claims:

- RT improves Chapel timing on `honey`.
- RT improves SMI behavior.
- RT improves downstream XR or XoxDWM behavior.
- The result is an idle benchmark.

This packet is suitable for a negative-results or methods-and-measurement
writeup. It should not be presented as an optimization win.
