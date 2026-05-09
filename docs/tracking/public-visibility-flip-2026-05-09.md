# Public Visibility Flip - 2026-05-09

This is the operator log for the May 9, 2026 close of `TIN-683` readiness work.
The repository visibility flip itself is intentionally deferred and is **not**
performed in this pass.

Tracker: `TIN-683`. Successor to
[`public-readiness-audit-2026-04-26.md`](public-readiness-audit-2026-04-26.md),
[`public-candidate-branch-plan-2026-04-28.md`](public-candidate-branch-plan-2026-04-28.md),
and [`public-branch-exposure-audit-2026-04-28.md`](public-branch-exposure-audit-2026-04-28.md).

## Final state of the repository before the deferred flip

GitHub remote `Jesssullivan/Dell-7810`:

- visibility: private (unchanged)
- default branch: `main` at `b34f6a8` ("docs: finalize public-surface README caveats")
- remote heads: `main` only
- open pull requests: none
- closed pull requests visible to a future public viewer: `#12`, `#13`, `#14`,
  `#15`, `#23`, `#24`, `#26` (six drafts retired plus the public-candidate
  merge), and any earlier closed PRs the operator has not separately reviewed

`main` history:

```
b34f6a8 docs: finalize public-surface README caveats
892897d docs: trim generated public candidate artifacts
de7bef6 docs: record public branch exposure audit
95f583b docs: build public candidate slice
c11cb5d Bootstrap repo scaffold
```

## Validation gates passed on `main`

Run on `b34f6a8`:

- `just public-readiness-scan --strict --show-matches 3`: `0` findings across
  `agent-meta-dialog`, `exact-sudo-path`, `local-absolute-path`,
  `operator-ssh-target`, `private-network`, `hardware-identifiers`
- `nix shell nixpkgs#gitleaks -c gitleaks detect --source . --redact
  --no-banner --exit-code 1`: `5` commits scanned, `~2.2 MB`, `0` leaks

These are the same gates required by the `TIN-683` definition of done. They
were re-run on `main` after the rebase merge of PR `#26`.

## Actions completed in this pass

- closed draft PRs `#12`, `#13`, `#14`, `#15`, `#23`, `#24` with disposition
  comments naming the local evidence bundle and the live tracker disposition
  per issue
- deleted the corresponding remote branches:
  - `codex/issue-linked-measurement-workflow`
  - `jess/tin-338-research-dell-7810-proprietary-psu-distribution-board-and`
  - `jess/tin-339-capture-honey-reset-matrix`
  - `jess/tin-340-define-management-display-recovery-path`
  - `jess/tin-397-platform-rt-authority`
  - `jess/tin-550-runner-boundary-hygiene`
- merged `jess/tin-683-public-candidate` onto `main` via rebase (PR `#26`),
  then deleted the candidate branch from origin
- captured raw evidence into a local-only git bundle before any branch
  deletion: `~/git-archives/dell-7810-evidence-2026-05-09.bundle` (sha1, 20
  refs, 644 KiB, `git bundle verify` 2026-05-09 PASS)
- finalized the README "Public surface scope" section to reflect the public
  default-branch shape (commit `b34f6a8`)

## Why the visibility flip is deferred

The readiness deliverables on `TIN-683` are complete on `main`, but the
visibility flip itself is treated as a separate step from this readiness pass:

- the operator has accepted that closed-PR diffs and discussion remain visible
  on a public repository (`public-branch-exposure-audit-2026-04-28.md` "Do Not
  Do #2" knowingly accepted), but wants to inspect the final shape of `main`
  and the closed-PR surface in the GitHub UI before flipping
- the local evidence bundle is currently single-machine and should be moved
  off-machine before the flip removes the branches as a redundancy story
- the post-flip blog and publication wording on `jesssullivan.github.io` is not
  yet aligned with the neutral-to-negative RT result framing, and a public flip
  without aligned wording risks misreading

## Outstanding follow-up before the flip can be performed safely

1. operator-side review of the GitHub UI for `Jesssullivan/Dell-7810` while it
   is still private, to confirm closed-PR list, repo description, topics, and
   default-branch landing experience
2. move `~/git-archives/dell-7810-evidence-2026-05-09.bundle` off-machine, or
   to a private archive remote
3. align publication-program wording (`TIN-596` BoW-5, `TIN-597` BoW-3,
   `TIN-600` BoW-2) with the cautionary RT stance before any public link from
   the blog into the repo
4. optional: a second `gitleaks detect` and `public-readiness-scan --strict`
   immediately before running `gh repo edit ... --visibility public
   --accept-visibility-change-consequences`, since `main` may receive
   additional commits between this pass and the flip

When those are addressed, run:

```
gh repo edit Jesssullivan/Dell-7810 --visibility public --accept-visibility-change-consequences
```

Then post a closure note on `TIN-683` and add a final row to this document.

## Invariants to preserve until the flip

- do not push raw `data/captures/honey/` artifacts to `origin` while the flip
  is pending
- do not recreate any of the deleted draft branches on `origin`
- do not flip visibility while open PRs exist with raw-capture diffs
- do not treat this document as a snapshot of indefinitely current state; it
  is dated 2026-05-09 and applies to that pass
