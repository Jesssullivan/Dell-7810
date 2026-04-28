# Public Candidate Branch Plan - 2026-04-28

This note defines the next safe branch shape for making `Dell-7810` readable
by public blog or paper readers without exposing draft history, raw operator
captures, or misleading CI status.

Tracker: `TIN-683` / GitHub `#25`.

For the repository-level branch and PR exposure audit, see
[`public-branch-exposure-audit-2026-04-28.md`](public-branch-exposure-audit-2026-04-28.md).

## Current position

- Current repo visibility: private.
- Current integration branch: `jess/tin-339-capture-honey-reset-matrix`.
- Current public-readiness scan on the integration branch passes in non-strict
  mode and fails in strict mode by design.
- `agent-meta-dialog` and `exact-sudo-path` findings are zero.
- Remaining findings are raw/historical evidence classes:
  - `local-absolute-path`: `4`
  - `operator-ssh-target`: `84`
  - `private-network`: `27`
  - `hardware-identifiers`: `143`
- Raw capture index: `113` files.
  - `private-or-sanitized-summary`: `72`
  - `publish-derived-summary`: `32`
  - `public-ok`: `9`

The current branch is useful as an integration reference, not as the branch to
flip public directly.

## Branch strategy

Create a new public candidate branch only after choosing whether it is a
squash-clean branch or an issue-split stack.

Recommended shape:

1. Preserve the current private integration branch as the evidence source.
2. Create a new public candidate branch from the intended public base.
3. Cherry-pick or reconstruct only public-safe slices.
4. Keep raw `data/captures/honey/` files out of the public branch unless a raw
   file is explicitly approved by policy.
5. Keep sanitized summaries, derived CSVs, publication figures, and claim
   boundary docs.
6. Run strict public-readiness validation on that exact candidate branch before
   changing repository visibility.

Do not make the existing private repo public while draft PR branches still
contain old scratch docs, raw captures, or pre-redaction history. GitHub
visibility changes expose branch history, not just the current working tree.

## Public branch contents

Keep:

- `README.md` with explicit scope, CI, and evidence caveats.
- `LICENSE.md`, `LICENSES/Zlib.txt`, and dependency-license notes.
- measurement plans, templates, support matrices, and generated summaries.
- Dell-owned host result notes under `docs/platform/`, `docs/research/`, and
  `docs/publication/`.
- derived publication data and rendered figures under `docs/publication/`.
- scripts that use environment-driven operator targets such as
  `DELL_7810_TARGET`, `REMOTE_SUDO_PASSWORD_FILE`, and `SUDO_PASSWORD_FILE`.

Remove or replace:

- raw captures that disclose host targets, local paths, private connectivity
  hints, disk or display identifiers, firmware IDs, or runner topology.
- stale draft planning or scratch output that is not needed to reproduce a
  public claim.
- old branch history that predates redaction or license cleanup.

## Raw artifact policy

The default public interface is a result note or sanitized summary, not a raw
host capture.

Use the generated capture index as the triage input:

```bash
just public-capture-index
```

For each raw capture row:

- `private-or-sanitized-summary`: remove from public candidate branch or
  replace with a summary that preserves the measured result.
- `publish-derived-summary`: keep the derived doc/CSV/figure, not the raw file.
- `public-ok`: still review before publication; scanner silence is not an
  affirmative disclosure decision.

## CI and runner public note

Public readers should not infer project health from inactive cacheable CI on
this repo today.

Current CI truth:

- cacheable Chapel/kernel workflows are manual-only;
- they require `confirm_runner_reachable=true`;
- `Dell-7810` currently cannot truthfully reach the shared
  GloriousFlywheel `tinyland-nix` lane from this personal-account repo;
- direct `honey` evidence is a host-truth lane, not pooled CI authority;
- runner/lab outages should be treated as operational context, not proof that
  the research evidence is invalid.

Do not add Dell-specific runner labels or a Dell repo-scoped runner set to make
badges green. That would create a second, false runner authority surface.

## Publication claim boundary

A public branch may say:

- Dell-7810 owns workstation host evidence for the T7810 `honey` platform.
- Generic and RT host-characterization packets exist.
- RT is installed, bootable, measurable, and currently experimental.
- The measured RT packet is cautionary or neutral-to-negative for current
  Chapel/SMI/`hwlat` surfaces.

It must not say:

- RT improves this workstation.
- RT is required for the BCI/XR stack.
- Chapel proves downstream XR or BCI performance.
- XoxdWM software behavior is validated by Dell host evidence alone.

Use
[`../publication/rt-benefit-decision-framework-2026-04-26.md`](../publication/rt-benefit-decision-framework-2026-04-26.md)
and
[`../publication/claim-traceability.md`](../publication/claim-traceability.md)
before writing public copy.

## Validation gate

Run on the exact public candidate branch:

```bash
git status --short --branch
just --list
just public-capture-index
just public-readiness-scan --strict --show-matches 3
nix shell nixpkgs#gitleaks -c gitleaks detect --source . --redact --no-banner --exit-code 1
```

Public visibility is not ready until strict scan passes or each remaining
finding class is explicitly accepted in the artifact policy.
