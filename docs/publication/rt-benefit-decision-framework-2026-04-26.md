# RT Benefit Decision Framework - 2026-04-26

Use this note before making any public claim that PREEMPT_RT is necessary or
beneficial for `honey`, the Dell Precision T7810 BCI/XR host.

The current result is cautionary: RT is available, bootable, and measurable,
but it should not be the default engineering answer until a downstream
workload proves that it needs RT semantics.

## Current measured position

Canonical Dell evidence:

- [`../platform/honey-generic-host-characterization-window-2026-04-26.md`](../platform/honey-generic-host-characterization-window-2026-04-26.md)
- [`../platform/honey-rt-host-characterization-window-2026-04-26.md`](../platform/honey-rt-host-characterization-window-2026-04-26.md)
- [`../platform/honey-rt-chapel-repeat-2026-04-26.md`](../platform/honey-rt-chapel-repeat-2026-04-26.md)
- [`../tracking/measured-evidence-map.md`](../tracking/measured-evidence-map.md)
- [`../research/rt-necessity-analysis-2026-04-26.md`](../research/rt-necessity-analysis-2026-04-26.md)

Measured result:

| Surface | Generic lane | RT lane | Interpretation |
| --- | ---: | ---: | --- |
| SMI count | `280`, `279`, `279` per `120s` | `279`, `279`, `278` per `120s` | RT did not reduce SMI rate |
| tracefs `hwlat` max | `0 us`, `0 us`, `0 us` | `2 us`, `2 us`, `14 us` | RT had one worse hardware-latency sample |
| Chapel repeat conformance | `5 / 5` | `5 / 5` | method works on both lanes |
| Chapel ratio mean | `12.2760x` | `9.3204x` | RT was lower in this packet |
| Chapel ratio sample stdev | `1.8093x` | `4.6220x` | RT was more variable |
| Severe Chapel parallel outlier | none in 2026-04-26 generic packet | sample 2 collapsed to `1.3617x` | treat as signal, not noise |

Decision today:

- keep the generic `linux-xr` lane as the default operating lane;
- keep RT installed and measurable as an experimental lane;
- do not describe RT as necessary for the BCI/XR stack yet;
- shift the next claims toward workload deadlines, buffering, frame pacing, and
  audio/xrun evidence.

## What RT plausibly helps

PREEMPT_RT changes Linux by making more kernel execution preemptible, replacing
some locking behavior with priority-inheritance-aware locks, and forcing many
interrupt handlers into scheduler-controlled threads. The plausible win is
therefore narrower than "the system is faster":

| Workload surface | Plausible RT mechanism | Required local proof |
| --- | --- | --- |
| High-priority BCI ingest loop | lower wakeup latency for a real-time thread that must service fixed-rate sensor data | timestamped callback lateness or missed-period histogram on generic vs RT |
| Audio interface / AD-DA path | fewer missed wakeups when running small periods or low PipeWire/JACK quantum | xrun count, period size, buffer size, round-trip latency, and CPU/load context |
| XR compositor CPU wakeup | tighter CPU-side wakeup relative to predicted display time | `xrWaitFrame` / compositor frame timing histogram and missed-frame count |
| Threaded IRQ prioritization | ability to prioritize relevant device IRQ threads over background work | IRQ-thread priorities, IRQ affinity, and before/after deadline misses |

None of these are established by the current Chapel host probe alone. The
Chapel probe is a host-characterization packet; it is not an audio, display, or
XR runtime benchmark.

## What RT probably does not solve

| Surface | Why RT is not the first explanation |
| --- | --- |
| SMI behavior | SMI is firmware/BIOS-owned and is explicitly outside Linux servicing; the current generic and RT packets show nearly identical SMI rates |
| `hwlat` firmware spikes | `hwlat` detects hardware/firmware interruptions, not ordinary scheduler delay; the current RT packet had the worse max sample |
| RX 9070 XT rendering throughput | GPU shader/raster/compute throughput, VRAM bandwidth, display-engine behavior, and driver work submission are not made faster by RT by default |
| Bigscreen display bandwidth / DSC | display mode, DSC, DisplayID parsing, link bandwidth, and panel refresh are graphics/display-pipeline questions |
| BCI goggles visual comfort | headset refresh, frame pacing, optical fit, foveated rendering, and dropped frames matter more directly than generic kernel RT status |
| Audio I/O latency budget | period size, buffer size, PipeWire quantum, JACK latency accounting, interface firmware, and xruns must be measured before blaming kernel preemption |
| Application buffer design | queues, backpressure, batching, timestamps, and clock-domain conversion can dominate latency even on a good kernel |

## Source-grounded reasoning

Primary/current sources checked:

- Linux kernel PREEMPT_RT theory:
  <https://docs.kernel.org/core-api/real-time/theory.html>
- Linux kernel realtime differences:
  <https://docs.kernel.org/core-api/real-time/differences.html>
- Linux kernel hardware latency detector:
  <https://docs.kernel.org/trace/hwlat_detector.html>
- Linux kernel real-time group scheduling:
  <https://docs.kernel.org/scheduler/sched-rt-group.html>
