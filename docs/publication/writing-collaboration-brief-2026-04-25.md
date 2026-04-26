# Writing Collaboration Brief

Date: 2026-04-25

Use this brief when collaborating with Claude, Codex, or another developer on
the Dell-7810 paper/blog/publishing lane.

The immediate goal is not to write the final paper. The goal is to carve the
work into evidence-backed publishable bodies of work, starting with Chapel and
property-based testing as the method surface for timing, NUMA, and kernel
posture claims.

## Start here

Read these first, in order:

1. [`README.md`](README.md)
2. [`claim-traceability.md`](claim-traceability.md)
3. [`rt-numa-chapel-experiment-matrix.md`](rt-numa-chapel-experiment-matrix.md)
4. [`chapel-pbt-publishing-roadmap-2026-04-25.md`](chapel-pbt-publishing-roadmap-2026-04-25.md)
5. [`../platform/rt-research-contract.md`](../platform/rt-research-contract.md)
6. [`../tracking/measured-evidence-map.md`](../tracking/measured-evidence-map.md)
7. [`paper-companion-standards.md`](paper-companion-standards.md)

Do not start from scattered chat context or from `XoxDWM` notes unless a Dell
publication doc explicitly points there.

For blog-post drafts that accompany papers or talks, use
[`paper-companion-standards.md`](paper-companion-standards.md) before applying
the public blog voice. Numbers, evidence paths, and claim boundaries come
first; narrative comes second.

## Collaboration contract

| Role | Good work | Avoid |
| --- | --- | --- |
| Writer | Turn an existing evidence packet into scoped prose. | Inventing results to make the story smoother. |
| Evidence reviewer | Check every claim against repo paths, data captures, or tracker issues. | Treating an unmerged PR or future experiment as evidence. |
| Experiment planner | Convert missing claims into capture tasks and acceptance criteria. | Expanding the paper scope before the first packet is coherent. |
| Peer-repo reviewer | Ensure `linux-xr`, `XoxDWM`, `rockies`, and GloriousFlywheel are cited only for their actual authority surfaces. | Pulling raw Dell host evidence into a peer repo as a second ledger. |

## Current publishable bodies

### Body 1: Methods blog

Working title:

- "Chapel And PBT For Legacy Host Characterization"

Ready now.

Claim:

- Chapel and `quickchpl` express and test host-characterization invariants for
  partitioning, deterministic fixtures, and timing budgets on a dual-socket
  workstation.

Evidence:

- [`../../analysis/README.md`](../../analysis/README.md)
- [`../../analysis/examples/HostNumaProbe.chpl`](../../analysis/examples/HostNumaProbe.chpl)
- [`../../analysis/src/TimingProofs.chpl`](../../analysis/src/TimingProofs.chpl)
- [`../../analysis/test/TestHostNumaTiming.chpl`](../../analysis/test/TestHostNumaTiming.chpl)
- [`../platform/honey-chapel-live-result-2026-04-23.md`](../platform/honey-chapel-live-result-2026-04-23.md)
- [`../platform/honey-rt-smi-hwlat-chapel-series-2026-04-25.md`](../platform/honey-rt-smi-hwlat-chapel-series-2026-04-25.md)
- [`../platform/honey-generic-chapel-repeat-series-2026-04-25.md`](../platform/honey-generic-chapel-repeat-series-2026-04-25.md)

Do not claim:

- Chapel reduced latency.
- RT behavior improved because of Chapel.
- The Dell repo proves a downstream BCI or XR result.

### Body 2: Claim-boundary blog

Working title:

- "Making Host Timing Claims Honest"

Ready now.

Claim:

- The project separates kernel supplier facts, live host validation, workstation
  operational acceptability, and downstream software benefit into different
  repos and claim levels.

Evidence:

- [`../platform/rt-research-contract.md`](../platform/rt-research-contract.md)
- [`../platform/authority-map.md`](../platform/authority-map.md)
- [`../tracking/rt-smi-numa-chapel-focus-2026-04-25.md`](../tracking/rt-smi-numa-chapel-focus-2026-04-25.md)

Do not claim:

