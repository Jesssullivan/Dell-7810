# RT, SMI, NUMA, And Chapel Focus Note

Date: 2026-04-25

Scope: `Dell-7810`, `tinyland-inc/linux-xr`, `rockies`, `XoxdWM`,
`GloriousFlywheel`, and the sibling `chapel` worktree.

Owner issues: `TIN-397`, `TIN-398`, `TIN-598`, `TIN-599`, `TIN-600`, `TIN-550`

Use this note to keep the current machine-research lane focused. It is not a
new authority layer; it is an index for the active RT, SMI, NUMA, Chapel,
runner, and publication boundaries.

## Repo Roles

| Repo | Role in this lane | Not its role |
| --- | --- | --- |
| `Dell-7810` | Host evidence authority for `honey`: BIOS, C-states, SMI, hwlat, tuned posture, kernel validation records, NUMA inventory, Chapel host probes, and publication claim ladder | XR runtime proof or kernel release authority |
| `tinyland-inc/linux-xr` | Kernel carry, RPM release, install and rollback flow, and upstream-watch surface | Dell-specific host acceptance or SMI/NUMA truth |
| `rockies` | Desktop-stack umbrella, dependency composition, and program-routing surface | Raw `honey` measurement store |
| `XoxdWM` | Downstream compositor, XR, and BCI software proof surface; owns `C4` application benefit claims | Dell host measurement authority |
| `GloriousFlywheel` | Shared Nix runner, cache, Attic, and Bazel substrate product surface | A Dell-specific runner fork |
| sibling `chapel` | Long-term Chapel compiler/toolchain authority candidate | Dell host evidence store |

## Current Claim Status

| Claim | Status | Current Dell-owned evidence | Gap |
| --- | --- | --- | --- |
| Generic low-latency host baseline | Established | `honey-live-baseline-2026-04-22.md`, kernel validation captures, tuned closure | Longer repeated hwlat or SMI runs |
| RT host boot and validation | Established for `C1` and `C2`; partial for `C3` | `rt-research-contract.md`, `honey-rt-validation-2026-04-23.md`, `KernelValidationRun` records | RT recovery remains slower and SMI count remains nonzero |
| RT downstream software benefit | Not established here | Dell can provide preconditions only | Belongs to `XoxdWM` as `C4` |
| Generic Chapel host probe | Established as a live generic-lane result with first repeat series | `honey-chapel-live-result-2026-04-23.md`, `chapel-host-probe-baseline.txt`, `chapel-host-probe-turnkey.txt`, `chapel-host-probe-generic-2026-04-25.txt`, `honey-generic-chapel-repeat-series-2026-04-25.md` | Decide whether stronger NUMA claims need a different Chapel execution model |
| RT-lane Chapel host probe | First packet captured | `chapel-host-probe-rt-2026-04-25.txt`, `honey-chapel-host-probe-rt-2026-04-25.dhall`, and same-boot RT SMI/hwlat samples | More samples before treating the generic/RT delta as a benchmark result |
| SMI and bounded hardware latency | Partial, paired short packet exists | Dell SMI/hwlat captures and validators, `honey-rt-smi-hwlat-chapel-series-2026-04-25.md` | Longer repeated generic and RT runs, tracked by `TIN-598` |
| Shared runner/cache dogfood | Blocked for this repo today | `gloriousflywheel-runner-reachability-2026-04-25.md` | Dell cannot currently reach a shared `tinyland-nix` runner |
| Bazel cache participation | Contract-compatible only | GloriousFlywheel contract language | Dell has no Bazel workload yet |

## Publication Options

| Option | Readiness | Shape |
| --- | --- | --- |
| Blog post on authority separation | Ready now | Explain why Dell host evidence, kernel release, runner substrate, and XR proof are separate repos. Use this as the public map before deeper results writing. |
| Methods-forward Chapel/PBT host-characterization note | Near-ready | Focus on Chapel as a formal host probe and PBT scaffold for timing/NUMA claims. Keep results narrow to the generic-lane live result and RT contract. |
| RT, SMI, and NUMA systems case study | First packet ready, strong claims not ready | Generic and RT Chapel captures now exist with matched short SMI/hwlat context; longer windows and more samples are still needed before making stronger empirical claims. |
| XR application benefit note | Not Dell-first | Requires `XoxdWM` `C4` evidence that consumes Dell host facts. |

## Active Gaps

1. `TIN-598`: a paired short SMI/hwlat packet now exists for generic and RT,
   but longer repeated windows are still missing.
2. `TIN-600`: the first RT-lane Chapel capture exists and generic repeats now
   exist; the remaining gap is a matching RT repeat series and cautious
   comparison.
3. `TIN-600`: decide whether future NUMA claims stay at OS inventory plus
   Chapel flat-locale observation, or require a different Chapel execution
   model.
