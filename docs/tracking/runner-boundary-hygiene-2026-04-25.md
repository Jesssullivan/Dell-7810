# Runner Boundary Hygiene

Date: 2026-04-25

Tracker: `TIN-550` / GitHub `#22`

Upstream: `tinyland-inc/GloriousFlywheel#407`

## Purpose

This slice keeps Dell-7810 honest while the shared `tinyland-nix` runner lane is
not reachable by this repo.

Dell should be a consumer of the GloriousFlywheel pooled runner/cache substrate,
but this repository currently lives under a personal GitHub account. GitHub does
not provide an org-style personal-account runner group, so repo-scoped ARC
anchors would be compatibility debt, not pooled shared-runner authority.

## Current boundary

- Do not add Dell-specific runner labels.
- Do not add Dell repo-scoped runner scale sets.
- Do not count queued `runner=null` jobs as runner authority.
- Keep direct `honey` captures separate from cacheable CI proof.
- Keep cacheable Chapel/kernel workflows manual until an org/enterprise shared
  scope or equivalent shared runner proof exists.

## Repo posture

The cacheable workflows are intentionally `workflow_dispatch` only:

- `.github/workflows/chapel-ci.yml`
- `.github/workflows/chapel-dogfood.yml`
- `.github/workflows/kernel-dogfood.yml`

Each workflow requires `confirm_runner_reachable=true` before scheduling a
`tinyland-nix` job. After checkout, the jobs also verify that the later Chapel
or kernel/RT implementation slices are present before running build/projection
steps. This runner-boundary slice can therefore land first without silently
pretending the later implementation work is already merged.

## Diagnostic

Use:

```bash
just platform-runner-enrollment-status --no-cluster
```

Expected blocked result today:

- zero accessible self-hosted runners for `Jesssullivan/Dell-7810`
- no queued or pending runner jobs after stale queue cleanup
- explicit interpretation as personal-account owner-boundary debt

## Clean exits

One of these must become true before counting shared runner authority:

- move or mirror the cacheable workflow surface under an enrolled organization
  or enterprise shared scope
- prove an enterprise-level shared runner surface for the personal owner
- keep Dell-7810 explicitly blocked from counted shared-runner authority

Do not paper over this with `dell-7810-*` labels or repo-scoped ARC scale sets.
