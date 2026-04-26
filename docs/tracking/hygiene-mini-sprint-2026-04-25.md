# Hygiene Mini-Sprint: Runner, Cache, Tracker, And Evidence Parity

Date: 2026-04-25

Branch: `jess/tin-339-capture-honey-reset-matrix`

Tracker: `TIN-550` / GitHub `#22`

Upstream runner fix: `tinyland-inc/GloriousFlywheel#407`

Reachability audit:
[`gloriousflywheel-runner-reachability-2026-04-25.md`](gloriousflywheel-runner-reachability-2026-04-25.md)

Goal: make the Dell-7810 workstream stable enough to resume RT, NUMA, SMI, and
Chapel publication work without continuing to overload one broad draft branch.

## Sprint Thesis

The repo is no longer missing structure. It is missing evenness.

The immediate sprint should not add more hardware claims. It should make the
current claims, runner assumptions, tracker state, and cross-repo boundaries
line up. After that, Session 01 measurements, fan support validation, and the
RT-lane Chapel result can proceed without confusing platform evidence with CI
or runner productization work.

## Non-Goals

- Do not invent Dell-specific runner labels.
- Do not add Dell repo-scoped runner scale sets in GloriousFlywheel.
- Do not treat `GloriousFlywheel` as a Chapel package source.
- Do not treat Bazel cache attachment as proven in this repo while this repo
  has no Bazel targets.
- Do not auto-promote manual `honey` evidence artifacts into repo truth.
- Do not run deeper RT or Chapel-on-RT measurements until tracker and runner
  surfaces are calm enough to preserve the claim boundary.

## Current Truth

| Surface | Current state |
| --- | --- |
| Git branch | Clean and tracking origin as of the last local check |
| Draft PR | `#14`, draft stack head, over 40 commits and roughly 190 changed files |
| Linear project | Marked `In Progress` on 2026-04-25 |
| GitHub mirrors | `#16` through `#22` exist; `#17`, `#18`, `#21`, and `#22` were refreshed or created during sprint kickoff |
| Runner enrollment | Dell-7810 workflows target `tinyland-nix`, but live repo access has reported zero usable self-hosted runners |
| Nix runner lane | Desired normal dogfood lane for Chapel and kernel validation |
| Bazel cache lane | GloriousFlywheel contract surface only; no Dell Bazel workload yet |
| Honey evidence lane | Manual hardware-subject evidence only |
| Chapel evidence | Generic-lane live and turnkey results exist; RT-lane Chapel result does not |
| Enclosure evidence | Session 01 still reports `0 / 29` measured rows |
| Fan evidence | Stock fan inventory and aftermarket fit/support rows are not yet measured |

## Authority Boundaries

| Area | Authority | Sprint rule |
| --- | --- | --- |
| Runner platform, ARC, cache injection | `../GloriousFlywheel` | Import the contract, do not fork the product |
| Chapel compiler packaging | `../chapel` long term | Dell keeps only a transitional continuity fallback |
| Dell host evidence | this repo | Raw captures, Dhall projections, and platform claims stay here |
| XR/application proofs | `../XoxdWM` | XoxdWM consumes Dell host facts by reference |
| `linux-xr` shipped kernels | `tinyland-inc/linux-xr` | Dell records host validation against shipped kernels; it does not become the kernel supplier |

## Track A: Tracker Truth

Purpose: make Linear and GitHub say what the repo already proves.

| Item | Action | Acceptance |
| --- | --- | --- |
| `TIN-397` / GitHub `#17` | Record that BIOS A34, C-state flow, and `linux-xr` runbook surfaces now exist | Tracker points at `docs/platform/honey-bios-cstates-and-linux-xr-runbook-2026-04-22.md` and `docs/platform/honey-live-baseline-2026-04-22.md` |
| `TIN-398` / GitHub `#18` | Record that RT wording is narrowed and cross-repo posture is documented | Tracker points at `docs/platform/rt-research-contract.md` and `docs/platform/honey-kernel-posture-cross-repo-audit-2026-04-22.md` |
| `TIN-470` / GitHub `#21` | Replace future-tense Chapel wording with current generic-lane result plus remaining RT-lane gap | Tracker points at `docs/platform/honey-chapel-live-result-2026-04-23.md` and names RT-lane Chapel as the next empirical gap |
| `TIN-550` / GitHub `#22` | Own this runner/cache parity sprint | Tracker points here and captures the shared-runner reachability blocker |
| Project status | Refresh Linear project summary and move out of `Planned` | Done: project status is `In Progress` as of 2026-04-25 |
| PR `#14` | Keep as draft stack head, not final merge target | PR body names runner reachability and [`pr14-split-plan-2026-04-25.md`](pr14-split-plan-2026-04-25.md) as blockers |

