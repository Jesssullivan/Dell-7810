# Honey Chapel Live Result -- 2026-04-23

Owner issue: `TIN-470`  
GitHub mirror: `#21`

## Summary

- date: 2026-04-23
- host: `honey`
- operator: repo-owned remote execution from the control machine
- compiler source used: Dell-local fallback package built on-target
- Chapel version: `2.8.0`
- kernel: generic `6.19.5-7.xr.el10`
- expected lane: generic

## Commands

- on-target build attempt:
  `bash scripts/platform/capture-chapel-host-probe-on-target --target jess@honey --tag baseline`
- live compile/run that produced the saved capture:
  synthetic `CHPL_HOME` derived from `/nix/store/7ss0vzf5h55kl260i8j8hy72f3jnjs3y-chapel-2.8.0`,
  raw `.chpl-wrapped`, explicit LLVM and Clang resource-dir env, then
  `/tmp/dell-7810-host-numa-probe-baseline`
- saved capture:
  [`../../data/captures/honey/chapel-host-probe-baseline.txt`](/Users/jess/git/Dell-7810/data/captures/honey/chapel-host-probe-baseline.txt)
- machine-readable companion:
  [`../../dhall/defaults/honey-chapel-host-probe-baseline-2026-04-23.dhall`](/Users/jess/git/Dell-7810/dhall/defaults/honey-chapel-host-probe-baseline-2026-04-23.dhall)

## Host context

- `uname -a`: generic `6.19.5-7.xr.el10`, `PREEMPT_DYNAMIC`
- `/sys/kernel/realtime`: absent
- `lscpu`: dual-socket Xeon E5-2630 v3, `32` CPUs, `2` NUMA nodes
- `numactl --hardware`: node `0` and node `1` both visible
- current cmdline posture summary:
  low-latency generic posture is still present (`tsc=nowatchdog`, `nohz_full`,
  `isolcpus`, `irqaffinity`, etc.)

## Probe result

- `HostNumaProbe` ran successfully on `honey`
- locales: `1`
- sublocales: `0`
- partition result: `2` equal partitions of `50` channels each
- timing proof result: `Conforms: true`
- serial vs parallel summary:
  serial `0.02283s`, parallel `0.00228s`, reported speedup `10.0132x`

## Interpretation

- what this proves:
  the Dell repo now has a real saved live Chapel host result on `honey` for the
  generic lane, and the `HostNumaProbe` method surface is not just theoretical
- what this does **not** prove:
  it does not yet prove Chapel-visible NUMA sublocales on this host, and it
  does not prove downstream RT or XR software benefit
- whether this result is generic-lane or PREEMPT_RT-lane evidence:
  generic-lane evidence only
- which RT contract claims it informs:
  this is still a `C4` precondition surface only; it strengthens the host
  characterization method story, not a downstream software-benefit claim

## Important nuance

`numactl --hardware` reports `2` NUMA nodes on `honey`, but the live Chapel
probe reported `Sublocales: 0`. That means the live result is real and useful,
and it should not be read as a failed run. On the current Chapel `2.8.0`
posture, `CHPL_LOCALE_MODEL=flat`, which Chapel documents as "top-level
locales are not further subdivided." In other words, the current build is a
single-locale host-characterization surface, while NUMA topology still comes
from the host inventory and `numactl`, not Chapel locale subdivision.

## Follow-on

- next Chapel-specific action:
  decide whether future NUMA-sensitive Chapel work should stay with the current
  flat locale model plus OS-side NUMA inventory, or move to a different Chapel
  execution model if locale subdivision is required
- next host-validation action:
  decide whether an RT-lane Chapel probe would add real value now that the
  generic-lane probe exists
- whether the Dell-local Chapel fallback is still needed after this run:
  yes for now; the external compiler source is still not the proven path for
  this live host result
