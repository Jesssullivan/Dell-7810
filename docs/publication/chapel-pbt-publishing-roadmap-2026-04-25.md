# Chapel/PBT Publishing Roadmap

Date: 2026-04-25

Use this note to turn the Dell-7810 Chapel, PBT, NUMA, SMI, and RT work into
bounded papers, blog posts, and incremental publishing artifacts.

The focus is narrow: work where Chapel and property-based testing help make
kernel, path, timing, or host-optimization claims more measurable and
defensible.

## Ground rule

Do not write that Chapel/PBT "optimized the kernel" unless a measured before /
after result exists and the causal path is explicit.

The paper-safe claim today is narrower:

- Chapel expresses host-structure and timing proof surfaces.
- `quickchpl` property tests harden partitioning, determinism, and timing
  budget invariants.
- The generic-lane `HostNumaProbe` runs on `honey` and produces a real saved
  host-characterization result.
- RT host posture is separately measured through Dell-owned kernel validation,
  SMI, and `hwlat` evidence.
- A first generic/RT paired packet now exists, but it is not an improvement
  story yet: RT booted, SMI remained nonzero, and the first RT Chapel timing
  was slightly slower than the same-evening generic capture.
- A five-sample generic Chapel repeat series now exists and shows material
  variance under current lab load, which reinforces that matched repeat series
  are required before timing claims.

## Bodies of work

| Body of work | Publishing shape | Current readiness | Claim it can safely make | Missing before stronger claims |
| --- | --- | --- | --- | --- |
| Chapel/PBT as a host-characterization method | Short technical blog or methods note | Ready | Chapel and `quickchpl` can encode host partitioning, deterministic synthetic fixtures, and timing-budget invariants for a dual-socket workstation study. | None for method framing. Do not present it as empirical RT improvement yet. |
| Dell 7810 claim ladder for RT work | Blog post or talk section | Ready | RT work separates supplier facts, live boot proof, host posture validation, operational acceptability, and downstream software benefit. | None for framing; stronger result writing needs longer RT recovery and hwlat data. |
| Generic low-latency baseline closure | Results note | Near-ready | The generic `linux-xr` lane on `honey` has a measured Dell-owned low-latency baseline and tuned/cmdline closure. | Longer SMI and `hwlat` runs to make stronger timing claims. |
| Chapel live generic-lane result | Results note inside the methods paper | Near-ready | `HostNumaProbe` runs on `honey`; the current flat locale model explains `Sublocales: 0`; the five-sample generic series gives repeatable host-characterization output with visible variance, not a downstream XR result. | Decide whether stronger NUMA claims need a different Chapel execution model. |
| RT-lane Chapel comparison | Future results section | First packet captured | The same `HostNumaProbe` conforms on the RT lane under matched short SMI / `hwlat` context. The first paired result does not show RT timing improvement. | Repeated generic and RT Chapel captures before treating the delta as a benchmark result. |
| SMI / hwlat mitigation story | Future case-study section | Partial | Nonzero SMI persists in short generic and RT samples; bounded `hwlat` stayed low in the captured runs. | Longer repeated generic and RT samples, with exact BIOS/kernel/tuned context records. |
| Downstream RT software benefit | XoxDWM paper/blog, not Dell-first | Not ready here | Dell can provide C1/C2/C3 preconditions only. | A separate XoxDWM C4 result showing XR, compositor, or BCI software benefit under RT. |

## Incremental publishing ladder

### 1. Blog post: "Making Host Timing Claims Honest"

Status: draftable now.

Purpose:

- explain the C0/C1/C2/C3/C4 claim ladder
- show why `linux-xr`, Dell-7810, XoxDWM, rockies, and GloriousFlywheel are
  separate authority surfaces
- introduce Chapel/PBT as the formal-method side of the host evidence story

Evidence packet:

- [`../platform/rt-research-contract.md`](../platform/rt-research-contract.md)
- [`../tracking/rt-smi-numa-chapel-focus-2026-04-25.md`](../tracking/rt-smi-numa-chapel-focus-2026-04-25.md)
- [`claim-traceability.md`](claim-traceability.md)
- [`../platform/authority-map.md`](../platform/authority-map.md)

Do not claim:

- RT is the default workstation lane
- Chapel proved downstream XR/BCI benefit
- runner/cache jobs are host evidence

### 2. Methods note: "Chapel And PBT For Legacy Host Characterization"

Status: draftable now, with narrow results.

Purpose:

- show `HostNumaProbe`, `TimingProofs`, and `quickchpl` tests as a compact
  host-characterization method
- explain why deterministic synthetic fixtures matter before doing live timing
  comparisons
