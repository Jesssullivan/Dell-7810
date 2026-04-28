# RT Necessity Analysis - 2026-04-26

## Scope

This note answers a strategic question: should `honey` treat PREEMPT_RT as a
requirement for its BCI/XR workload today, or should the generic low-latency
kernel lane remain the default while downstream deadlines are measured?

This is not a new measurement. It synthesizes the measured evidence from the
Dell-7810 characterization campaign with external research on RT kernel behavior
for GPU, audio, and mixed workloads.

Related evidence:

- [`../platform/rt-research-contract.md`](../platform/rt-research-contract.md)
  (claim ladder)
- [`../platform/honey-rt-chapel-repeat-2026-04-26.md`](../platform/honey-rt-chapel-repeat-2026-04-26.md)
  (negative RT Chapel result)
- [`../platform/honey-rt-host-characterization-window-2026-04-26.md`](../platform/honey-rt-host-characterization-window-2026-04-26.md)
  (RT SMI/hwlat packet)
- [`../publication/rt-numa-chapel-xoxdwm-blog-scope-2026-04-25.md`](../publication/rt-numa-chapel-xoxdwm-blog-scope-2026-04-25.md)
  (blog scope and claim stance)
- [`../publication/rt-benefit-decision-framework-2026-04-26.md`](../publication/rt-benefit-decision-framework-2026-04-26.md)
  (downstream proof packet templates for audio/BCI, XR, and graphics)

## The workload

`honey` runs a mixed workload that combines several latency-sensitive and
throughput-sensitive concerns on the same host:

| Component | Latency profile | Throughput profile |
| --- | --- | --- |
| OpenXR / Monado | Frame timing: ~11ms budget at 90 Hz | GPU command submission, reprojection shaders |
| Bigscreen Beyond headset | Display link timing via DP-2 (DSC, DRM lease) | 5088x2544 pixel data at refresh rate |
| AMD RX 9070 XT (RDNA 4) | GPU interrupt response, DMA buffer management | Sustained compute for XR rendering |
| Audio IO (BCI signal path) | Buffer underruns at low sample counts | Continuous streaming at acquisition rate |
| Chapel host probes | Bounded parallel reduction timing | NUMA-aware forall across 32 threads |
| RKE2 Kubernetes | API server responsiveness | Container orchestration, etcd consensus |

The question is whether PREEMPT_RT helps the latency-sensitive components
enough to justify its cost to the throughput-sensitive components.

## Measured evidence on `honey`

### RT did not improve Chapel parallel timing

The 2026-04-26 hardened RT Chapel repeat produced five conforming samples, but
the distribution is worse than the matching generic repeat:

| Lane | Ratio mean | Ratio stdev | Parallel mean |
| --- | ---: | ---: | ---: |
| Generic repeat | 12.2760x | 1.8093x | 0.001962s |
| RT repeat | 9.3204x | 4.6220x | 0.005033s |

RT parallel mean was 2.6x slower. RT variance was 2.6x higher. One RT sample
(sample 2) collapsed to a 1.3617x ratio with a 16.977ms parallel time, while
serial timing was essentially unchanged. This pattern is compatible with
scheduler, IRQ, lock, cache, or lab-load effects hitting the parallel phase
more than the serial phase. It is not enough by itself to assign causality.

### RT did not improve SMI behavior

The 2026-04-26 120s windows show nearly identical nonzero SMI rates:

| Lane | SMI per 120s | Rate |
| --- | --- | ---: |
| Generic | 280, 279, 279 | ~2.33/s |
| RT | 279, 279, 278 | ~2.32/s |

SMI activity is firmware-generated. PREEMPT_RT does not change firmware
behavior; it only changes how the kernel handles interrupts after they arrive.

### RT introduced a hardware latency threshold crossing

Generic tracefs `hwlat` stayed at 0 us max across all three 120s windows.
RT `hwlat` recorded 2, 2, and 14 us. The 14 us sample crosses the 10 us
operational checklist threshold and is a cautionary signal, not an improvement.

### RT recovery cost is high

Boot-to-SSH recovery is slower under RT. The 2026-04-26 RT boot took multiple
minutes of bounded SSH polling before the host responded, compared to faster
generic recovery. Display transients and Tailscale reconnection add operator
cost.

## External research

Primary/current sources checked for this analysis:

- Linux kernel PREEMPT_RT theory:
  <https://docs.kernel.org/core-api/real-time/theory.html>
