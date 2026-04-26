# Honey RT Host Characterization Window

Date: 2026-04-26

Host: `honey` / Dell Precision T7810

Kernel lane: PREEMPT_RT `6.19.5-rt1-8.xr.el10`, one-shot boot through
`next_entry`

Purpose: collect the matching RT-side long-window SMI/`hwlat` packet after the
generic 2026-04-26 host-characterization window, then attempt the matching
store-prebuilt Chapel repeat series.

## Result

This packet is useful, but it is not a completed generic-vs-RT Chapel repeat.

Completed:

- one-shot RT arm and boot
- RT lane confirmation
- three `120s` SMI samples
- three `120s` tracefs `hwlat` samples
- return to generic fallback
- generic baseline validation after return

Blocked:

- five-sample RT Chapel repeat series

The Chapel repeat blocked under RT host/SSH responsiveness before producing
`HostNumaProbe` output. A partial sample file is retained as evidence of the
blocked path.

## Evidence

Pre-RT and arm:

- `data/captures/honey/pre-rt-repeat-host-context-2026-04-26.txt`
- `data/captures/honey/kernel-lane-status-pre-rt-repeat-2026-04-26.txt`
- `data/captures/honey/kernel-lane-arm-rt-repeat-2026-04-26.txt`
- `data/captures/honey/reboot-command-rt-repeat-2026-04-26.txt`

RT lane:

- `data/captures/honey/kernel-lane-status-rt-repeat-2026-04-26.txt`
- `data/captures/honey/kernel-baseline-rt-repeat-2026-04-26.txt`
- `data/captures/honey/live-rt-cmdline-confirmation-2026-04-26.txt`
- `data/captures/honey/host-characterization-window-rt-repeat-2026-04-26.txt`

SMI / `hwlat` captures:

- `data/captures/honey/smi-validate-rt-repeat-2026-04-26-sample-01.txt`
- `data/captures/honey/smi-validate-rt-repeat-2026-04-26-sample-02.txt`
- `data/captures/honey/smi-validate-rt-repeat-2026-04-26-sample-03.txt`

Blocked Chapel capture:

- `data/captures/honey/chapel-host-probe-rt-repeat-2026-04-26-sample-01.txt`

Return to generic:

- `data/captures/honey/reboot-command-post-rt-repeat-return-generic-2026-04-26.txt`
- `data/captures/honey/kernel-lane-status-post-rt-repeat-return-generic-2026-04-26.txt`
- `data/captures/honey/kernel-baseline-post-rt-repeat-return-generic-2026-04-26.txt`
- `data/captures/honey/kernel-baseline-post-rt-repeat-return-generic-rerun-2026-04-26.txt`
- `data/captures/honey/post-rt-repeat-return-host-context-2026-04-26.txt`
- `data/captures/honey/post-rt-repeat-return-service-check-2026-04-26.txt`

## Host context

Pre-arm generic context:

- kernel: `6.19.5-7.xr.el10`
- `/sys/kernel/realtime`: absent
- loadavg: `2.18 2.88 2.61`
- `rke2-server`: active
- `next_entry`: empty

RT packet preflight:

- kernel: `6.19.5-rt1-8.xr.el10`
- `/sys/kernel/realtime`: `1`
- uptime: `178.50` seconds
- loadavg: `21.51 7.18 2.58`
- `next_entry`: empty
- `rke2-server`: active

The RT packet was not idle-host evidence. The high RT preflight load and later
SSH instability are part of the result.

## RT baseline and cmdline note

The RT baseline validator reported:

- base fragment: `30 / 30`
- RT overlay: `3 / 3`
- cmdline: `0 / 19`
- result: `FAIL`

That cmdline failure was contradicted by a direct live capture in
`live-rt-cmdline-confirmation-2026-04-26.txt`, which shows the RT boot did
include the expected tuned low-latency parameters:

- `tsc=nowatchdog`
- `clocksource=tsc`
- `nosoftlockup`
- `intel_pstate=disable`
- `processor.max_cstate=1`
- `intel_idle.max_cstate=0`
- `nmi_watchdog=0`
- `mce=ignore_ce`
- `idle=poll`
- `skew_tick=1`
- `transparent_hugepage=never`
- `nowatchdog`
- `rcu_nocb_poll`
- `nohz=on`
- `nohz_full=2-7`
- `rcu_nocbs=2-7`
- `kthread_cpus=0-1`
- `isolcpus=managed_irq,domain,2-7`
- `irqaffinity=0-1`

Interpret the RT validator output as a tooling robustness issue for this run,
not as proof that the RT cmdline was actually missing. The remote validator has
since been hardened to use bounded SSH options and to refuse empty fetched
config or cmdline files.

## SMI and hwlat samples

Each sample used a `120s` SMI counter window and a `120s` tracefs `hwlat`
window.

| Sample | Kernel | SMI count | Rate | tracefs hwlat max | tuned profile |
| --- | --- | ---: | ---: | ---: | --- |
| 1 | `6.19.5-rt1-8.xr.el10` | 279 / 120s | 2.3/s | 2 us | `t7810-low-latency` |
| 2 | `6.19.5-rt1-8.xr.el10` | 279 / 120s | 2.3/s | 2 us | `t7810-low-latency` |
| 3 | `6.19.5-rt1-8.xr.el10` | 278 / 120s | 2.3/s | 14 us | `t7810-low-latency` |

Comparison to the generic 2026-04-26 packet:

| Lane | SMI samples | tracefs hwlat max |
| --- | --- | --- |
| generic | 280, 279, 279 / 120s | 0, 0, 0 us |
| RT | 279, 279, 278 / 120s | 2, 2, 14 us |

Interpretation:

- RT did not reduce the nonzero SMI rate in this matched long-window packet.
- RT had one tracefs `hwlat` max above the `10 us` checklist threshold.
- This is still host-posture context, not an application or XR benchmark.

## Chapel repeat attempt

The Chapel store-prebuilt repeat did not complete. The partial capture stopped
before `HostNumaProbe` output:

- partial file:
  `data/captures/honey/chapel-host-probe-rt-repeat-2026-04-26-sample-01.txt`
- last recorded section: `== tuned-adm active ==`
- completed `HostNumaProbe`: no

The first failure mode was an unbounded plain SSH call inside
`capture-chapel-host-probe-store-on-target`. The helper was hardened with
bounded batch-mode SSH/SCP options. A second Chapel attempt still blocked under
RT responsiveness during remote staging, so the attempt was stopped and the
host was returned to generic.

Safe claim:

- RT SMI/`hwlat` long-window context is captured.
- RT Chapel repeat remains blocked under this boot.

Do not claim:

- a repeated RT Chapel distribution exists;
- RT improved Chapel timing;
- RT improved SMI behavior;
- RT is operationally acceptable for the full measurement workflow.

## Return to generic

The return reboot was accepted at `2026-04-26T18:22:52Z`. The host returned to:

- kernel: `6.19.5-7.xr.el10`
- `/sys/kernel/realtime`: absent
- default kernel: `/boot/vmlinuz-6.19.5-7.xr.el10`
- `next_entry`: empty
- generic baseline validation: `PASS`
- `rke2-server`: active after boot settle

## Writing posture

This packet strengthens the blog and paper stance, but not by creating an
improvement result. The sharper conclusion is:

- the long-window RT SMI rate matches generic almost exactly;
- RT had worse tracefs `hwlat` in one sample;
- RT responsiveness blocked the attempted repeated Chapel capture;
- the host returned safely to generic.

The public draft should remain unpublished unless it is framed as a negative
or cautionary host-characterization note rather than an RT optimization story.