- `linux-xr` proves `honey` is RT-acceptable.
- `XoxDWM` host smoke proves Dell timing readiness.
- GloriousFlywheel runner/cache jobs are host evidence.

### Body 3: Generic baseline results note

Working title:

- "Establishing A Low-Latency Generic Baseline On A Dell T7810"

Near-ready.

Claim:

- The generic `linux-xr` lane on `honey` has measured Dell-owned baseline
  posture and tuned/cmdline closure.

Evidence:

- [`../platform/honey-live-baseline-2026-04-22.md`](../platform/honey-live-baseline-2026-04-22.md)
- [`../platform/honey-bios-cstates-and-linux-xr-runbook-2026-04-22.md`](../platform/honey-bios-cstates-and-linux-xr-runbook-2026-04-22.md)
- [`../tracking/measured-evidence-map.md`](../tracking/measured-evidence-map.md)

Missing:

- longer repeated SMI / `hwlat` samples
- a clean evidence packet table that pairs kernel validation, NUMA inventory,
  SMI, `hwlat`, and Chapel result

### Body 4: Generic-vs-RT timing comparison

Working title:

- "Generic Versus PREEMPT_RT Host Posture On A Legacy Dual-Socket Workstation"

Staging-ready as a first packet note; not ready for a strong improvement
claim.

Claim:

- The same Dell-owned SMI/`hwlat`/Chapel capture shape now exists for generic
  and RT.
- The first paired packet does not show an RT timing improvement, so the
  result is a measurement-boundary story rather than an optimization story.

Already captured:

- longer generic and RT SMI / `hwlat` windows
- matching RT repeat series using the store-prebuilt Chapel path

Required before drafting stronger RT-benefit results:

- exact lab-load context for every timing row
- recovery-time notes for every one-shot RT boot
- fresh BIOS/C-state record if host settings change before reruns
- downstream audio, BCI, XR, or graphics deadline evidence

### Body 5: Downstream RT benefit

Not Dell-first.

This belongs in `XoxDWM` or another downstream repo after Dell provides host
preconditions and after the downstream repo proves C4 software benefit.

## Evidence packet template

Use this shape before drafting any results-heavy section:

| Field | Required value |
| --- | --- |
| Host | `honey` |
| Date/time window | Exact local date and, where possible, time window |
| Kernel lane | generic or RT |
| Kernel validation record | Path to capture and projected Dhall record |
| BIOS/C-state context | Path to BIOS record or check output |
| SMI sample | Path to raw `smi-validate` output |
| `hwlat` sample | Path to raw `smi-validate` / tracefs output |
| NUMA inventory | Path to JSON capture and Dhall projection |
| Chapel probe | Path to raw capture and result note |
| Recovery notes | Boot, reset, and return-to-generic notes |
| Claim level | C0, C1, C2, C3, or C4 |

If any field is missing, write it as missing evidence instead of smoothing over
it in prose.

## Suggested division of labor

1. Writer A drafts Body 1 from the analysis and Chapel result docs.
2. Reviewer B audits every sentence against `claim-traceability.md`.
3. Developer C builds the generic evidence packet table from existing captures.
4. Developer D plans the RT-lane evidence packet without running host-changing
   commands until the operator window is explicit.
5. Peer-repo reviewer checks whether any XoxDWM or linux-xr sentence should be
   downgraded to a citation or removed.

## Review checklist

Before publishing anything:

- Every measurement claim links to a Dell-owned capture, Dhall record, or
  result note.
- Every kernel supplier claim links to `linux-xr`.
- Every downstream XR/BCI claim links to `XoxDWM` and is marked as downstream.
- No claim says Chapel/PBT improved latency unless a before / after evidence
  packet proves it.
- No runner/cache claim is treated as live `honey` evidence.
- Missing evidence is tracked as work, not written as a future-tense result.

## First writing session outcome

The first useful shared session should produce:

- a one-page outline for Body 1
- a claim table with `safe`, `needs evidence`, and `do not say`
- one generic evidence packet table populated from existing captures
- a short list of missing RT repeat, SMI, and `hwlat` tasks for `TIN-598` and
  `TIN-600`

Do not let the first session expand into the full paper.
