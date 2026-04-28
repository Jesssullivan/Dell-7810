# Dell Linear SLA Todo Snapshot - 2026-04-28

This is a dated operator snapshot of Dell-related Linear work, based on live
Linear state checked on 2026-04-28. It also records the tracker cleanup actions
applied during the same pass. It is intentionally an internal planning map: use
`TIN-*` identifiers, not private Linear URLs, in repo docs.

Current repo state at snapshot time:

- Branch: `jess/tin-339-capture-honey-reset-matrix`
- Worktree: clean and aligned with origin
- Project: `Dell 7810 Honey Power & Enclosure Stabilization`
- Project status: `In Progress`

## SLA fire list

These are the Dell-owned items already in high-risk SLA state and breaching on
2026-04-29 unless completed, moved, or explicitly re-scoped.

| Issue | Priority | Status at live read | SLA state | Immediate action |
| --- | --- | --- | --- | --- |
| `TIN-337` | High | Backlog | High-risk; breaches 2026-04-29 01:33 ET | Parent issue is stale relative to active children. Move to `In Progress` or add a comment explaining that `TIN-338`, `TIN-339`, `TIN-397`, `TIN-398`, and `TIN-340` are the active closure stack. |
| `TIN-338` | High | In Progress | High-risk; breaches 2026-04-29 01:33 ET | Decide whether the PSU / RX 9070 XT power-path research memo is enough for current closure, or leave open only for physical validation of the external ATX supply path. |
| `TIN-339` | High | In Progress | High-risk; breaches 2026-04-29 01:34 ET | Refresh status against the broad current branch: reset evidence exists, but public candidate work should not be treated as reset-matrix closure. |
| `TIN-397` | High | In Progress | High-risk; breaches 2026-04-29 13:20 ET | Verify that BIOS A34, C-state, tuned, and `linux-xr` rollout docs are current; close or leave only a narrow follow-up for future BIOS-machine-check gaps. |
| `TIN-398` | High | In Progress | High-risk; breaches 2026-04-29 13:50 ET | Verify cross-repo kernel/RT wording against Dell, `linux-xr`, `rockies`, and XoxDWM. Keep the stance cautionary: RT is measurable, not proven beneficial. |

## Tracker updates applied

Applied on 2026-04-28 after the live read above:

| Issue | Change | Rationale |
| --- | --- | --- |
| `TIN-337` | `Backlog` -> `In Progress`; comment added | Parent was stale relative to active child stack. |
| `TIN-338` | `In Progress` -> `In Review`; comment added | Source-backed PSU / RX 9070 XT power-path memo exists; remaining work is physical validation or redesign. |
| `TIN-397` | `In Progress` -> `In Review`; comment added | BIOS A34, C-state, and `linux-xr` authority docs appear to satisfy the main documentation deliverable. |
| `TIN-398` | `In Progress` -> `In Review`; issue body corrected; comment added | RT-lane Chapel capture now exists, but evidence is cautionary or neutral-to-negative, not an improvement claim. |
| `TIN-683` | `Backlog` -> `In Progress`; comment added | Public-readiness is now active; next deliverable is a public candidate branch. |
| `TIN-550` | Comment added; status unchanged | Keep explicitly blocked on shared-runner reachability; do not add Dell-shaped runner authority. |

## Review closures applied

Applied after the in-review pass on 2026-04-28:

| Issue | Change | Mirror / PR update |
| --- | --- | --- |
| `TIN-338` | `In Review` -> `Done` | PR `#13` commented; PR remains draft for branch mechanics. |
| `TIN-397` | `In Review` -> `Done` | GitHub mirror `#17` commented and closed; PR `#24` commented. |
| `TIN-398` | `In Review` -> `Done` | GitHub mirror `#18` commented and closed; PR `#24` commented. |

These closures mean the tracker deliverables are complete on the current pushed
branch. They do not mean the draft PR stack is merged, public, or ready to flip
repository visibility.

