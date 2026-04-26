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
| generic SMI / bounded hwlat posture | `partial` | generic repeated `smi-validate` captures, `honey-generic-smi-hwlat-series-2026-04-25.md`, and `honey-generic-host-characterization-window-2026-04-26.md` | nonzero SMI count persists even after tuned/cmdline closure; the 2026-04-26 generic 120s windows show stable SMI around `2.3/s` while tracefs `hwlat` remained `0 us` max | matching longer RT run or additional BIOS-side mitigation evidence |
| RT SMI / bounded hwlat posture | `partial` | RT repeated `smi-validate` captures, `honey-rt-smi-hwlat-chapel-series-2026-04-25.md`, and `honey-rt-host-characterization-window-2026-04-26.md` | RT does not eliminate nonzero SMI count; the 2026-04-26 RT 120s windows show `279`, `279`, `278` SMIs and tracefs `hwlat` max `2`, `2`, `14 us` | decide whether the `14 us` RT `hwlat` threshold crossing needs rerun or BIOS-side mitigation before publication |
| NUMA host inventory | `partial` | host inventory Dhall, `capture-numa-state`, `numactl` capture surfaces | the workstation is formally treated as a dual-socket NUMA host with a reproducible inventory surface | refreshed live capture paired with Chapel probe result |
| Chapel and PBT method surface | `ready` | `analysis/`, `TimingProofs`, `quickchpl` tests, `HostNumaProbe` source | Chapel and property-based tests are being used as host-characterization tools, not application benchmarks | none for methods |
| live Chapel host probe on generic lane | `ready` for methods, `partial` for richer NUMA claims | `chapel-host-probe-baseline.txt`, `chapel-host-probe-turnkey.txt`, `honey-chapel-live-result-2026-04-23.md`, `honey-generic-chapel-repeat-series-2026-04-25.md`, `honey-generic-host-characterization-window-2026-04-26.md`, `ChapelHostProbeRun` record | the generic-lane probe runs successfully on `honey`, the on-target operator replay succeeds, two five-sample store-prebuilt generic repeat packets conform, and under `CHPL_LOCALE_MODEL=flat`, `Sublocales: 0` is expected rather than a failed run | a clear decision on whether future NUMA claims need a different Chapel execution model |
| live Chapel host probe on RT lane | `first packet captured; repeat blocked` | `chapel-host-probe-rt-2026-04-25.txt`, `honey-chapel-host-probe-rt-2026-04-25.dhall`, `honey-rt-smi-hwlat-chapel-series-2026-04-25.md`, and `honey-rt-host-characterization-window-2026-04-26.md` | the same Chapel probe conforms on the first RT lane packet, but the first paired result does not show RT timing improvement; the 2026-04-26 RT repeat attempt blocked under RT responsiveness before `HostNumaProbe` | fix or bypass the RT responsiveness/SSH staging blocker before treating repeated RT Chapel data as available |

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

Draftable as a cautious first result note after:

1. one generic-lane `HostNumaProbe` capture exists
2. one RT-lane `HostNumaProbe` capture exists
3. the SMI/hwlat story is clearly labeled as short-window context, not a
   mitigation result

Keep it narrow: the first paired packet is neutral/negative for RT benefit.
Use it to define the method and next measurement series, not to claim
optimization.

### Package C: downstream software benefit note

Not a Dell-first paper.

This requires a separate downstream `C4` surface, likely in `XoxdWM`.

## Immediate next evidence

1. decide whether future NUMA-sensitive Chapel claims will rely on OS-side NUMA inventory under the current flat locale model or require a different Chapel execution model
2. decide whether a runner-backed Chapel/package lane should replace the current continuity-only local/on-target build posture for repeatable compiler validation
3. decide whether to rerun the RT `hwlat` window after the `14 us` threshold
   crossing, or carry it as the current cautionary result
4. fix or bypass the RT Chapel capture blocker before any stronger timing
   claim