- describe how PBT catches bad partitioning or timing-budget assumptions before
  those assumptions reach kernel and RT result wording

Evidence packet:

- [`../../analysis/README.md`](../../analysis/README.md)
- [`../../analysis/examples/HostNumaProbe.chpl`](../../analysis/examples/HostNumaProbe.chpl)
- [`../../analysis/src/TimingProofs.chpl`](../../analysis/src/TimingProofs.chpl)
- [`../../analysis/test/TestHostNumaTiming.chpl`](../../analysis/test/TestHostNumaTiming.chpl)
- [`../platform/honey-chapel-live-result-2026-04-23.md`](../platform/honey-chapel-live-result-2026-04-23.md)

Safe result wording:

- "The first live generic-lane probe ran on `honey` and produced a saved
  replayable result."
- "The Chapel flat locale model explains why this result observes the host as a
  single locale while OS-side NUMA inventory remains the NUMA topology source."
- "The PBT suite validates host-analysis invariants; it does not itself prove
  lower latency."

### 3. Results note: "Generic Versus RT Host Posture On A T7810"

Status: ready for a cautious first packet note; not ready for strong results.

Purpose:

- compare generic and RT host posture using the same evidence schema
- tie Chapel probe output to kernel validation windows
- make the improvement claim only if the measured rows support it

Required evidence before a strong result:

- one generic baseline packet with kernel validation, SMI, `hwlat`, NUMA, and
  Chapel probe result
- one RT packet with the same capture set from the same validation window
- explicit note of recovery time and operational cost
- `KernelValidationRun` records for both lanes or a clear explanation for why a
  lane is out of scope

Candidate measured deltas:

- kernel fragment and cmdline closure before / after tuned management
- SMI count per bounded interval
- max `hwlat` over repeated intervals
- Chapel `HostNumaProbe` serial/parallel timings under matched host posture
- RT boot and return-to-generic recovery timing

Current 2026-04-25 packet:

- generic and RT Chapel probes both conform
- generic SMI samples: `74/30s`, `73/30s`, `74/30s`
- RT SMI samples: `66/30s`, `65/30s`, `74/30s`
- tracefs `hwlat` stayed at or below `2 us` in all six short windows
- first RT Chapel timing was slightly slower than the same-evening generic
  capture

### 4. Paper: "Formalizing Legacy Workstation Timing Claims With Chapel"

Status: outline only.

Purpose:

- present the Dell 7810 as a legacy dual-socket host converted into a measured
  RT/NUMA research platform
- show Chapel/PBT as the method surface
- show Dell-owned records as the evidence ledger
- keep XR/BCI application claims as downstream context, not proof

Minimum acceptance bar:

- generic and RT evidence packets are complete enough to compare
- longer SMI/`hwlat` runs exist
- matching RT-lane Chapel repeat captures exist or the single-packet limitation
  is explicitly called out
- the paper states whether Chapel is being used as host-characterization,
  compiler/toolchain research, or downstream application analysis

## Initial focused work session

For the first dedicated writing/research block, keep the goal small: produce a
truthful outline plus one evidence packet, not a full paper.

1. Choose the first output:
   `Blog post #1` or `Methods note #1`.
2. Freeze the claim boundary:
   use `claim-traceability.md` and `rt-research-contract.md`.
3. Build one evidence packet:
   generic `honey` kernel validation, SMI/`hwlat`, NUMA inventory, and Chapel
   generic-lane result.
4. Identify the missing stronger packet:
   longer generic/RT SMI and `hwlat` windows plus repeated Chapel captures.
5. Draft only the claims already backed by evidence.
6. Convert missing improvement claims into issue tasks, not prose placeholders.

## Research questions to answer next

1. Does the current Chapel flat locale model provide enough value for the
   paper, or do stronger NUMA claims require a different Chapel execution
   model?
2. Should the next host window collect the matching RT Chapel repeat series
   first, or prioritize longer SMI / `hwlat` windows before repeating Chapel?
3. Which kernel/path/timing change has the clearest before / after delta:
   tuned/cmdline closure, RT validation, SMI mitigation, or recovery timing?
4. Should the first public artifact be a methods blog, a host-results note, or a
   repo-boundary post that prepares readers for both?
5. What evidence from XoxDWM would be needed later for a downstream C4 software
   benefit claim?

## Current recommendation

Start with the methods blog.

It is the strongest publication surface today because it can honestly show
Chapel and PBT in action while treating the first generic/RT packet as a
measurement-boundary result, not an improvement result. Then use the blog to
define the evidence format for the later repeated generic-vs-RT results note.