## Current strategic Dell items

| Issue | Priority | Current status | SLA state | Current stance |
| --- | --- | --- | --- | --- |
| `TIN-683` | High | In Progress | High-risk 2026-05-02 21:41 ET; breaches 2026-05-03 21:41 ET | This is active work now. Next real deliverable is the public candidate branch, not more branch-wide auditing. |
| `TIN-550` | High | In Progress | High-risk 2026-05-01 00:35 ET; breaches 2026-05-02 00:35 ET | Keep blocked/truthful. Dell currently cannot claim shared `tinyland-nix` runner execution from this personal-account repo. Do not add Dell-specific runner labels or repo-scoped runner sets. |
| `TIN-340` | Medium | In Progress | No SLA | Can fold into `TIN-337` closure if the management-display / recovery path is documented enough for current operations. |

## Publication-adjacent Dell items

These belong to the paper/blog staging lane. They are Dell-related, but they
should not block the immediate platform SLA cleanup unless a public post is the
active deliverable.

| Issue | Priority | Status at live read | SLA state | Current stance |
| --- | --- | --- | --- | --- |
| `TIN-596` | High | In Progress | High-risk 2026-05-01; breaches 2026-05-02 | BoW-5 blog/staging should stay draft until public branch and claim boundary are clean. |
| `TIN-599` | High | Backlog | High-risk 2026-05-01; breaches 2026-05-02 | BoW-1 PBT paper needs fresh, citable PBT output before paper tables. |
| `TIN-600` | High | In Progress | High-risk 2026-05-01; breaches 2026-05-02 | BoW-2 has generic/RT packets, but current result is cautionary or neutral-to-negative, not an RT-improvement story. |
| `TIN-598` | Medium | In Progress | No SLA | SMI/hwlat note has paired packets; needs longer or BIOS-change-driven repeats before mitigation claims. |
| `TIN-601` | Medium | In Progress | No SLA | Venue research can proceed independently from the Dell SLA fire list. |

## Physical bench backlog

These are real Dell repo items, but they are not the current SLA fire.

| Issue | Priority | Status at live read | Next useful action |
| --- | --- | --- | --- |
| `TIN-396` | Medium | Backlog | Keep as fan authority research parent. |
| `TIN-468` | Medium | Backlog | Create the fan support matrix from measured inventory and ordered Noctua candidates. |
| `TIN-469` | Medium | Backlog | Execute Session 01 and turn measurement scaffolding into first evidence-backed printable revision. |

## Adjacent issues to keep separate

These are relevant to `honey`, RT, XR, or the runner substrate, but they are not
Dell-7810 repo closure items.

| Issue | Owning surface | Why separate |
| --- | --- | --- |
| `TIN-346` | XoxDWM | Urgent and already breached, but it is downstream VR smoke repeatability. Dell can provide host facts, not C4 software-benefit proof. |
| `TIN-612` / `TIN-622` | `linux-xr` | Bigscreen Beyond EDID upstream route belongs to the kernel supplier repo. |
| `TIN-213` | `rockies` / program topology | Broader canonical repo topology. Use it for cross-repo map cleanup, not Dell platform evidence closure. |
| `TIN-617`, `TIN-618`, `TIN-620`, `TIN-717` | infra / lab | Honey/sting/runner operational issues can affect availability, but should not be mixed into Dell public-readiness claims. |

## Recommended next moves

1. Refresh `TIN-339` as reset-matrix scope only; keep public branch work under
   `TIN-683`.
2. Build the public candidate branch for `TIN-683` from public-safe slices.
3. Keep `TIN-550` blocked on runner reachability rather than inventing a
   Dell-specific runner authority.
4. Decide whether physical PSU validation, future BIOS machine-checks, and
   longer SMI/hwlat runs need new narrow follow-up issues.
5. Do not promote the publication issues into claims until public-safe branch
   shape and result wording are both clean.