- Linux kernel realtime differences:
  <https://docs.kernel.org/core-api/real-time/differences.html>
- Linux kernel hardware latency detector:
  <https://docs.kernel.org/trace/hwlat_detector.html>
- OpenXR `XrFrameState`:
  <https://registry.khronos.org/OpenXR/specs/1.1/man/html/XrFrameState.html>
- Monado frame pacing / timing:
  <https://monado.pages.freedesktop.org/monado/frame-pacing.html>
- PipeWire runtime and latency controls:
  <https://docs.pipewire.org/devel/page_man_pipewire_1.html>
- ALSA PCM interface:
  <https://www.alsa-project.org/alsa-doc/alsa-lib/pcm.html>
- JACK latency API:
  <https://jackaudio.org/api/group__LatencyFunctions.html>
- AMD Radeon RX 9000 series quick reference:
  <https://www.amd.com/content/dam/amd/en/documents/partner-hub/radeon/radeon-rx-9000-series-quick-reference-guide-non-competitive.pdf>
- Bigscreen Beyond display technology:
  <https://store.bigscreenvr.com/en-nz/blogs/beyond/development-update-10>
- Bigscreen Beyond 2e dynamic foveated rendering:
  <https://store.bigscreenvr.com/en-jp/blogs/beyond/dynamic-foveated-rendering-with-bigscreen-beyond-2e>

### GPU and OpenXR

The source-grounded point is narrower than "RT helps VR." OpenXR exposes frame
timing through values such as predicted display time and predicted display
period, and Monado's frame-pacing docs describe a pipeline of application wake,
render, compositor submit, present, and display. A useful RT claim therefore
needs frame-timing evidence from that pipeline.

The AMD RX 9000 quick reference confirms the RX 9070 XT display and throughput
capability surface: RDNA 4, DisplayPort 2.1a, HDMI 2.1b, 16 GB GDDR6, and 304 W
board power. Those are GPU/display facts, not RT facts.

Bigscreen's display notes explain why display-path evidence matters: Beyond
operates at 2560x2560 per eye at 75Hz and 90Hz, with DSC/upscaling nuance at
90Hz. Beyond 2e adds eyetracking and dynamic foveated rendering, which is
primarily a GPU workload-shaping feature. These are not fixed by RT unless a
measured CPU scheduling deadline is the bottleneck.

### Audio IO and BCI signal acquisition

PREEMPT_RT can be relevant to audio or BCI I/O when the failure mode is a
missed wakeup for a high-priority thread. ALSA and PipeWire make this a
measurement problem: period size, buffer size, quantum, xrun count, and
round-trip latency have to be recorded.

The next evidence should therefore be an audio/BCI packet, not another generic
"RT is faster" packet. Capture the interface, sample rate, period/buffer or
PipeWire quantum, xrun count, deadline misses, and concurrent host load on
both lanes before claiming either kernel is sufficient.

### Buffer management under mixed workloads

PREEMPT_RT changes lock and interrupt behavior so more work is scheduler
controlled. That is exactly why it can help a high-priority deadline thread,
and exactly why it can also perturb a mixed workload. For `honey`, any claim
about Kubernetes, GPU work, or audio must be measured on that workload rather
than inferred from kernel flavor.

### Chapel and NUMA under RT

The measured RT Chapel degradation is a local result, not a universal Chapel
or RT claim. The safe interpretation is that the current RT lane did not
improve this NUMA-aware characterization probe and introduced a severe
parallel outlier. A follow-up would need scheduler traces, IRQ-thread state,
CPU affinity, load isolation, and repeated runs before assigning a specific
mechanism.

## Alternatives to PREEMPT_RT

`honey` already has several of these tunings applied via the `linux-xr` cmdline
and the `t7810-low-latency` tuned profile:

| Technique | Status on `honey` | Effect |
| --- | --- | --- |
| `isolcpus` | applied | Removes dedicated cores from scheduler load balancing |
| `nohz_full` | applied | Suppresses timer interrupts on isolated cores |
| `irqaffinity` | applied | Keeps hardware interrupts off isolated cores |
| `tsc=nowatchdog` | applied | Stable TSC without watchdog overhead |
| `intel_pstate=passive` | applied | Passive governor for frequency stability |
| `processor.max_cstate=1` | applied | Limits C-state depth |
| `SCHED_FIFO` / `SCHED_DEADLINE` | available | RT scheduling policies on generic kernel |
| `mlockall()` | available | Prevents page faults by locking memory |
| `CPU affinity` | available | Pins specific processes to specific cores |
| cgroups v2 | available (via RKE2) | Dynamic CPU/memory isolation, K8s native |