4. `TIN-550`: Dell-7810 still has zero accessible shared self-hosted runners;
   do not treat queued or skipped dogfood jobs as runner proof.
5. `TIN-550`: Bazel cache wording must remain a contract surface until Dell
   grows a real Bazel workload.
6. `TIN-397` / `TIN-398`: tracker bodies should use `tinyland-inc/linux-xr`
   wording and current RT contract links, not older `linux-xr-fast` phrasing.
7. sibling `chapel`: the compiler/package authority still needs cleanup before
   Dell can retire its local continuity fallback.

## Next Bounded Moves

1. Refresh `TIN-397`, `TIN-398`, and `TIN-470` plus GitHub mirrors `#17`, `#18`,
   and `#21` so they describe current evidence rather than future work.
2. Keep `TIN-550` as the runner/cache blocker and do not introduce Dell-shaped
   runner labels or repo-scoped runner sets.
3. Split or refresh PR `#23` before merge, because later runner-boundary work
   exists on the broad stack.
4. Keep PR `#24` as the platform/RT authority slice; do not let Chapel, fan,
   or enclosure work leak into it.
5. Treat the first RT-lane Chapel capture as evidence, but do not publish a
   timing-improvement claim until repeated captures exist.
6. For the evening measurement packet, use
   [`../platform/honey-smi-numa-rt-evening-runbook-2026-04-25.md`](../platform/honey-smi-numa-rt-evening-runbook-2026-04-25.md):
   the generic and RT SMI/hwlat plus store-prebuilt Chapel captures are now
   complete once; use the result note before drafting claims.

## Peer Boundary Follow-Through

| Repo | PR | Status | Boundary hardened |
| --- | --- | --- | --- |
| `tinyland-inc/rockies` | [#121](https://github.com/tinyland-inc/rockies/pull/121) | Open; checks green; review required | Adds Dell-7810 to the cross-repo operator-surface map as the `honey` host-evidence authority. |
| `Jesssullivan/XoxdWM` | [#35](https://github.com/Jesssullivan/XoxdWM/pull/35) | Merged | Adds Dell-7810 to XoxdWM's remote-build authority map and keeps C4 software-benefit claims separate from Dell C1/C2/C3 host evidence. |
| `tinyland-inc/linux-xr` | [#27](https://github.com/tinyland-inc/linux-xr/pull/27) | Merged | Bounds `linux-xr` to C0 supplier facts and points `honey` workstation acceptance back to Dell-7810. |

## Residual Boundary Debt

| Surface | Current state | Next boundary move |
| --- | --- | --- |
| `tinyland-inc/linux-xr` README Dell troubleshooting | Dell now has `docs/platform/t7810-rt-boot-troubleshooting.md` for the durable host procedure. `linux-xr` PR [#29](https://github.com/tinyland-inc/linux-xr/pull/29) merged and replaces the long README troubleshooting body with a Dell pointer. | Keep future `linux-xr` wording to supplier-side requirements and historical kernel-debug context. |
| `XoxdWM` `justfile` honey BIOS/SMI helpers | Carries legacy BIOS, tuned, SMI, boot, and storage helper recipes. Several already prefer Dell-owned validators or profiles when the sibling repo exists. | Leave operator convenience wrappers in XoxdWM, but keep measurement, baseline, C-state, SMI, tuned, and rollback authority in Dell-7810. |
| `tinyland-inc/rockies` operator map | PR `#121` is green but review-gated. Until merged, rockies docs are not yet authoritative on the Dell-7810 role. | Merge after review, then update this note and any Linear/GitHub tracker status from "pending peer boundary" to "merged umbrella route." |
| Shared runner/cache lane | Dell-7810 records the GloriousFlywheel contract and reachability gap, but it still has no proven shared runner execution lane. | Keep runner work on `TIN-550`; do not add Dell-specific runner labels or repo-scoped runner assumptions. |

## Primary References

- [`../platform/rt-research-contract.md`](../platform/rt-research-contract.md)
- [`../platform/honey-kernel-posture-cross-repo-audit-2026-04-22.md`](../platform/honey-kernel-posture-cross-repo-audit-2026-04-22.md)
- [`../platform/honey-chapel-live-result-2026-04-23.md`](../platform/honey-chapel-live-result-2026-04-23.md)
- [`../platform/chapel-sourcing.md`](../platform/chapel-sourcing.md)
- [`../platform/authority-map.md`](../platform/authority-map.md)
- [`../platform/xoxdwm-symbiosis-touchpoints.md`](../platform/xoxdwm-symbiosis-touchpoints.md)
- [`../publication/rt-numa-chapel-experiment-matrix.md`](../publication/rt-numa-chapel-experiment-matrix.md)
- [`gloriousflywheel-runner-reachability-2026-04-25.md`](gloriousflywheel-runner-reachability-2026-04-25.md)
