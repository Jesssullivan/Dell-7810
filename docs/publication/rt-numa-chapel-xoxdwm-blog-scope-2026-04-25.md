# RT, NUMA, Chapel, XoxDWM, And Blog Scope - 2026-04-25

Use this note as the current stance for paper, blog, and evening measurement
work around `honey`, PREEMPT_RT, SMI, NUMA, Chapel, XoxDWM, and
`jesssullivan.github.io`.

This is not a new measurement authority. Raw captures and projected records
remain in `data/captures/honey/`, `dhall/defaults/`, and the platform result
notes linked below.

## Cross-repo read

Recent XoxDWM docs are aligned with the Dell boundary:

| Surface | Current stance | Dell implication |
| --- | --- | --- |
| `XoxdWM/docs/status.md` | `honey` OpenXR direct-mode smoke is real but still `Smoke`; fresh boot, first-frame, and long-running stability are not proven. | Do not use XoxDWM smoke as RT benefit evidence. |
| `XoxdWM/docs/support-matrix.md` | Dell owns C1/C2/C3 host evidence; XoxDWM owns only C4 downstream software benefit. | Keep RT, SMI, hwlat, NUMA, BIOS, and Chapel host characterization here. |
| `XoxdWM/docs/remote-proof-lanes.md` | `just honey-openxr-fresh-boot-check` is a post-boot capture lane; it does not reboot `honey`. | Reboot planning and fallback stay Dell-owned. |
| `XoxdWM/docs/honey-substrate-proof-2026-04-22.md` | Installed XoxDWM + Monado + packaged OpenXR client can produce repeated clean service-cycle smoke. | Useful downstream context, not host timing proof. |
| `XoxdWM/docs/hygiene-minisprint-2026-04-25.md` | Fresh-boot repeatability is the next XoxDWM gate; `rke2` must not be a destructive-test lever. | Any RT reboot sequence must preserve return-to-generic and server safety. |

The blog draft in `../jesssullivan.github.io` was behind the Dell evidence: it
still framed RT Chapel capture as future work. That is no longer true. The
right frame is now:

- first paired generic/RT SMI + hwlat + Chapel packet exists;
- first paired packet is not an RT improvement result;
- two five-sample generic Chapel repeat packets exist and show material
  variance;
- the 2026-04-26 generic packet adds longer 120s SMI/hwlat windows;
- the 2026-04-26 RT packet adds matching 120s SMI/hwlat windows, but the
  Chapel repeat blocked under RT host/SSH responsiveness;
- XoxDWM C4 benefit remains future downstream evidence.

## Current measured state

Primary result notes:

- [`../platform/honey-rt-smi-hwlat-chapel-series-2026-04-25.md`](../platform/honey-rt-smi-hwlat-chapel-series-2026-04-25.md)
- [`../platform/honey-generic-chapel-repeat-series-2026-04-25.md`](../platform/honey-generic-chapel-repeat-series-2026-04-25.md)

First paired packet:

| Metric | Generic lane | RT lane | Interpretation |
| --- | ---: | ---: | --- |
| Kernel | `6.19.5-7.xr.el10` | `6.19.5-rt1-8.xr.el10` | paired one-shot lanes |
| SMI count | 73-74 / 30s | 65-74 / 30s | nonzero and similar magnitude |
| tracefs `hwlat` max | 0-2 us | 0-2 us | low in short windows |
| Chapel serial | 0.022323s | 0.022533s | RT slightly slower |
| Chapel parallel | 0.001807s | 0.001927s | RT slower in first pair |
| Chapel ratio | 12.3536x | 11.6933x | no RT win |
| Chapel conforms | true | true | method works on both lanes |

Generic repeat packet:

| Metric | Min | Max | Mean | Sample stdev |
| --- | ---: | ---: | ---: | ---: |
| Serial seconds | 0.021871 | 0.025839 | 0.023723 | 0.001885 |
| Parallel seconds | 0.001667 | 0.002431 | 0.001956 | 0.000302 |
| Ratio | 8.9967x | 14.0738x | 12.3491x | 1.9463x |

The generic repeat series was not idle-host evidence. The capture helper now
records uptime and `/proc/loadavg`; the recorded 1m load average rose from
7.98 to 10.05 across the five samples.

Second generic host-characterization window:

- result note:
  [`../platform/honey-generic-host-characterization-window-2026-04-26.md`](../platform/honey-generic-host-characterization-window-2026-04-26.md)
- SMI: `280/120s`, `279/120s`, `279/120s`
- tracefs `hwlat` max: `0 us` for all three 120s windows
- Chapel repeats: five conforming store-prebuilt captures
- Chapel ratio: min `9.3375x`, max `14.1814x`, mean `12.2760x`,
  sample stdev `1.8093x`

Matching RT host-characterization window:

- result note:
  [`../platform/honey-rt-host-characterization-window-2026-04-26.md`](../platform/honey-rt-host-characterization-window-2026-04-26.md)
- SMI: `279/120s`, `279/120s`, `278/120s`
- tracefs `hwlat` max: `2 us`, `2 us`, `14 us`
- Chapel repeat: blocked before `HostNumaProbe` under RT host/SSH
  responsiveness
