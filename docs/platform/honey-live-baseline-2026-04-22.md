# Honey Live Baseline -- 2026-04-22

Owner issue: `TIN-397`

This note records the first bounded Dell-repo live host baseline after the
BIOS/C-state/`linux-xr` authority consolidation work.

## Captures

- NUMA capture:
  `data/captures/honey/numa-baseline-2026-04-22.json`
- Reset-state capture:
  `data/captures/honey/reset-baseline-2026-04-22.json`
- Host inventory record:
  `dhall/defaults/honey-host-inventory-2026-04-22.dhall`
- BIOS record:
  `dhall/defaults/honey-bios-record-2026-04-22.dhall`
- Raw BIOS export:
  `data/captures/honey/bios-export-2026-04-22.cctk`
- BIOS check output:
  `data/captures/honey/bios-check-2026-04-22.txt`
- Post-change BIOS export after `usbemu=disable`:
  `data/captures/honey/bios-export-post-usbemu-disable-2026-04-22.cctk`
- Post-change BIOS check after `usbemu=disable`:
  `data/captures/honey/bios-check-post-usbemu-disable-2026-04-22.txt`
- SMI validation output:
  `data/captures/honey/smi-validate-2026-04-22.txt`
- Post-change pre-reboot SMI validation output:
  `data/captures/honey/smi-validate-post-usbemu-disable-pre-reboot-2026-04-22.txt`
- Repeated SMI samples:
  `data/captures/honey/smi-rate-samples-2026-04-22.txt`

## Confirmed live state

- host: `honey`
- BIOS version: `A34`
- BIOS date: `10/19/2020`
- board: `0GWHMW`
- active kernel: `6.19.5-7.xr.el10`
- active RT evidence on current boot: none
- CPU model:
  `Intel(R) Xeon(R) CPU E5-2630 v3 @ 2.40GHz`
- observed NUMA nodes: `2`

## Important findings

1. The BIOS floor is correct.
   `honey` is already on the expected `A34` revision.

2. The active kernel lane is the generic `linux-xr` lane.
   RT packages are installed on-host, but the active boot was not RT.

3. The host is not currently in the intended low-latency posture.
   The live cmdline does not include:
   `intel_pstate=disable`, `processor.max_cstate=1`,
   `intel_idle.max_cstate=0`, `isolcpus=...`, or the other expected isolation
   arguments.

4. BIOS settings are now machine-checked, but through a legacy DCC surface.
   The Dell Precision Tower 7810-compatible `command_configure-linux-3.0.0-509`
   payload was installed successfully on `honey`, and the repo-owned BIOS check
   now runs truthfully against `/opt/dell/toolkit/bin/cctk`.

5. The BIOS posture was partially corrected remotely on April 22, 2026, but runtime validation is still pending reboot.
   The initial machine-checked result on April 22, 2026 was:
   `usbemu=enable` (mismatch),
   `cstatesctrl=disable` (legacy approximation to the C1-only target),
   `turbomode=disable` (match),
   `speedstep=disable` (match),
   while `hpet` and `computrace` remained unknown through the legacy export.
   Later that same day, `usbemu=disable` was applied remotely through legacy
   Dell Command | Configure, and the post-change export now reports
   `usbemu=disable`.

6. The current boot should not be described as an RT proof.
   RT kernels are installed, but the live boot is generic, and a follow-up
   spot check did not find `/sys/kernel/realtime` on the current boot.

7. The active `tuned` profile is not the Dell low-latency profile.
   `tuned-adm active` reported `throughput-performance`.

8. The repo-owned baseline validator passes the kernel config and fails the
   boot posture.
   A follow-up validation against the live host on April 22, 2026 matched the
   Dell base fragment `30 / 30`, but the current boot cmdline missed all
   `19 / 19` expected low-latency tokens.

9. Bounded SMI evidence now exists, and it is still bad enough to block stronger timing claims.
   The saved validator run reported `16` SMIs in `10s` (`1.6/s`), and the
   repeated-sample capture showed `16`, `41`, and `16` SMIs across three
   consecutive 10-second windows (`1.6-4.1/s`).
   A post-change pre-reboot sample after writing `usbemu=disable` still
   reported `16` SMIs in `10s`, so the repo should treat the BIOS write as
   recorded NVRAM state, not yet as proven runtime improvement.

10. `hwlatdetect` is still unavailable on the host.
    The repo-owned SMI validator now runs truthfully, but it still reports that
    `rt-tests` / `hwlatdetect` are missing, so the host does not yet have a
    current hardware-latency trace in this repo.

## Display and network snapshot

From the reset-state capture:

- `card0-DP-2` was connected, with modes including `5088x2544` and `3840x1920`,
  but not enabled in that captured state
- `card0-HDMI-A-2` was connected and enabled, with `1920x1080` modes present
- `sshd` was active
- `tailscaled` was active

## Interpretation

This is not a bad host state, but it is not yet the validated low-latency host
state that the Dell repo has been describing as the target.

The repo can now state all of the following honestly:

- BIOS `A34` is live on `honey`
- the generic `linux-xr` lane is live on `honey`
- RT kernels are installed on `honey`
- the current boot should not be cited as PREEMPT_RT-grounded host evidence
- the current kernel config matches the Dell base fragment
- the current boot cmdline matches none of the Dell low-latency reference tokens
- the active tuned profile is `throughput-performance`, not `t7810-low-latency`
- the BIOS export surface is now closer to target: USB emulation has been set
  to disabled, but runtime impact is still unproven until after reboot
- bounded SMI samples remain nonzero and bursty
- the current host posture does not yet match the intended low-latency cmdline
  and BIOS-check surface

## Immediate next step

1. Reboot `honey`, then re-run the BIOS and SMI validators to test whether the
   remote `usbemu=disable` change actually reduces runtime SMI activity.
2. Keep using `just platform-validate-kernel-baseline-remote` to verify the
   active host posture without requiring a Dell repo checkout on `honey`.
3. Decide whether the generic lane should regain the intended low-latency
   cmdline, or whether that posture should stay a narrower validation lane.
4. Decide whether `throughput-performance` should be replaced by the Dell
   low-latency tuned profile on the persistent generic lane.
5. Install or source `hwlatdetect` / `rt-tests`, then re-run
   `just platform-smi-validate-full`.

## Baseline validator summary

The follow-up validator run against the live host produced:

- base fragment: `30 matched`, `0 mismatched`
- cmdline tokens: `0 matched`, `19 missing`

Missing cmdline tokens:

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