- OpenXR `XrFrameState`:
  <https://registry.khronos.org/OpenXR/specs/1.1/man/html/XrFrameState.html>
- Monado frame pacing / timing:
  <https://monado.pages.freedesktop.org/monado/frame-pacing.html>
- PipeWire configuration and latency controls:
  <https://docs.pipewire.org/devel/page_man_pipewire_1.html>
- ALSA PCM interface:
  <https://www.alsa-project.org/alsa-doc/alsa-lib/pcm.html>
- JACK latency API:
  <https://jackaudio.org/api/group__LatencyFunctions.html>
- AMD Radeon RX 9000 series quick reference:
  <https://www.amd.com/content/dam/amd/en/documents/partner-hub/radeon/radeon-rx-9000-series-quick-reference-guide-non-competitive.pdf>
- Bigscreen Beyond display technology:
  <https://store.bigscreenvr.com/en-nz/blogs/beyond/development-update-10>
- Bigscreen Beyond 2 / 2e announcement:
  <https://store.bigscreenvr.com/en-jp/blogs/beyond/introducing-bigscreen-beyond-2>
- Bigscreen Beyond 2e dynamic foveated rendering note:
  <https://store.bigscreenvr.com/en-jp/blogs/beyond/dynamic-foveated-rendering-with-bigscreen-beyond-2e>

Implications for this repo:

1. RT can reduce scheduler-controlled latency, especially for high-priority
   tasks and threaded interrupts.
2. RT does not claim ownership over firmware SMI behavior.
3. XR evidence should be expressed as frame timing and missed-deadline evidence,
   not as generic "RT is faster" prose.
4. Audio evidence should be expressed as period/buffer/quantum/xrun evidence,
   not as kernel flavor preference.
5. GPU/display evidence should be expressed as display mode, DSC, vblank,
   page-flip, frame pacing, and render workload evidence.

## Downstream proof packets

### Audio / BCI I/O packet

Owner: Dell for host preconditions, downstream audio/BCI repo for application
benefit.

Minimum capture:

- active kernel lane;
- interface name and sample rate;
- PipeWire or JACK buffer/period/quantum settings;
- xrun count over a fixed duration;
- round-trip latency if a loopback path exists;
- concurrent load average and IRQ affinity;
- whether BCI ingest deadlines were missed.

Safe claim shape:

> Under identical buffer and period settings, this workload missed fewer
> deadlines on lane X than lane Y.

Unsafe claim shape:

> RT is needed for audio or BCI because RT exists.

### XR / compositor frame packet

Owner: `XoxdWM`.

Minimum capture:

- Dell host packet hash or commit;
- active kernel lane;
- OpenXR runtime and compositor versions;
- `xrWaitFrame` predicted display time / period data where available;
- compositor wake, submit, present, and display timing where available;
- dropped / discarded frame counts;
- GPU/display mode and Bigscreen connector evidence;
- whether frame misses correlate with CPU scheduling, GPU render time, or
  display-link behavior.

Safe claim shape:

> With the same Dell host preconditions, XoxdWM reduced missed frame deadlines
> from A to B under lane X.

Unsafe claim shape:

> Dell Chapel timing proves XoxdWM will benefit from RT.

### Graphics / Bigscreen / RX 9070 XT packet

Owner split:

- `linux-xr` owns kernel carry, package, DSC/DisplayID patch surfaces, and
  upstream-watch.
- Dell owns durable host connector captures.
- `XoxdWM` owns runtime/compositor behavior.

Minimum capture:

- exact GPU and connector state;
- display mode and refresh;
- DSC / DisplayID parser evidence;
- DRM lease or direct-mode status;
- vblank/page-flip/frame timing evidence;
- application frame timing.

Safe claim shape:

> The display path is correctly identified and the compositor can sustain the
> target frame cadence under measured conditions.

Unsafe claim shape:

> RT fixes display bandwidth, DSC, or GPU throughput.

## Writing stance

The blog post in `../jesssullivan.github.io` should remain a draft until it
can lead with either:

1. a cautionary result note showing that RT did not improve the current host
   packet, or
2. a downstream packet showing a concrete audio, BCI, or XR deadline benefit.

Current best title direction:

> Characterizing a Dual-Socket BCI Server Before Claiming RT Wins

Current best thesis:

> RT is a hypothesis, not the conclusion. The useful work is the evidence
> pipeline that tells us when RT, buffering, frame pacing, or firmware work is
> the real bottleneck.

## Next actions

| Priority | Action | Owner surface |
| --- | --- | --- |
| P0 | Keep generic as the operational default until C4 evidence exists | Dell-7810 |
| P0 | Update publication figures and matrices to show the RT repeat as captured and cautionary | Dell-7810 |
| P1 | Draft an audio/BCI I/O packet template with period, buffer, quantum, xrun, and deadline fields | Dell-7810 first, downstream consumer later |
| P1 | Draft an XoxDWM C4 frame-timing packet template | XoxDWM |
| P1 | Keep `linux-xr` wording supplier-only: package/carry semantics, not Dell host acceptance | linux-xr |
| P2 | Re-run RT only when a specific downstream packet needs it | Dell-7810 + consumer repo |
