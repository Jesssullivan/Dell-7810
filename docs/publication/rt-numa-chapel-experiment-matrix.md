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
| live Chapel host probe on RT lane | `repeated; negative/cautionary` | `chapel-host-probe-rt-2026-04-25.txt`, `honey-chapel-host-probe-rt-2026-04-25.dhall`, `honey-rt-smi-hwlat-chapel-series-2026-04-25.md`, `honey-rt-host-characterization-window-2026-04-26.md`, and `honey-rt-chapel-repeat-2026-04-26.md` | the same Chapel probe conforms on RT; the 2026-04-26 hardened repeat produced five conforming RT samples, but RT ratio mean was lower than the matching generic repeat and variance was higher because of a severe parallel outlier | decide whether to publish as a cautionary/negative result or rerun under quieter load |

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

## RT necessity analysis

The external research grounding for the RT decision is now documented in
[`../research/rt-necessity-analysis-2026-04-26.md`](../research/rt-necessity-analysis-2026-04-26.md).
The downstream proof packet templates are in
[`rt-benefit-decision-framework-2026-04-26.md`](rt-benefit-decision-framework-2026-04-26.md).

Key findings that affect this experiment matrix:

- RT did not improve the measured Chapel repeat packet and introduced a severe
  parallel outlier.
- VR frame timing needs OpenXR/Monado frame, submit, present, and display
  evidence; it should not be inferred from host Chapel timing.
- BCI/audio timing needs period, buffer, quantum, xrun, and missed-deadline
  evidence; it should not be inferred from host Chapel timing.
- GPU/display questions need RX 9070 XT, DisplayID/DSC, vblank/page-flip, and
  compositor evidence; RT does not change display bandwidth by itself.
- Generic lane with `isolcpus`, `nohz_full`, `irqaffinity`, and real-time
  scheduling policy remains the safer default hypothesis until a downstream
  packet proves otherwise.

Strategic implication: the experiment matrix should shift from "repeat RT
packets until improvement appears" toward "test specific downstream deadline
behavior on the generic lane" and document RT as a completed characterization
campaign with a negative result.

## Immediate next evidence

1. decide whether future NUMA-sensitive Chapel claims will rely on OS-side NUMA
   inventory under the current flat locale model or require a different Chapel
   execution model
2. decide whether a runner-backed Chapel/package lane should replace the current
   continuity-only local/on-target build posture for repeatable compiler
   validation
3. carry the RT `hwlat` 14 us threshold crossing as the current cautionary
   result unless a BIOS-side SMI mitigation is being investigated
4. the RT Chapel capture blocker was fixed (hardened store-prebuilt path); the
   result is negative/cautionary, not a reason to rerun
5. draft an audio/BCI I/O packet template (period, buffer, quantum, xrun,
   deadline fields) to test the actual latency-sensitive workload on the
   generic lane
6. draft an XR frame-timing packet template (`xrWaitFrame`, missed frames,
   display timing) for XoxDWM C4 evidence
