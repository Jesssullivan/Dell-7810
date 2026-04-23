# Host Kernel Baseline

This repo now carries the generic Dell 7810 host-kernel posture as concrete artifacts, not just prose.

## Repo-owned artifacts

- base config fragment:
  [`packaging/kernel/t7810-host-latency-base.config`](/Users/jess/git/Dell-7810/packaging/kernel/t7810-host-latency-base.config)
- RT overlay fragment:
  [`packaging/kernel/t7810-host-latency-rt.config`](/Users/jess/git/Dell-7810/packaging/kernel/t7810-host-latency-rt.config)
- boot command line:
  [`packaging/kernel/t7810-host-latency.cmdline`](/Users/jess/git/Dell-7810/packaging/kernel/t7810-host-latency.cmdline)

These are the extracted generic host assumptions that used to be mixed into `XoxdWM`'s kernel lane.

## What this baseline is for

- keeping `honey` trustworthy as a workstation and measurement surface,
- reducing firmware-induced latency and scheduling noise,
- preserving Rocky / systemd boot invariants,
- and creating a stable foundation for later XR-specific overlays.

## What this baseline is not

- a full kernel build system,
- an RPM spec replacement,
- or a claim that the Beyond display path works by itself.

The XR-specific patch lane still lives elsewhere. This baseline is the host contract underneath it.

## Base vs RT

## Base fragment

The base fragment owns:

- tracing and latency characterization support,
- CPU isolation and scheduling support,
- userspace I/O hooks for future hardware work,
- disabling known-hostile firmware or watchdog surfaces,
- and preserving BTF plus systemd 257 expectations.

Use the base fragment first. If the base posture is not stable, the RT overlay only makes diagnosis harder.

## RT overlay

The RT overlay is deliberately small:

- `PREEMPT_RT`
- no voluntary or dynamic preemption fallback

That keeps the distinction sharp:

- base = host posture
- RT overlay = stricter scheduling model

## Safe RT validation rule

On `honey`, RT validation should now be staged as a one-time next boot, not a
persistent default change.

Use:

- `just platform-kernel-status-remote`
- `just platform-kernel-schedule-next-rt-remote`
- `just platform-kernel-clear-next-entry-remote`

The safety property to preserve is:

- `saved_entry` stays on the generic kernel
- RT is armed only through `next_entry`
- clearing `next_entry` restores the fully generic fallback posture without
  touching the persistent default

## First one-time RT result

That safe validation rule has now been exercised once on `honey`.

The April 23, 2026 Dell-owned RT result was:

- one-time RT boot succeeded on `6.19.5-rt1-8.xr.el10`
- `saved_entry` stayed generic and `next_entry` cleared after boot
- base fragment still matched `30 / 30`
- low-latency cmdline still matched `19 / 19`
- RT overlay validation failed because the live kernel reports
  `CONFIG_PREEMPT_DYNAMIC=y`

So the boot-control boundary is validated, but the repo-owned RT fragment still
needs reconciliation against the live `linux-xr` RT lane.

## Validation sequence

1. Boot a kernel that reflects the base fragment and host cmdline.
2. Validate the baseline directly:
   `just platform-validate-kernel-baseline`
3. Capture the workstation inventory:
   `just platform-capture-numa-state tag=baseline`
4. Validate BIOS posture:
   `just platform-bios-rt-check`
5. Validate latency posture:
   `just platform-smi-validate-full`
6. Capture reset-state evidence around any reboot experiment:
   `just platform-capture-reset-state tag=before-...`

## Why the boot cmdline is separate

Kernel config and runtime boot posture are different controls.

The config fragment expresses what the kernel can do. The cmdline expresses how this particular T7810 host should behave during timing-sensitive work. Keeping them separate makes it easier to compare:

- stock kernel plus host cmdline,
- host-latency base kernel plus stock cmdline,
- host-latency base plus RT overlay plus host cmdline.

## Next step after this baseline

The next real engineering move is not more abstraction. It is an evidence-backed run on `honey`:

- record the actual BIOS settings,
- record the actual power-path inventory,
- capture NUMA state,
- validate the running kernel against the repo baseline,
- capture `hwlat` and SMI behavior,
- and cross-link those results to the reset matrix.

That next run now exists for the first RT branch too:

- `docs/platform/honey-rt-validation-2026-04-23.md`