The combination of `isolcpus` + `nohz_full` + `irqaffinity` + real-time
scheduling policy on the generic kernel is the better default hypothesis for
now because:

1. it keeps the measured, safer generic lane as the default;
2. it can be tested with audio/BCI deadline packets before rebooting into RT;
3. it avoids treating firmware SMI behavior as a kernel-preemption problem;
4. it keeps XR/display work focused on frame timing, DSC, and compositor
   behavior.

## Strategic recommendation

### RT is not justified as the default requirement yet

The current evidence points away from treating PREEMPT_RT as a default
requirement:

1. **Measured Chapel result is negative**: RT degraded this host-probe's
   parallel timing and increased variance. This is a strong local measurement,
   but it remains a host-characterization workload, not a downstream BCI or XR
   runtime result.

2. **SMI behavior is unchanged**: RT does not reduce firmware-generated SMIs.
   The nonzero SMI rate is a firmware characteristic, not a kernel scheduling
   problem.

3. **hwlat crossed a threshold under RT**: The generic kernel had cleaner
   hardware latency behavior in the measured windows.

4. **GPU/VR timing needs its own packet**: OpenXR/Monado frame timing,
   page-flip/vblank, display mode, and compositor evidence are the relevant
   signals.

5. **Audio/BCI timing needs its own packet**: period, buffer, quantum, xrun,
   and missed-deadline evidence are the relevant signals.

### RT remains valuable as a characterization and fallback lane

The RT evidence is not wasted. It serves the claim ladder:

- **C0-C2 are established**: RT boots, validates, and returns cleanly. This
  proves the host can run RT if a future workload demonstrates that it needs
  RT semantics.
- **C3 is cautionary**: The operational cost is documented and honest.
- **C4 is not pursued**: There is no evidence that downstream XR or BCI
  software benefits from RT on this hardware.

The RT characterization campaign produced a defensible negative result: the
host was tested, the result was captured, and the conclusion is grounded.

### Recommended posture

1. **Generic lane remains the production default** for `honey`.
2. **RT lane remains available** for future experiments if a specific workload
   demonstrates a need.
3. **Publication should frame RT as characterization, not optimization**: the
   measured result is a cautionary/negative packet, suitable for a methods-and-
   measurement writeup.
4. **Targeted isolation** (`isolcpus` + real-time policy + IRQ affinity) should
   be tested before making PREEMPT_RT necessary for audio/BCI threads.
5. **GPU frame timing** should be addressed through XoxDWM/Monado frame
   packets, not kernel-preemption prose.
6. **Future RT work** should be motivated by a specific measured latency failure
   on the generic kernel, not by the assumption that RT is always better.

## What this changes for open issues

| Issue | Current status | Recommended update |
| --- | --- | --- |
| TIN-600 (RT Chapel repeat) | Captured; negative/cautionary | Move toward done for the host-probe question; open a separate downstream packet if audio/BCI or XR needs RT |
| TIN-598 (longer SMI/hwlat) | Captured for one generic + one RT packet | Keep open only if a BIOS-side SMI mitigation is being investigated |
| TIN-599 (fresh PBT run) | Needed for paper | Still needed; independent of RT decision |
| TIN-346 (XoxdWM fresh-boot) | Not captured | Still needed for XoxdWM C4; independent of RT |
| TIN-396 (fan/airflow) | Planned | Independent of RT; proceed on its own timeline |
| TIN-337 (warm-reboot) | Backlog | Relevant to understanding display recovery, not RT specifically |

## Claim boundary for this analysis

Safe claims:

- The measured RT evidence on `honey` does not support treating PREEMPT_RT as
  a current requirement for the BCI/XR workload.
- The generic lane with existing cmdline tuning is the stronger production
  posture for a mixed GPU + audio + Chapel + Kubernetes workload.
- Targeted core isolation is the next lower-risk hypothesis for audio/BCI
  deadline tests.
- The RT characterization campaign produced a useful negative result.

Unsafe claims:

- RT can never help on this hardware (it might, under a different workload or
  with quieter lab conditions).
- The generic kernel is sufficient for all latency-sensitive workloads (it has
  not been tested at sub-128-sample audio buffer sizes).
- This analysis applies to other hardware or other BCI systems.
