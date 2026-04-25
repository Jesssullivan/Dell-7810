# GloriousFlywheel Runner Reachability Audit

Date: 2026-04-25

Scope: `TIN-550`, GitHub `#22`, upstream
`tinyland-inc/GloriousFlywheel#407`.

## Summary

Dell-7810 should remain a consumer of GloriousFlywheel shared capability
classes. It should not drive a Dell-shaped runner lane.

The checked-in Dell workflows correctly ask for `tinyland-nix`, but the repo
cannot currently reach that shared lane. That is an owner-boundary and
control-plane reachability blocker, not a reason to add `dell-7810-*` labels
or a Dell repo-scoped runner set.

## Evidence

Local Dell diagnostic:

```bash
just platform-runner-enrollment-status --no-cluster
```

Current result:

- `Jesssullivan/Dell-7810` reports zero accessible self-hosted runners through
  the repository runner API.
- Dell Chapel and kernel dogfood jobs are queued with `labels=tinyland-nix`.
- Those queued jobs still show `runner=null`, so they have not reached a live
  runner.

Live GloriousFlywheel ARC snapshot from the `honey` Kubernetes context:

| Scale set | GitHub config URL | Workflow label posture |
| --- | --- | --- |
| `tinyland-nix` | `https://github.com/tinyland-inc` | shared org lane |
| `tinyland-docker` | `https://github.com/tinyland-inc` | shared org lane |
| `tinyland-dind` | `https://github.com/tinyland-inc` | shared org lane |
| `tinyland-nix-heavy` | `https://github.com/tinyland-inc` | shared additive capability lane |
| `tinyland-nix-kvm` | `https://github.com/tinyland-inc` | shared additive capability lane |
| `tinyland-nix-gpu` | `https://github.com/tinyland-inc` | shared additive capability lane |
| `personal-nix` | `https://github.com/jesssullivan/jesssullivan.github.io` | legacy personal compatibility debt |
| `personal-docker` | `https://github.com/jesssullivan/jesssullivan.github.io` | legacy personal compatibility debt |
| `massageithaca` | `https://github.com/Jesssullivan/MassageIthaca` | live repo-shaped residue |

The `massageithaca` row is not a Dell fix. It is live GF drift to retire or
account for upstream.

## Constraint

GloriousFlywheel canon says capability classes are the product. Repo identity
is not runner taxonomy. Existing owner-scope plumbing and legacy compatibility
sets must not become the pattern for Dell.

GitHub's runner hierarchy also matters: GitHub documents self-hosted runner
registration at repository, organization, and enterprise scope. Organization
and enterprise runners can serve multiple repos inside those boundaries; a
Jess-owned personal-account-wide runner group is not a GitHub Actions scope.

Reference:
<https://docs.github.com/en/actions/how-tos/manage-runners/self-hosted-runners/add-runners>

## Compliant Paths

1. Move or mirror the Dell runner-consuming workflow surface under an enrolled
   organization or enterprise boundary that can use the shared
   `tinyland-nix` lane.
2. Change GloriousFlywheel owner-boundary / GitHub App / ARC control-plane
   wiring so `Jesssullivan/Dell-7810` can truthfully reach the shared
   `tinyland-nix` capability class without adding Dell-shaped labels or a Dell
   repo-shaped runner set.
3. Keep Dell-7810 explicitly blocked from counted shared-runner authority until
   one of the above is true.

## Non-Paths

- Do not add `dell-7810-*` runner labels.
- Do not add a Dell repo-scoped runner scale set in GloriousFlywheel.
- Do not repoint the legacy `personal-nix` compatibility lane to Dell as the
  normal solution.
- Do not claim Bazel, Attic, or runner authority from queued jobs that never
  receive a runner.

## Current Action

- Dell tracks the downstream blocker in `TIN-550` and GitHub `#22`.
- GloriousFlywheel tracks the upstream reachability blocker in `#407`.
- GloriousFlywheel should separately retire or account for the live
  `massageithaca-browser` / `massageithaca` repo-shaped ARC residue, since it
  contradicts the current no repo-shaped runner direction. This is tracked
  upstream as `tinyland-inc/GloriousFlywheel#409`.