- return to generic: validated, `rke2-server` active after boot settle

## Claim stance

Safe to say now:

- Dell has a reproducible host-characterization pipeline using Nix, Chapel,
  Dhall, `just`, and raw capture files.
- The same Chapel host probe conforms on the generic and RT kernel lanes.
- The first generic/RT pair is neutral-to-negative for RT timing benefit.
- SMI remains nonzero in short windows on both lanes.
- Longer 120s generic and RT SMI windows now show nearly identical nonzero SMI
  rates around `2.3/s`.
- Generic repeat captures show that single-pair timing prose would overstate
  the result.
- RT `hwlat` had one `14 us` sample in the 2026-04-26 packet, so the current
  RT posture is cautionary rather than improved.
- XoxDWM has useful OpenXR smoke evidence on `honey`, but not RT downstream
  benefit.

Do not say:

- RT improves Chapel timing on `honey`.
- RT improves SMI behavior on `honey`.
- Chapel proves application performance.
- XoxDWM proves C4 RT software benefit.
- Runner/cache proof is live host evidence.

## Blog posture

The `jesssullivan.github.io` Chapel/RT draft should remain unpublished until
the Chapel repeat blocker is resolved or the post is intentionally framed as a
negative/cautionary host-characterization note.

Required shape for a technical audience:

1. result card first;
2. exact evidence paths before narrative;
3. generic/RT paired table;
4. generic repeat table;
5. claim boundary;
6. next measurement packet;
7. only then the Chapel/PBT method narrative.

Good first public title direction:

- "Characterizing a Dual-Socket BCI Server Before Claiming RT Wins"

Avoid title direction:

- "10x Chapel speedup"
- "RT optimized my workstation"
- "Chapel proves NUMA scheduling"

## Evening measurement plan

Do not turn this into a broad host experiment. The next useful packet is narrow
and paired.

1. Start on safe generic default and record:
   - kernel status;
   - uptime and load;
   - active lab workload notes;
   - SMI/hwlat series with longer windows if time allows;
   - store-prebuilt Chapel repeat series.
   - preferred helper:
     `just platform-host-characterization-window target=jess@honey tag=generic-repeat-2026-04-26 expect_lane=generic smi_samples=3 smi_duration=120 hwlat_duration=120 chapel_samples=5`
2. Schedule one attended one-shot RT boot only if fallback is clear:
   - persistent default remains generic;
   - next boot only selects RT;
   - return-to-generic validation is part of the packet, not cleanup theater.
3. On RT, record the same shape:
   - kernel status;
   - uptime and load;
   - SMI/hwlat series;
   - store-prebuilt Chapel repeat series;
   - recovery time and operator notes.
   - the 2026-04-26 RT run completed SMI/hwlat but blocked during the Chapel
     repeat, so the next RT iteration should either run Chapel through a more
     robust staging path or explicitly declare the run SMI/hwlat-only
   - follow-up hardening now bounds the Chapel capture metadata, compile, and
     probe phases; the next RT boot should start with Chapel-only repeat
     capture rather than rerunning the full SMI/hwlat packet
4. Return to generic and validate:
   - default BLS entry;
   - `/sys/kernel/realtime` absent;
   - kernel baseline validator;
   - `rke2` status if the host is still serving control-plane work.
5. Only after host evidence is calm, optionally run XoxDWM's fresh-boot check:
   - `just honey-openxr-fresh-boot-check honey 1 20`
   - this belongs to XoxDWM C4 staging, not Dell C1/C2/C3 proof.

## Exact next gaps

| Gap | Owner surface | Why it matters |
| --- | --- | --- |
| Matching RT Chapel repeat series | Dell-7810 / `TIN-600` | Still needed; the 2026-04-26 repeat blocked before `HostNumaProbe`, and the next attempt should use the hardened Chapel-only repeat path. |
| Longer generic and RT SMI/hwlat windows | Dell-7810 / `TIN-598` | Captured for one generic and one RT packet; current result is similar SMI rate and one RT `hwlat` threshold crossing. |
| Fresh PBT run output | Dell-7810 / `TIN-599` | Needed for paper tables that cite live pass output, not only source inspection. |
| XoxDWM fresh-boot OpenXR check | XoxDWM / `TIN-346` | Needed for runtime repeatability, not RT benefit by itself. |
| XoxDWM under RT | XoxDWM C4 follow-up | Needed only after Dell host RT evidence is acceptable. |

## Writing split

| Output | Status | Best next action |
| --- | --- | --- |
| Methods note: Chapel/PBT host characterization | Draftable | Use source, PBT matrix, and generic/RT first packet without claiming RT benefit. |
| Results note: generic vs RT host posture | Staging-ready as cautionary note | Use the matching SMI/hwlat packets, but keep Chapel repeat blocked and RT improvement unclaimed. |
| Blog post | Keep draft | Update with first-packet negative/neutral stance and leave unpublished. |
| Paper | Outline only | Use this as a methods-plus-measurement scaffold after repeat packets. |
| XoxDWM C4 note | Not ready | Needs fresh-boot runtime proof and later RT runtime comparison. |