## Track B: GloriousFlywheel Runner Parity

Purpose: make Dell-7810 a real consumer of the shared capability-class lane.

| Item | Action | Acceptance |
| --- | --- | --- |
| Capability labels | Keep `tinyland-nix` as the normal shared lane | No repo-shaped labels such as `dell-7810-*` are introduced |
| Heavy lane | Reserve `tinyland-nix-heavy` for proven Chapel memory/time pressure | Heavy lane is not used by default |
| Enrollment | Resolve the personal-account owner-boundary without adding a Dell repo-scoped runner lane | A Dell workflow dispatch starts on a self-hosted runner through an org/enterprise shared scope, or Dell remains explicitly blocked from counted shared-runner authority |
| Runner contract | Reuse GloriousFlywheel's self-hosted contract: Nix bootstrap, Attic, optional Bazel cache, and finite runner capacity | Dogfood jobs log enough runner metadata to distinguish "queued for no runner" from "repo-side failure" |
| Honey runners | Keep `honey` runner labels for manual host-subject evidence only | `honey` lanes remain manual and artifact-only |

Current diagnosis from 2026-04-25:

- Dell-7810 dogfood jobs are queued with label `tinyland-nix` and
  `runner_name: null`.
- `Jesssullivan/Dell-7810` reports zero accessible self-hosted runners through
  the repository Actions runner API.
- The live GloriousFlywheel ARC `tinyland-nix` runner set is registered to
  `https://github.com/tinyland-inc`, not to the personal `Jesssullivan`
  account.
- The live `personal-nix` runner set is registered to
  `https://github.com/jesssullivan/jesssullivan.github.io`, so it cannot serve
  `Jesssullivan/Dell-7810` even though it carries a `tinyland-nix` label.
- The stricter GloriousFlywheel conclusion is that a personal-account repo
  cannot become a pooled shared-runner proof by adding repo-scoped ARC anchors.
  The compliant exits are moving or mirroring the workflow surface under an
  enrolled org/enterprise shared scope, proving an enterprise-level shared
  runner surface, or keeping Dell-7810 explicitly blocked from counted
  shared-runner authority.
- Do not create a Dell repo-scoped runner set or Dell-specific runner labels as
  the answer. This is tracked upstream as
  `tinyland-inc/GloriousFlywheel#407`.
- The detailed reachability audit records the live GF ARC snapshot and notes
  that `massageithaca-browser` / `massageithaca` is still present as
  repo-shaped ARC residue. GF has accounted for that residue in merged PR
  `tinyland-inc/GloriousFlywheel#411`; the live residue remains compatibility
  debt and is not precedent for Dell.
- GF merged `tinyland-inc/GloriousFlywheel#414` at `c2c3881` on 2026-04-25,
  adding a source-level ARC runner taxonomy guard. That guard prevents committed
  `extra_runner_sets` from introducing repo-scoped GitHub URLs or project-shaped
  labels such as Dell-specific runner names. This hardens the boundary but does
  not by itself make Dell-7810 reachable by `tinyland-nix`.
- GF merged `tinyland-inc/GloriousFlywheel#415` at `830e090` on 2026-04-25,
  clarifying the personal-account runner boundary: repo-scoped ARC anchors are
  compatibility debt, not pooled shared-lane authority.
- Dell cacheable runner workflows are manual-only while this is blocked. The
  automatic push/PR triggers are intentionally disabled so this personal-account
  repo stops producing known-unreachable `runner=null` queue noise.
- Manual cacheable workflow dispatches require `confirm_runner_reachable=true`.
  Without that acknowledgement, the `tinyland-nix` jobs are skipped instead of
  queued.

## Track C: Cache Contract Ingestion

Purpose: consume the GloriousFlywheel cache model without overstating what this
repo proves.

