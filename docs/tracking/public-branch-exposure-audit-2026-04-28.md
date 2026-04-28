# Public Branch Exposure Audit - 2026-04-28

Tracker: `TIN-683` / GitHub `#25` / draft PR `#26`.

This note answers a narrower question than the content scanner:

> If the private repository were made public today, which remote branches and
> PRs would become part of the public surface?

## Result

Do not flip the existing private repository public as-is.

The public candidate branch is clean enough for review, but the repository still
has open draft PRs and remote branches that carry raw captures or historical
operator detail. Visibility is a repository-level decision, not a branch-level
decision.

## Current GitHub Surface

- Repository: `Jesssullivan/Dell-7810`
- Visibility: private
- Default branch: `main`
- Open PRs: `7`
- Remote refs under `origin`: `8` branch refs plus the remote HEAD alias

Open PRs at audit time:

| PR | Head | Base | State | Public-readiness note |
| --- | --- | --- | --- | --- |
| `#26` | `jess/tin-683-public-candidate` | `main` | open draft | candidate branch for public review |
| `#24` | `jess/tin-397-platform-rt-authority` | `jess/tin-338-research-dell-7810-proprietary-psu-distribution-board-and` | open draft | raw capture / platform-authority workstream |
| `#23` | `jess/tin-550-runner-boundary-hygiene` | `jess/tin-338-research-dell-7810-proprietary-psu-distribution-board-and` | open draft | runner boundary workstream, not publicization target |
| `#15` | `jess/tin-340-define-management-display-recovery-path` | `jess/tin-339-capture-honey-reset-matrix` | open draft | stacked on raw reset-matrix branch |
| `#14` | `jess/tin-339-capture-honey-reset-matrix` | `jess/tin-338-research-dell-7810-proprietary-psu-distribution-board-and` | open draft | broad stack head with raw captures |
| `#13` | `jess/tin-338-research-dell-7810-proprietary-psu-distribution-board-and` | `main` | open draft | research base branch, not publicization target |
| `#12` | `codex/issue-linked-measurement-workflow` | `main` | open draft | old measurement workflow branch |

## Remote Branch Exposure

The following counts are simple `git grep` / tree inventory counts over remote
refs. They are intentionally conservative and include some self-referential
matches in scanner source files. For the candidate branch, the authoritative
gate remains `just public-readiness-scan --strict`.

| Remote ref | Commits ahead of `main` | Files | Raw captures | Local path hits | Operator target hits | Private network hits | Hardware ID hits | Agent/meta hits | Classification |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| `origin/main` | 0 | 36 | 0 | 0 | 0 | 0 | 2 | 0 | scaffold, not sufficient as public target |
| `origin/codex/issue-linked-measurement-workflow` | 2 | 42 | 0 | 0 | 0 | 0 | 2 | 0 | stale draft branch |
| `origin/jess/tin-338-research-dell-7810-proprietary-psu-distribution-board-and` | 1 | 38 | 0 | 0 | 0 | 1 | 2 | 0 | private research base |
| `origin/jess/tin-339-capture-honey-reset-matrix` | 98 | 343 | 113 | 9 | 86 | 31 | 144 | 1 | keep private; raw evidence branch |
| `origin/jess/tin-340-define-management-display-recovery-path` | 3 | 40 | 0 | 0 | 0 | 1 | 2 | 0 | stacked draft branch |
| `origin/jess/tin-397-platform-rt-authority` | 2 | 128 | 44 | 9 | 31 | 19 | 11 | 0 | keep private; raw evidence branch |
| `origin/jess/tin-550-runner-boundary-hygiene` | 2 | 44 | 0 | 0 | 0 | 1 | 2 | 0 | private runner-boundary branch |
| `origin/jess/tin-683-public-candidate` | 1 | 231 | 0 | 2 | 2 | 21 | 3 | 1 | review candidate; strict scanner passes |

Candidate branch validation:

```sh
git diff --cached --check
just --list
just public-readiness-scan --strict --show-matches 10
nix shell nixpkgs#gitleaks -c gitleaks detect --source . --redact --no-banner --exit-code 1
```

Validation result for `jess/tin-683-public-candidate` commit `32cac59`:

- whitespace check: pass before commit
- just recipe parse: pass
- public-readiness strict scan: pass, `0` findings
- gitleaks: pass, no leaks found

Follow-up content review:

- commit `dad8279`: recorded this branch/PR exposure audit
- generated STL decision: keep OpenSCAD source, recipes, and print manifests;
  omit newly generated Session 01 placeholder meshes from the public candidate
  branch until a measured or built revision is intentionally promoted
- public branch status wording: README now states that raw captures are omitted
  from the public candidate branch by default

## Recommendation

Use one of these paths:

1. Public mirror path: create or populate a separate public repository from the
   reviewed `jess/tin-683-public-candidate` tree. Keep this private repo as the
   raw evidence archive.
2. Clean-main path: after reviewing PR `#26`, replace the intended public
   branch with the candidate tree and remove or archive private draft branches
   before any visibility change.

The public mirror path is lower risk because it avoids exposing historical
draft PRs, raw-capture branch history, and private review discussion.

## Do Not Do

- Do not make the current private repository public while PRs `#12`, `#13`,
  `#14`, `#15`, `#23`, and `#24` remain part of the visible GitHub surface.
- Do not treat branch deletion alone as a complete privacy control for old PR
  history.
- Do not publish raw `data/captures/` as casual reader artifacts. Publish
  sanitized summaries and derived tables unless a specific raw artifact has
  been reviewed and explicitly approved.
