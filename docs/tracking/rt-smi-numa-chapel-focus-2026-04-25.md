# RT, SMI, NUMA, And Chapel Focus Note

Date: 2026-04-25

Scope: `Dell-7810`, `tinyland-inc/linux-xr`, `rockies`, `XoxdWM`,
`GloriousFlywheel`, and the sibling `chapel` worktree.

Owner issues: `TIN-397`, `TIN-398`, `TIN-470`, `TIN-550`

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
| Generic Chapel host probe | Established as a live generic-lane result | `honey-chapel-live-result-2026-04-23.md`, `chapel-host-probe-baseline.txt`, `chapel-host-probe-turnkey.txt` | Decide whether stronger NUMA claims need a different Chapel execution model |
| RT-lane Chapel host probe | Missing | RT contract and generic Chapel path are ready | One saved RT-lane capture on `honey` |
| SMI and bounded hardware latency | Partial | Dell SMI/hwlat captures and validators | Longer repeated runs and any BIOS-side mitigation proof |
| Shared runner/cache dogfood | Blocked for this repo today | `gloriousflywheel-runner-reachability-2026-04-25.md` | Dell cannot currently reach a shared `tinyland-nix` runner |
| Bazel cache participation | Contract-compatible only | GloriousFlywheel contract language | Dell has no Bazel workload yet |

## Publication Options

| Option | Readiness | Shape |
| --- | --- | --- |
| Blog post on authority separation | Ready now | Explain why Dell host evidence, kernel release, runner substrate, and XR proof are separate repos. Use this as the public map before deeper results writing. |
| Methods-forward Chapel/PBT host-characterization note | Near-ready | Focus on Chapel as a formal host probe and PBT scaffold for timing/NUMA claims. Keep results narrow to the generic-lane live result and RT contract. |
| RT, SMI, and NUMA systems case study | Not ready | Needs longer SMI/hwlat samples and RT-lane Chapel evidence before making stronger empirical claims. |
| XR application benefit note | Not Dell-first | Requires `XoxdWM` `C4` evidence that consumes Dell host facts. |

## Active Gaps

1. `TIN-470`: the generic Chapel result exists, but the RT-lane Chapel capture
   does not.
2. `TIN-470`: decide whether future NUMA claims stay at OS inventory plus
   Chapel flat-locale observation, or require a different Chapel execution
   model.
3. `TIN-550`: Dell-7810 still has zero accessible shared self-hosted runners;
   do not treat queued or skipped dogfood jobs as runner proof.
4. `TIN-550`: Bazel cache wording must remain a contract surface until Dell
   grows a real Bazel workload.
5. `TIN-397` / `TIN-398`: tracker bodies should use `tinyland-inc/linux-xr`
   wording and current RT contract links, not older `linux-xr-fast` phrasing.
6. sibling `chapel`: the compiler/package authority still needs cleanup before
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
5. Resume RT-lane Chapel capture only after tracker and runner surfaces are
   calm enough to preserve the claim boundary.

## Peer Boundary Follow-Through

| Repo | PR | Status | Boundary hardened |
| --- | --- | --- | --- |
| `tinyland-inc/rockies` | [#121](https://github.com/tinyland-inc/rockies/pull/121) | Open; checks green; review required | Adds Dell-7810 to the cross-repo operator-surface map as the `honey` host-evidence authority. |
| `Jesssullivan/XoxdWM` | [#35](https://github.com/Jesssullivan/XoxdWM/pull/35) | Merged | Adds Dell-7810 to XoxdWM's remote-build authority map and keeps C4 software-benefit claims separate from Dell C1/C2/C3 host evidence. |
| `tinyland-inc/linux-xr` | [#27](https://github.com/tinyland-inc/linux-xr/pull/27) | Merged | Bounds `linux-xr` to C0 supplier facts and points `honey` workstation acceptance back to Dell-7810. |

## Residual Boundary Debt

| Surface | Current state | Next boundary move |
| --- | --- | --- |
| `tinyland-inc/linux-xr` README Dell troubleshooting | Still contains detailed T7810/SMI/RT boot-failure notes. The current live-host acceptance boundary now points back here, but the historical troubleshooting body is still in the kernel repo. | Keep only supplier-side requirements and historical kernel-debug context in `linux-xr`; move or summarize durable Dell host-validation procedure in this repo. |
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
