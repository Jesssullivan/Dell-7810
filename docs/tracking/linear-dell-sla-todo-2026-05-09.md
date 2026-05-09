# Dell Linear SLA Todo Snapshot - 2026-05-09

This is the dated successor to
[`linear-dell-sla-todo-2026-04-28.md`](linear-dell-sla-todo-2026-04-28.md).
It records the May 9, 2026 tracker pass that closed the `TIN-683` readiness
deliverable and refreshed the integration-branch tickets after the
clean-main public-candidate merge.

Current repo state at snapshot time:

- Default branch: `main` at `b34f6a8` ("docs: finalize public-surface README caveats")
- Worktree: clean and aligned with origin
- Project: `Dell 7810 Honey Power & Enclosure Stabilization`
- Project status: `In Progress`
- Repository visibility: private (flip deferred per
  [`public-visibility-flip-2026-05-09.md`](public-visibility-flip-2026-05-09.md))

## Tracker updates applied

| Issue | Change | Rationale |
| --- | --- | --- |
| `TIN-339` | Status unchanged (`In Progress`); refresh comment added | 2026-05-05 BS2E reseat row and 2026-05-08 `linux-xr` xr10 boot proof are recorded outside the matrix doc; matrix expansion still owed; kernel baseline changed under the matrix's foot |
| `TIN-683` | `In Review` -> `Done` | Readiness deliverables complete on `main`; visibility flip deferred per dated tracking doc, not blocked on tracker |

## Closed draft PRs and their tracker disposition

All six pre-public draft PRs were closed and their remote branches deleted in
this pass. Linear status for the underlying issues was not changed by the PR
closure; closure was branch-shape work for the public-readiness lane.

| PR | Source branch | Linear disposition after PR close |
| --- | --- | --- |
| `#12` | `codex/issue-linked-measurement-workflow` | no Linear ticket; old measurement-workflow scaffolding superseded by candidate slice |
| `#13` | `jess/tin-338-...` | `TIN-338` already `Done` 2026-04-28 |
| `#14` | `jess/tin-339-capture-honey-reset-matrix` | `TIN-339` stays `In Progress`; matrix rows still owed |
| `#15` | `jess/tin-340-define-management-display-recovery-path` | `TIN-340` stays `In Progress`; may fold into `TIN-337` closure |
| `#23` | `jess/tin-550-runner-boundary-hygiene` | `TIN-550` stays `In Progress`, intentionally blocked on shared runner reachability |
| `#24` | `jess/tin-397-platform-rt-authority` | `TIN-397` and `TIN-398` already `Done` 2026-04-28 |

Raw evidence preserved in
`~/git-archives/dell-7810-evidence-2026-05-09.bundle` before any branch
deletion (sha1, 20 refs, 644 KiB, verified 2026-05-09).

## Current Dell-owned items

| Issue | Priority | Current status | Current stance |
| --- | --- | --- | --- |
| `TIN-337` | High | In Progress | Parent is now reset/recovery scope; closure can wait for the `TIN-340` recovery-display documentation to be folded in |
| `TIN-339` | High | In Progress | Matrix capture continues; future rows must declare kernel baseline `6.19.5-10.xr.el10.x86_64` since that is now `honey`'s active kernel |
| `TIN-340` | Medium | In Progress | Management-display / recovery path documentation; may fold into `TIN-337` closure |
| `TIN-550` | High | In Progress | Intentionally blocked on shared `tinyland-nix` runner reachability; do not add Dell-shaped runner authority |
| `TIN-683` | High | **Done** | Readiness deliverables complete on `main`; visibility flip itself deferred to a later operator pass |

## Publication-adjacent Dell items

These remain on the publication staging lane and are not advanced by this pass.
Visibility-flip deferral is the load-bearing reason a public link from
`jesssullivan.github.io` into this repo should still wait.

| Issue | Priority | Status | Current stance |
| --- | --- | --- | --- |
| `TIN-596` | High | In Progress | BoW-5 blog draft must align with neutral-to-negative RT framing before public link |
| `TIN-597` | High | In Progress | BoW-3 C0-C4 claim ladder blog post; same gating as `TIN-596` |
| `TIN-598` | Medium | In Progress | SMI/hwlat note; needs longer or BIOS-change-driven repeats before mitigation claims |
| `TIN-599` | High | Backlog | BoW-1 PBT paper still needs fresh, citable PBT output |
| `TIN-600` | High | In Progress | BoW-2 packets exist; result is cautionary, not an RT-improvement story |
| `TIN-601` | Medium | In Progress | Venue research can proceed independently |

## Adjacent issues to keep separate

These remain owned by sibling repos or infrastructure surfaces. They were not
touched in this pass.

| Issue | Owning surface | Why separate |
| --- | --- | --- |
| `TIN-346` | XoxDWM | downstream VR smoke repeatability |
| `TIN-595` | XoxDWM | OpenXR smoke client RPM lane (recent merges) |
| `TIN-612` / `TIN-622` | `linux-xr` | Bigscreen Beyond EDID upstream route |
| `TIN-213` | `rockies` / program topology | broader canonical repo topology |
| `TIN-617`, `TIN-618`, `TIN-620`, `TIN-717` | infra / lab | honey/sting/runner operational issues |

## Recommended next moves

1. Inspect `Jesssullivan/Dell-7810` in the GitHub UI while still private; verify
   closed-PR list, repo description, topics, and default-branch landing
   experience match the public-surface intent.
2. Move `~/git-archives/dell-7810-evidence-2026-05-09.bundle` off-machine
   before performing the visibility flip.
3. Align `TIN-596` and `TIN-597` blog drafts with the cautionary RT stance,
   then schedule the actual visibility flip in a focused operator pass that
   re-runs both validation gates immediately before
   `gh repo edit ... --visibility public --accept-visibility-change-consequences`.
4. Continue `TIN-339` matrix expansion against the new `6.19.5-10.xr.el10`
   kernel baseline; record kernel baseline explicitly on every new row.
5. Do not advance `TIN-550` until shared-runner authority becomes available
   org-side; do not invent Dell-specific runner authority.
