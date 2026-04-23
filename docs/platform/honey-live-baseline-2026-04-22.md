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
- Reboot confirmation after `usbemu=disable`:
  `data/captures/honey/reboot-confirmation-post-usbemu-disable-2026-04-22.txt`
- Post-reboot BIOS export after `usbemu=disable`:
  `data/captures/honey/bios-export-post-reboot-usbemu-disable-2026-04-22.cctk`
- Post-reboot BIOS check after `usbemu=disable`:
  `data/captures/honey/bios-check-post-reboot-usbemu-disable-2026-04-22.txt`
- SMI validation output:
  `data/captures/honey/smi-validate-2026-04-22.txt`
- Post-change pre-reboot SMI validation output:
  `data/captures/honey/smi-validate-post-usbemu-disable-pre-reboot-2026-04-22.txt`
- Post-reboot SMI validation output:
  `data/captures/honey/smi-validate-post-reboot-usbemu-disable-2026-04-22.txt`
- Post-reboot SMI validation output with tracefs `hwlat` fallback:
  `data/captures/honey/smi-validate-with-tracefs-hwlat-2026-04-22.txt`
- Post-reboot kernel-baseline validation output:
  `data/captures/honey/kernel-baseline-post-reboot-usbemu-disable-2026-04-22.txt`
- Tuned status before profile activation:
  `data/captures/honey/tuned-status-before-activation-2026-04-22.txt`
- Tuned activation output:
  `data/captures/honey/tuned-activate-profile-2026-04-22.txt`
- Tuned status after profile activation:
  `data/captures/honey/tuned-status-after-activation-2026-04-22.txt`
- Grubby default and `/etc/tuned/bootcmdline` after tuned activation:
  `data/captures/honey/grubby-default-after-tuned-activation-2026-04-22.txt`
- Immediate post-activation SMI validation output:
  `data/captures/honey/smi-validate-after-tuned-activation-2026-04-22.txt`
- Reboot confirmation after tuned activation:
  `data/captures/honey/reboot-confirmation-post-tuned-activation-2026-04-22.txt`
- Post-tuned reboot kernel-baseline validation output:
  `data/captures/honey/kernel-baseline-post-tuned-reboot-2026-04-22.txt`
- Post-tuned reboot SMI validation output:
  `data/captures/honey/smi-validate-post-tuned-reboot-2026-04-22.txt`
- Repeated SMI samples:
  `data/captures/honey/smi-rate-samples-2026-04-22.txt`
- Pre-RT one-time boot status capture:
  `data/captures/honey/kernel-lane-status-pre-rt-reboot-2026-04-23.txt`
- Pre-RT runtime confirmation:
  `data/captures/honey/kernel-runtime-pre-rt-reboot-2026-04-23.txt`
- Post-RT reboot confirmation:
  `data/captures/honey/reboot-confirmation-post-rt-boot-2026-04-23.txt`
- Post-RT kernel lane status:
  `data/captures/honey/kernel-lane-status-post-rt-boot-2026-04-23.txt`
- Post-RT kernel-baseline validation output:
  `data/captures/honey/kernel-baseline-post-rt-boot-2026-04-23.txt`
- Post-RT SMI validation output:
  `data/captures/honey/smi-validate-post-rt-boot-2026-04-23.txt`
- Post-RT return-to-generic confirmation:
  `data/captures/honey/reboot-confirmation-post-rt-return-generic-2026-04-23.txt`
- Post-RT return-to-generic kernel lane status:
  `data/captures/honey/kernel-lane-status-post-rt-return-generic-2026-04-23.txt`

## Confirmed live state

- host: `honey`
- BIOS version: `A34`
- BIOS date: `10/19/2020`
- board: `0GWHMW`
- active kernel: `6.19.5-7.xr.el10`
- active RT evidence on current boot: none
- active tuned profile on current boot: `t7810-low-latency`
- CPU model:
  `Intel(R) Xeon(R) CPU E5-2630 v3 @ 2.40GHz`
- observed NUMA nodes: `2`

## Important findings

1. The BIOS floor is correct.
   `honey` is already on the expected `A34` revision.

2. The active kernel lane is the generic `linux-xr` lane.
   RT packages are installed on-host, but the active boot was not RT.

3. The host later reached the intended generic low-latency cmdline posture on
   the generic `linux-xr` lane.
   After the repo-owned `t7810-low-latency` tuned profile was activated and
   `honey` was rebooted, the live `/proc/cmdline` included the full Dell
   reference token set and the kernel-baseline validator passed `19 / 19`
   cmdline checks.

4. BIOS settings are now machine-checked, but through a legacy DCC surface.
   The Dell Precision Tower 7810-compatible `command_configure-linux-3.0.0-509`
   payload was installed successfully on `honey`, and the repo-owned BIOS check
   now runs truthfully against `/opt/dell/toolkit/bin/cctk`.

5. The BIOS posture was corrected remotely on April 22, 2026, and that change persisted across reboot.
   The initial machine-checked result on April 22, 2026 was:
   `usbemu=enable` (mismatch),
   `cstatesctrl=disable` (legacy approximation to the C1-only target),
   `turbomode=disable` (match),
   `speedstep=disable` (match),
   while `hpet` and `computrace` remained unknown through the legacy export.
   Later that same day, `usbemu=disable` was applied remotely through legacy
   Dell Command | Configure. After reboot, both the BIOS check and the raw
   export continued to report `usbemu=disable`.