| Cache surface | Dell-7810 posture | Acceptance |
| --- | --- | --- |
| `ATTIC_SERVER` | Expected on self-hosted Nix runners through the shared setup path | Dogfood jobs can show whether Attic was injected |
| `ATTIC_CACHE` | Expected shared cache name, normally `main` | Jobs do not hardcode stale `fuzzy-dev` endpoints |
| `ATTIC_PUBLIC_KEY` | Optional read-substituter input | Used only when supplied by the shared contract |
| `BAZEL_REMOTE_CACHE` | Contract-compatible but currently unused by Dell workloads | Empty value means no Bazel proof, not a failure |
| `GF_BAZEL_SUBSTRATE_MODE` | Must agree with `BAZEL_REMOTE_CACHE` presence | If Dell adopts a Bazel target later, strict mode should pass before claiming shared-cache-backed Bazel |
| FlakeHub | Publication/discovery surface | Not used to paper over missing runner bootstrap or cache injection |

Near-term Dell work should either reuse a published GloriousFlywheel setup
action or add a small repo-local preflight that mirrors
`scripts/cache-attachment-contract.sh` without copying ownership of the
GloriousFlywheel product.

## Track D: CI Hygiene

Purpose: keep dogfood lanes and live evidence lanes symmetrical.

| Lane | Current file | Rule |
| --- | --- | --- |
| Chapel package/test dogfood | `.github/workflows/chapel-ci.yml` | Manual cacheable shared-runner lane until reachability is fixed |
| Chapel package/capture dogfood | `.github/workflows/chapel-dogfood.yml` | Manual cacheable shared-runner lane with artifacts until reachability is fixed |
| Chapel live host evidence | `.github/workflows/chapel-honey-evidence.yml` | Manual `honey` artifact lane |
| Kernel dogfood | `.github/workflows/kernel-dogfood.yml` | Manual cacheable shared-runner validation and Dhall reprojection until reachability is fixed |
| Kernel live host evidence | `.github/workflows/kernel-honey-evidence.yml` | Manual `honey` artifact lane |

Acceptance for this track is at least one successful shared-runner dogfood run
for Chapel and one for kernel validation, or a precise GloriousFlywheel-owned
runner enrollment issue explaining why Dell cannot yet schedule those jobs.

## Track E: Branch And PR Hygiene

Purpose: stop the current reset branch from becoming the permanent catch-all.

| Item | Action | Acceptance |
| --- | --- | --- |
| Current PR | Keep `#14` draft and honest | Body says it is a stack head, not a single issue slice |
| Follow-on branches | Prefer `TIN-468`, `TIN-469`, and `TIN-470` once active work moves | New measurement and fan work does not add unrelated CI churn |
| Merge path | Follow [`pr14-split-plan-2026-04-25.md`](pr14-split-plan-2026-04-25.md) rather than merging the broad stack as-is | Reviewer can tell what is being accepted |

## Track F: Evidence Closure Order

Purpose: resume empirical work in an order that improves signal.

| Order | Lane | Why |
| --- | --- | --- |
| 1 | Runner/cache parity | Keeps repeated Chapel/kernel work from becoming local-only toil |
| 2 | `TIN-469` Session 01 | Unblocks real enclosure geometry and printable revisions |
| 3 | `TIN-468` stock fan inventory | Grounds Noctua/support claims before acoustic follow-up |
| 4 | `TIN-600` matching RT Chapel repeat series | Extends the first generic/RT packet only after host and runner surfaces are calm |

## Sprint Done Criteria

- Linear and GitHub mirrors for `TIN-397`, `TIN-398`, `TIN-470`, and `TIN-600`
  no longer describe completed repo work as future work.
- PR `#14` remains draft but accurately describes stack shape, runner blocker,
  and split pressure.
- Dell-7810 can schedule at least one `tinyland-nix` job through an
  org/enterprise shared scope, or remains explicitly blocked with exact
  evidence.
- Chapel and kernel dogfood lanes preserve the same contract: cacheable runner
  validation is separate from manual `honey` evidence.
- Session 01 and fan inventory remain the next physical bench work, not another
  round of platform-doc expansion.

## Useful Checks

```bash
gh api repos/Jesssullivan/Dell-7810/actions/runners --paginate
gh run list --branch jess/tin-339-capture-honey-reset-matrix --limit 20
just platform-runner-enrollment-status
just chapel-source-status
just measurements-session-01-status
just measurements-session-01-evidence-status
just platform-xoxdwm-duplication-status
```

In `../GloriousFlywheel`, the relevant contract checks are:

```bash
just arc-runner-taxonomy-guard
just cache-contract
just cache-contract-strict
just info
```
