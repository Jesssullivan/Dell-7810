# Public Readiness Audit - 2026-04-26

This is a repo-publication checkpoint for `Jesssullivan/Dell-7810`.

Goal: make the repo safe for a curious reader following a Dell-related blog
post without leaking private operator topology, stale setup notes, or
unreviewed working scratch.

## Current repo state

- GitHub repo: `Jesssullivan/Dell-7810`
- Current visibility: private
- Default branch: `main`
- Current working branch: `jess/tin-339-capture-honey-reset-matrix`
- Local worktree state after fetch/pull: clean before this audit pass
- Local worktrees: one worktree at `/Users/jess/git/Dell-7810`

Open PR stack after refresh:

| PR | Head | Base | State | Note |
| --- | --- | --- | --- | --- |
| `#24` | `jess/tin-397-platform-rt-authority` | `jess/tin-338-research-dell-7810-proprietary-psu-distribution-board-and` | draft, clean | RT authority split |
| `#23` | `jess/tin-550-runner-boundary-hygiene` | `jess/tin-338-research-dell-7810-proprietary-psu-distribution-board-and` | draft, clean | runner/cache boundary hygiene |
| `#15` | `jess/tin-340-define-management-display-recovery-path` | `jess/tin-339-capture-honey-reset-matrix` | draft, unknown merge state | old stacked recovery-display branch; title still has visible `[codex]` marker |
| `#14` | `jess/tin-339-capture-honey-reset-matrix` | `jess/tin-338-research-dell-7810-proprietary-psu-distribution-board-and` | draft, clean | broad current stack head |
| `#13` | `jess/tin-338-research-dell-7810-proprietary-psu-distribution-board-and` | `main` | draft, clean | root power/reset research stack |
| `#12` | `codex/issue-linked-measurement-workflow` | `main` | draft, clean | old measurement workflow setup |

Important implication: do not flip repo visibility to public while all draft
branches remain published. Public visibility exposes remote branches and their
history, not just `main`.

## Linear state

Linear project:
`Dell 7810 Honey Power & Enclosure Stabilization`, status `In Progress`.

Current issue readout:

| Issue | State | Public-readiness interpretation |
| --- | --- | --- |
| `TIN-470` | Done | Chapel live-result lane is closed enough for repo evidence, but blog claims still need careful framing. |
| `TIN-338`, `TIN-339`, `TIN-340`, `TIN-397`, `TIN-398`, `TIN-550` | In Progress | These are active platform/reset/kernel/runner authority lanes; keep public wording conservative. |
| `TIN-337`, `TIN-396`, `TIN-468`, `TIN-469` | Backlog | Fan and enclosure measurements remain incomplete; do not present those as validated. |

The repo itself should avoid private Linear URLs. Numeric `TIN-*` IDs are fine
as internal traceability shorthand when the public surface also has GitHub
issue or repo-path evidence.

## Secret scan

Command run:

```bash
nix shell nixpkgs#gitleaks -c gitleaks detect --source . --redact --no-banner --exit-code 1
```

Result:

- `93` commits scanned
- no leaks found

This clears the first secret-detection gate, but it does not mean the repo is
public-safe. Gitleaks does not classify private infrastructure topology,
machine-local paths, hostnames, hardware serials, or stale internal planning
docs as secrets.

## Cleanup applied in this pass

- Added ignore rules for `.claude/`, `docs/private/`, `private/`, `scratch/`,
  and `tmp/`.
- Removed tracked `.claude/plans/cross-repo-authority-hardening.md`.
- Removed stale GitHub setup/recovery notes under `docs/github/`.
- Redacted the full Tailscale inventory from
  `data/captures/honey/reset-baseline-2026-04-22.json`.
- Replaced the exact `honey` management LAN address in research docs with a
  descriptive phrase.
- Converted repo-local absolute markdown links away from
  `/Users/jess/git/Dell-7810/...`.
- Removed the direct email address from `analysis/Mason.toml`.

## Remaining publicization blockers

| Blocker | Why it matters | Recommended action |
| --- | --- | --- |
| Draft branches and PR history | Deleted scratch docs and redacted captures remain in old commits on published branches. | Before making the repo public, merge/squash onto a clean public branch and delete or rewrite old draft branches. |
| No license file | Readers cannot tell what reuse is allowed. | Add an explicit license or a `LICENSE.md` stating no license / all rights reserved until decided. |
| Hardware unique IDs in tracked captures | Disk serials, UUIDs, EDID/DisplayID blobs, and firmware paths are useful evidence but over-specific for casual public readers. | Decide whether to keep raw captures private and publish sanitized summaries, or redact unique IDs in captures before public release. |
| Exact operator paths and host targets | `jess@honey`, `/home/jess`, `~/.config/sops-nix/secrets/become/password`, and runner paths disclose operator shape. | Either keep them as intentional reproducibility evidence or add a public-safe operator abstraction layer and generated sanitized captures. |
| Runner workflows are manual and expected to be stale | Lab/runner outages and personal-account runner limits mean public CI may appear inert. | Add a top-level public CI/status note before switching visibility. |
| Blog claim boundary depends on negative/neutral RT results | Current evidence does not support an RT improvement story. | Keep blog language aligned with `docs/publication/rt-benefit-decision-framework-2026-04-26.md` and measured evidence maps. |

## Public-ready target shape

Minimum acceptable public release shape:

1. `main` contains only clean, intentional, public-safe commits.
2. Stale draft branches are merged, deleted, or rewritten before visibility
   changes.
3. Secret scan passes on the exact public branch.
4. Local-path and tailnet inventory scans are clean or intentionally documented.
5. README states that measured host evidence is partial and that fan/enclosure
   validation is still in progress.
6. Publication docs clearly separate host characterization from XR runtime
   benefit claims.

## Suggested next slice

Create a `public-prep` branch from the current stack head and make it the
candidate public branch. The branch should:

- keep sanitized evidence summaries,
- drop private/scratch setup history,
- include a license decision,
- include a public CI/status note,
- and leave raw private captures either out of tree or behind an explicit
  private-artifact policy.
