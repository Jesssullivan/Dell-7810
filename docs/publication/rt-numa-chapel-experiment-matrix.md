# RT / NUMA / Chapel Experiment Matrix

Use this note when turning the current host-characterization lane into a paper,
talk, or results section.

This is narrower than the full repo story. It is about:

- kernel posture,
- SMI and bounded hardware latency,
- NUMA-aware host characterization,
- and Chapel/PBT as the method surface that ties those together.

## Claim boundary

Use the RT contract language from
[`../platform/rt-research-contract.md`](../platform/rt-research-contract.md):

- `Dell-7810` owns host-side `C1`, `C2`, and `C3`
- `XoxdWM` or another downstream repo owns `C4`
- Chapel host probes here can support host characterization and future `C4`
  preconditions, but they do not by themselves prove downstream software
  benefit

## Experiment status

| Experiment lane | Status | Current evidence | Publication-safe claim now | Missing to strengthen |
| --- | --- | --- | --- | --- |
| generic low-latency baseline on `honey` | `ready` | `honey-live-baseline-2026-04-22.md`, generic validation captures, tuned profile closure | the generic `linux-xr` lane on `honey` is a measured low-latency host baseline | longer hwlat or repeated SMI timing runs |
| RT first one-time pass | `historical partial` | first-pass RT captures plus `honey-rt-validation-2026-04-23.md` | the host booted RT successfully before the Dell validator was reconciled | none, except historical context in later writing |
| RT second one-time pass | `ready` for host methods, `partial` for operational conclusion | second-pass RT captures, `KernelValidationRun`, reconciled validator | `C1` and `C2` are established on `honey`; `C3` remains partial because recovery cost and nonzero SMI remain | longer RT hwlat, repeated RT recovery timing |
| generic SMI / bounded hwlat posture | `partial` | generic `smi-validate` captures and live baseline note | nonzero SMI count persists even after tuned/cmdline closure, but bounded hwlat remains low | longer run or additional BIOS-side mitigation evidence |
| RT SMI / bounded hwlat posture | `partial` | RT second-pass `smi-validate` capture | RT does not eliminate nonzero SMI count, but bounded hwlat remained `0 us` in the short run | longer RT run, repeated samples |
| NUMA host inventory | `partial` | host inventory Dhall, `capture-numa-state`, `numactl` capture surfaces | the workstation is formally treated as a dual-socket NUMA host with a reproducible inventory surface | refreshed live capture paired with Chapel probe result |
| Chapel and PBT method surface | `ready` | `analysis/`, `TimingProofs`, `quickchpl` tests, `HostNumaProbe` source | Chapel and property-based tests are being used as host-characterization tools, not application benchmarks | none for methods |
| live Chapel host probe on generic lane | `blocked` | capture script, save targets, result template, Dhall projector surface | do not claim a live host result yet | one saved capture from `honey` |
| live Chapel host probe on RT lane | `blocked` | same as above plus RT contract | do not claim RT-specific Chapel behavior yet | one saved RT-lane capture after generic lane is working |

## Recommended publication packages

### Package A: methods-forward host paper

Draftable now:

- host contract formalization
- generic baseline closure
- RT claim ladder and second-pass validation
- Chapel/PBT method framing

Keep results narrow:

- report current RT host evidence
- explicitly mark live Chapel results as pending

### Package B: RT and NUMA host note

Draft only after:

1. one generic-lane `HostNumaProbe` capture exists
2. one RT-lane `HostNumaProbe` capture exists or is explicitly out of scope
3. the SMI/hwlat story is refreshed with at least one longer bounded run

### Package C: downstream software benefit note

Not a Dell-first paper.

This requires a separate downstream `C4` surface, likely in `XoxdWM`.

## Immediate next evidence

1. finish one saved generic-lane `HostNumaProbe` capture
2. project that capture into a machine-readable Dhall record
3. write the first Dell-owned live result note from the existing template
4. decide whether a second RT-lane Chapel probe is worth host time before any
   stronger publication claim
