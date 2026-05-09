# Honey Kernel Posture Cross-Repo Audit -- 2026-04-22

Owner issue: `TIN-398`

External follow-up issue:
`tinyland-inc/linux-xr#22`

This note exists to stop three different ideas from being blurred together:

1. RT RPMs are installed on `honey`.
2. `honey` is actively booted into an RT kernel.
3. `honey` is in a validated low-latency posture suitable for timing and NUMA
   claims.

Those are not the same state.

## Dell-owned live baseline

The current Dell-owned live host baseline is:

- active kernel: `6.19.5-7.xr.el10`
- BIOS: `A34`
- RT RPMs installed:
  - `kernel-xr-rt-6.19.5-7.xr.el10.x86_64`
  - `kernel-xr-rt-6.19.5-8.xr.el10.x86_64`
- after the tuned-managed reboot, the current boot cmdline does contain the
  intended low-latency arguments such as `intel_pstate=disable`,
  `processor.max_cstate=1`, `intel_idle.max_cstate=0`, and `isolcpus=...`
- legacy Dell Command | Configure `3.0.0-509` is now installed on the host, and
  the first machine-checked BIOS pass shows `usbemu=enable`,
  `cstatesctrl=disable`, `turbomode=disable`, `speedstep=disable`, with `hpet`
  and `computrace` still unknown through the legacy export surface
- active tuned profile: `t7810-low-latency`
- bounded SMI evidence remains nonzero and bursty (`1.6-4.1/s` across repeated
  10-second samples)
- a follow-up live spot check on April 22, 2026 did not find
  `/sys/kernel/realtime` on the current generic boot, which is another reason
  not to treat the current boot as an RT proof

## 2026-05-08 linux-xr xr10 boot addendum

The April 22 baseline above is now historical for the running kernel version.
On May 8, 2026, `honey` was recovered through the Tailscale SSH operator path,
updated from the published `tinyland-inc/linux-xr` `v6.19.5-xr10` release, and
rebooted into the secured generic runtime:

- operator path used: `tailscale ssh root@honey`
- release: `tinyland-inc/linux-xr` `v6.19.5-xr10`
- runtime RPM: `kernel-xr-6.19.5-10.xr.el10.x86_64`
- matching development RPM: `kernel-xr-devel-6.19.5-10.xr.el10.x86_64`
- active kernel after reboot: `6.19.5-10.xr.el10`
- default kernel after reboot: `/boot/vmlinuz-6.19.5-10.xr.el10`
- SELinux state after reboot: `Enforcing`
- rollback kernels still installed:
  - `kernel-xr-6.19.5-7.xr.el10.x86_64`
  - `kernel-xr-6.19.5-9.xr.el10.x86_64`
- `/boot` after install and reboot: 181 MiB free on an 849 MiB filesystem

The live CVE-2026-31431 checker reports the running `6.19.5-10.xr.el10`
kernel as safe when evaluated with the repo-managed backport assertion. This
is still a generic linux-xr boot proof, not an RT proof and not a renewed
low-latency timing claim. Fresh BIOS, SMI, hwlat, NUMA, tuned, and workload
validation remain required before making stronger timing claims.

Boot-adjacent service errors observed after the reboot were unrelated to the
kernel proof and should be handled through their owning lanes if they matter to
operations: cockpit binding to the tailnet address, missing `jess` in one
tmpfiles rule, missing legacy GitHub runner scripts, and permission-denied
cleanup scripts under `/home/github-runner/instances`.

Primary evidence in this repo:

- [`honey-live-baseline-2026-04-22.md`](honey-live-baseline-2026-04-22.md)
- [`../../data/captures/honey/numa-baseline-2026-04-22.json`](../../data/captures/honey/numa-baseline-2026-04-22.json)
- [`../../data/captures/honey/reset-baseline-2026-04-22.json`](../../data/captures/honey/reset-baseline-2026-04-22.json)
- [`../../dhall/defaults/honey-host-inventory-2026-04-22.dhall`](../../dhall/defaults/honey-host-inventory-2026-04-22.dhall)
- [`../../dhall/defaults/honey-bios-record-2026-04-22.dhall`](../../dhall/defaults/honey-bios-record-2026-04-22.dhall)

## Classification rules

Use these rules when reading sibling repos:

- installed RT RPMs do not mean the active boot is RT
- an RT boot does not mean the host is in the intended low-latency posture
- a low-latency posture does not, by itself, prove XR or BCI software behavior
- `lab` and `blahaj` are not authority surfaces for kernel posture, NUMA timing,
  or PREEMPT grounding on `honey`

## Current sibling-repo surface audit

| Repo | Surface | Current statement | Classification | Needed action |
| --- | --- | --- | --- | --- |
| `tinyland-inc/linux-xr` | `site/docs/honey.md` | describes the RT verification as historical rollout evidence and says current live host posture is owned by Dell-7810 | acceptable | keep Dell as the live host evidence authority |
| `tinyland-inc/linux-xr` | `README.md` | says `honey` generic is proven, RT is reboot-valid/gated, and host validation belongs in Dell-7810 | acceptable after merged `linux-xr` PR `#26` | keep the README from re-absorbing Dell BIOS/SMI/NUMA runbook detail |
| `XoxdWM` | `docs/support-matrix.md` | says generic lane is proven and RT lane is smoke | acceptable | keep as a software-facing summary, but do not treat it as the source of current host kernel posture |
| `lab` | host inventory / runner docs | names `honey` as control point and runner anchor | acceptable | no kernel-truth correction needed; do not cite these docs for timing or RT claims |
| `blahaj` | cluster/context docs | names `honey` as current cluster anchor | acceptable | no kernel-truth correction needed; do not cite these docs for timing or RT claims |

## What this means for timing and NUMA claims

As of April 22, 2026:

- Chapel/NUMA results gathered on `honey` should currently be described as
  results from the generic `linux-xr` lane
- they should not be described as PREEMPT_RT-grounded timing results
- they should not be described as low-latency host-baseline results

Any paper, presentation, or benchmark note that wants to make stronger timing
claims needs all of the following first:

1. machine-checked BIOS posture after `cctk` is available
2. an explicit decision on whether the generic lane regains the intended
   low-latency cmdline posture
3. a fresh SMI / hwlat validation pass
4. a fresh Dell-owned live baseline after those checks

## Next actions

1. Keep `tinyland-inc/linux-xr/site/docs/honey.md` historical rather than read
   as current live truth.
2. Keep merged `tinyland-inc/linux-xr` PR `#26` from regressing; the README
   should not re-absorb the Dell BIOS/SMI/NUMA/RT host runbook.
3. Keep `XoxdWM` on the current Dell-linked boundary and avoid adding new host
   kernel posture claims there unless they point back to Dell evidence.
4. Treat `TIN-397` as the host-posture closure lane and `TIN-398` as the
   cross-repo truth-reconciliation lane.
