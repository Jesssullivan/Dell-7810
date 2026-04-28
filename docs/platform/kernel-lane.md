# T7810 Kernel Lane

This note draws the ownership boundary between the Dell 7810 host kernel posture and the XR-specific patch lane.

## Why this split matters

`XoxdWM` currently carries a kernel lane that mixes:

- Dell 7810 timing and latency posture,
- Rocky/systemd boot invariants,
- and Bigscreen Beyond plus AMD display-pipeline patches.

That is too much in one place. The host platform needs its own contract.

Two official references shape this split:

- Linux kernel PREEMPT_RT documentation:
  https://docs.kernel.org/core-api/real-time/
- Linux kernel hwlat detector documentation:
  https://docs.kernel.org/trace/hwlat_detector.html

The first explains why PREEMPT_RT changes interrupt and locking behavior materially. The second is a reminder that firmware-induced latency is a platform problem and that `hwlat` is a manual diagnostic tool rather than a production feature.

## Host-kernel surface that belongs in this repo

These are Dell-7810-specific or host-contract concerns:

- `HZ=1000` and optional `PREEMPT_RT` enablement for low-latency host validation.
- `CONFIG_HWLAT_TRACER`, `CONFIG_OSNOISE_TRACER`, `CONFIG_TIMERLAT_TRACER`, and `CONFIG_X86_MSR` for latency characterization.
- CPU-isolation and scheduling support:
  `CONFIG_CPU_ISOLATION`, `CONFIG_NO_HZ_FULL`, `CONFIG_RCU_NOCB_CPU`, `CONFIG_IRQ_FORCED_THREADING`.
- userspace I/O support for future measurement or electrophysiology hardware:
  `CONFIG_UIO`, `CONFIG_UIO_PCI_GENERIC`.
- T7810-specific SMI-noise posture:
  disabling `DELL_RBU`, `ITCO_WDT`, and any other kernel features known to undermine the host contract.
- Rocky / systemd 257 boot invariants:
  preserving BTF, disabling `FW_LOADER_USER_HELPER`, and keeping the required tmpfs / autofs / overlay options enabled.
- T7810 boot parameters for host timing work:
  `tsc=nowatchdog`, `clocksource=tsc`, `intel_pstate=disable`, `processor.max_cstate=1`, `intel_idle.max_cstate=0`, `nmi_watchdog=0`, CPU isolation, and IRQ affinity.

These are all about whether `honey` is a trustworthy workstation and measurement surface.

## XR-specific kernel surface that should stay in XoxdWM

These are display-stack and HMD bring-up concerns, not generic T7810 platform concerns:

- Bigscreen Beyond non-desktop EDID quirk.
- VESA DisplayID DSC BPP parser carry patch.
- AMD DSC QP / RC corrections used to make the Beyond display path work.
- HMD-specific amdgpu bring-up tuning and debug masking.
- kernel packaging whose primary validation claim is XR display behavior rather than host stability.

Those patches may still be required on `honey`, but they are not part of the generic Dell 7810 host contract.

## Recommended split

## 1. Define a generic host baseline here

This repo should own the generic T7810 low-latency contract:

- BIOS posture
- boot parameters
- config fragment for tracing, isolation, and systemd compatibility
- validation procedure using `smi-validate`, `capture-reset-state`, and reset-run notes

The first concrete repo-owned baseline now exists in:

- `packaging/kernel/t7810-host-latency-base.config`
- `packaging/kernel/t7810-host-latency-rt.config`
- `packaging/kernel/t7810-host-latency.cmdline`

## 2. Treat XR patches as an overlay

`XoxdWM` should keep a clear overlay lane:

- base = generic host-safe kernel posture
- overlay = Beyond and AMD display-path patches

That makes it possible to answer two different questions cleanly:

- Is the workstation stable?
- Does the HMD display path work?

## 3. Do not move the full RPM build here yet

This repo should not immediately absorb the entire `linux-xr` RPM build lane.

Move the build only after:

- the host baseline is expressed independently of the Beyond patches,
- the baseline boots cleanly on `honey` with the HDMI management path,
- and the systemd 257 config invariants are proven outside the XR patch stack.

## Extraction candidates from XoxdWM

Good candidates for eventual extraction:

- generic config fragment derived from the current `kernel-xr.spec` and Dhall config generators,
- generic boot-parameter composition for the T7810,
- host-only validation docs and evidence.

Poor candidates for extraction right now:

- the Beyond patch carry set,
- compositor-coupled kernel assumptions,
- HMD-specific patch rationales and test criteria.

## Immediate next step

Turn the current mixed kernel lane into two named concepts:

1. `t7810-host-latency`
2. `linux-xr-overlay`

Until that split exists explicitly, kernel discussions will keep blurring host recovery work with headset bring-up work.

For the current file-by-file boundary and provenance map, see
[`xoxdwm-boundary-audit.md`](xoxdwm-boundary-audit.md).
