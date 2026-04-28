# Honey Generic Chapel Repeat Series

Date: 2026-04-25

Host: `honey` / Dell Precision T7810

Kernel lane: generic `6.19.5-7.xr.el10`, `/sys/kernel/realtime` absent

Purpose: add a small repeatability packet for the Chapel host probe while
`honey` is safely on the generic fallback lane.

## Evidence

- `data/captures/honey/chapel-host-probe-generic-repeat-2026-04-25-sample-01.txt`
- `data/captures/honey/chapel-host-probe-generic-repeat-2026-04-25-sample-02.txt`
- `data/captures/honey/chapel-host-probe-generic-repeat-2026-04-25-sample-03.txt`
- `data/captures/honey/chapel-host-probe-generic-repeat-2026-04-25-sample-04.txt`
- `data/captures/honey/chapel-host-probe-generic-repeat-2026-04-25-sample-05.txt`

All five captures used the store-prebuilt Chapel 2.8.0 path on `honey`, so the
timing windows did not include building Chapel on the target.

The capture helper now records `uptime` and `/proc/loadavg` because host load is
part of the interpretation surface for these measurements.

## Results

| Sample | 1m loadavg | Serial | Parallel | Ratio | Conforms |
| --- | ---: | ---: | ---: | ---: | --- |
| 1 | 7.98 | `0.025488s` | `0.001950s` | `13.0708x` | true |
| 2 | 8.17 | `0.021957s` | `0.001724s` | `12.7361x` | true |
| 3 | 8.40 | `0.023461s` | `0.001667s` | `14.0738x` | true |
| 4 | 9.17 | `0.025839s` | `0.002008s` | `12.8680x` | true |
| 5 | 10.05 | `0.021871s` | `0.002431s` | `8.9967x` | true |

Summary:

| Metric | Min | Max | Mean | Sample stdev |
| --- | ---: | ---: | ---: | ---: |
| Serial seconds | `0.021871` | `0.025839` | `0.023723` | `0.001885` |
| Parallel seconds | `0.001667` | `0.002431` | `0.001956` | `0.000302` |
| Ratio | `8.9967x` | `14.0738x` | `12.3491x` | `1.9463x` |

## Interpretation

Safe claims:

- The store-prebuilt generic Chapel probe is repeatable enough to run in a
  short series without target-side compiler builds.
- All five generic repeats conformed.
- The ratio varies materially under current lab load, especially in sample 5.

Unsafe claims:

- This is an idle benchmark.
- This is an RT comparison.
- The five-sample series is enough to model the full variance distribution.
- The ratio is application performance.

The useful finding is that repeated captures are necessary before paper/blog
wording talks about timing deltas. A single generic/RT pair is too thin.

## Next packet

Collect the same five-sample series on the RT lane during a controlled one-shot
boot, then compare distributions instead of single captures.