6. The current boot should not be described as an RT proof.
   RT kernels are installed, but the live boot is generic, and a follow-up
   spot check did not find `/sys/kernel/realtime` on the current boot.

7. The active `tuned` profile is now the Dell low-latency profile.
   Before activation, `tuned-adm active` reported `throughput-performance`.
   After the repo-owned remote profile install and activation, the active
   profile became `t7810-low-latency`, and the tuned bootloader plugin wrote
   the full Dell reference cmdline into `/etc/tuned/bootcmdline`.

8. The repo-owned baseline validator now passes both the kernel config and the
   live boot posture after the tuned-managed reboot.
   The post-tuned reboot validation against the live host on April 22, 2026
   matched the Dell base fragment `30 / 30`, and the live boot cmdline matched
   `19 / 19` expected low-latency tokens.

9. Bounded SMI evidence now exists, and `usbemu=disable` did not improve the bounded sample.
   The saved validator run reported `16` SMIs in `10s` (`1.6/s`), and the
   repeated-sample capture showed `16`, `41`, and `16` SMIs across three
   consecutive 10-second windows (`1.6-4.1/s`).
   A post-change pre-reboot sample after writing `usbemu=disable` still
   reported `16` SMIs in `10s`.
   After reboot, the post-reboot sample still reported `16` SMIs in `10s`, so
   this BIOS change alone did not produce an observed improvement in the
   bounded runtime SMI sample.

10. `hwlatdetect` is still unavailable as a userspace binary, but the kernel's
    built-in tracefs `hwlat` tracer is available and now used by the repo-owned
    validator as a fallback.
    A 10-second post-USB-change sample reported `2 us` max latency, and the
    later post-tuned activation and post-tuned reboot samples both reported
    `0 us` max latency, which is materially better than the SMI count alone
    would suggest.

11. A first Dell-owned one-time RT validation boot now exists.
    On April 23, 2026, `honey` booted `6.19.5-rt1-8.xr.el10` via the repo-owned
    `next_entry` path, `uname -v` reported `PREEMPT_RT`, and
    `/sys/kernel/realtime` reported `1`. The persistent default kernel remained
    generic and `next_entry` was consumed as intended. The RT run kept the full
    low-latency cmdline posture and produced a bounded `hwlat` result of `1 us`,
    but the first-pass Dell RT fragment proved stricter than the live shipped
    kernel. The repo validator has since been reconciled to that supplier
    posture. See
    `docs/platform/honey-rt-validation-2026-04-23.md`.
    A follow-on controlled reboot later returned the host to the expected
    generic `6.19.5-7.xr.el10` fallback lane, so the full one-time RT loop is
    now Dell-owned evidence rather than an unfinished branch.

## Display and network snapshot

From the reset-state capture:

- `card0-DP-2` was connected, with modes including `5088x2544` and `3840x1920`,
  but not enabled in that captured state
- `card0-HDMI-A-2` was connected and enabled, with `1920x1080` modes present
- `sshd` was active
- `tailscaled` was active

## Interpretation

This host is now materially closer to the validated generic low-latency target
than it was at the beginning of the day, but it is still not a complete RT or
fully-explained firmware-latency result.

The repo can now state all of the following honestly:

- BIOS `A34` is live on `honey`
- the generic `linux-xr` lane is live on `honey`
- RT kernels are installed on `honey`
- the current boot should not be cited as PREEMPT_RT-grounded host evidence
- the current kernel config matches the Dell base fragment
- the current boot cmdline now matches the Dell low-latency reference tokens
- the active tuned profile is now `t7810-low-latency`
- the BIOS export surface is closer to target: USB emulation has been set to
  disabled and verified after reboot
- that specific BIOS change did not reduce the bounded post-reboot SMI sample
- the built-in tracefs `hwlat` tracer is usable on this kernel even without the
  `hwlatdetect` binary, and the post-tuned samples reported `0 us` max latency
- bounded SMI samples remain nonzero and bursty
- the current host posture now matches the intended generic low-latency cmdline
  and tuned-profile surface, but not a PREEMPT_RT lane
- the first one-time RT validation boot is now also Dell-owned evidence, but it
  is still a gated branch with slower remote recovery than the generic lane and
  still needs a second pass under the reconciled Dell RT validator

## Immediate next step

1. Treat the built-in tracefs `hwlat` fallback as the current timing truth
   surface for this kernel; the post-tuned samples were `0 us` max latency
   even though the bounded SMI counter stayed nonzero.
2. Keep using `just platform-validate-kernel-baseline-remote` to verify the
   active host posture without requiring a Dell repo checkout on `honey`.
3. Decide whether the next validation target should be a longer `hwlat` run on
   this generic lane or a deliberate PREEMPT_RT boot.
4. Investigate only the BIOS-side candidates that still look plausible after
   the current evidence: legacy wake/power tokens and any management surfaces
   that remain invisible through DCC.
5. Preserve the tuned-managed cmdline and profile state as the current generic
   host baseline unless stronger contrary evidence appears.

## Baseline validator summary

The post-tuned reboot validator run against the live host produced:

- base fragment: `30 matched`, `0 mismatched`
- cmdline tokens: `19 matched`, `0 missing`
